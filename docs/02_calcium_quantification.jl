### A Pluto.jl notebook ###
# v0.19.26

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ d749c49a-03b9-442a-9ebd-156d96125f2f
# ╠═╡ show_logs = false
begin
    using Pkg; Pkg.activate("."); Pkg.instantiate()

    using PlutoUI
    using MaterialDecomposition
    using CairoMakie
end

# ╔═╡ 60a723b6-ec12-4423-a9dd-ba687a6f148b
using ImageMorphology

# ╔═╡ a50f6c95-1d50-4687-8ec5-226a62151d3e
using Statistics

# ╔═╡ 4912ed62-ee82-4fe7-8ac9-b9202e54fac4
using DataFrames

# ╔═╡ d830e491-9b40-4a4b-b34e-ba11aeec0468
include(joinpath(pwd(), "utils.jl")); # helper functions for creating phantoms

# ╔═╡ d67d6012-06a3-477f-9a52-6e25d949f774
md"""
# Preliminaries

In this notebook, we'll be undertaking a step-by-step process to quantify calcium in digital phantoms using a combination of calibration and measurement techniques.

**Initialize the Julia Environment**: At the outset, we activate the Julia package environment and instantiate it. This ensures that all required packages are installed and ready for use.

**UI Interactivity with PlutoUI**: The `PlutoUI` package is employed to introduce interactive UI elements to the Pluto.jl notebook. Such dynamic elements, like sliders, enrich the user experience, making the analysis more user-friendly and engaging.

**Material Decomposition for Quantifying Calcium**: The `MaterialDecomposition` package provides essential tools for dissecting complex materials into their core components based on radiographic attributes. In this context, it plays a pivotal role in the analysis and quantification of calcium.

**Visualization Using CairoMakie**: For a visual representation of our data, `CairoMakie` serves as our go-to plotting backend. It's part of the Makie.jl visualization ecosystem, offering high-definition, antialiased graphics which are indispensable for visualizing our phantoms and associated masks.

**Table of Contents**: To enhance navigability, a dynamic table of contents is generated, reflecting the notebook's sections.

"""

# ╔═╡ 7960b4b1-5db8-4394-b8b6-eddf9a330ac1
TableOfContents()

# ╔═╡ 56b17c1c-9e48-40b8-844d-c62d090bc9e0
md"""
# Calcium Quantification

**Introducing Calcium Quantification**

In various medical and research contexts, quantifying calcium holds paramount importance. This is evident in scenarios such as assessing bone health and vascular calcifications. This section provides a comprehensive introduction to the notebook's primary objective: calcium quantification.
"""

# ╔═╡ a17648bb-b023-442a-be2c-1e93f46785cd
md"""
## Step 0. Create Calibration Phantom

**Calibration Phantom Creation**

A calibration phantom is essentially a model or object with pre-known properties, predominantly used to calibrate imaging systems. Within this step, we'll be crafting a digital calibration phantom. This phantom will incorporate nine calcium rods, each with a specified density. By gauging the intensities of these rods, we can formulate a calibration curve. This curve will correlate the known calcium density with the respective image intensity. This calibration process becomes crucial for the subsequent phases when the task is to quantify calcium samples of unknown densities.
"""

# ╔═╡ 4bc19299-cd03-47b7-93cd-f6b5439e39d1
begin
    densities_cal = [0.025, 0.050, 0.100, 0.200, 0.250, 0.350, 0.450, 0.550, 0.650] # mg/cm^3
    size_3d = (512, 512, 3)
	
    phantom_low_cal, masks_cal = create_calcium_calibration_phantom(
		size_3d, densities_cal; energy = 80
	)
    phantom_high_cal, _ = create_calcium_calibration_phantom(
		size_3d, densities_cal, energy = 135
	)
end;

# ╔═╡ e7114d1f-4273-446c-bb34-53d9329f5971
md"""
**Phantom Visualization and Mask Erosion**

For better calibration accuracy, it's essential to eliminate potential intensity dilution from surrounding tissues. Erosion is applied to the masks to shrink them slightly, ensuring they only capture the pure calcium rod intensities. This step aids in avoiding the partial volume effect. After mask erosion, the phantoms and their associated masks are visualized.

"""

# ╔═╡ 22ea4370-0fee-4a11-9288-7c82fdcca108
begin
    # Erode the masks to avoid partial volume effect from surrounding tissue
    masks_ero_cal = copy(masks_cal)
    for idx in axes(masks_ero_cal, 4)
        for _ in 1:3
            masks_ero_cal[:, :, :, idx] = erode(masks_ero_cal[:, :, :, idx])
        end
    end
end

# ╔═╡ f0aaa209-9b87-45ba-9b5c-854087ef7acf
md"""
Select Slice: $(@bind z_cal PlutoUI.Slider(axes(phantom_low_cal, 3), show_value = true))

Select Mask Number: $(@bind mask_num_cal PlutoUI.Slider(axes(masks_cal, 4), show_value = true))
"""

# ╔═╡ d6d0a34b-8369-4bc6-b921-a50aee4fc3f4
let
    mask_sel = masks_ero_cal[:, :, :, mask_num_cal];
    
    f = Figure(resolution = (1000, 1000))
    ax1 = CairoMakie.Axis(f[1:2, 1], title = "Calibration Phantom (Low Energy)", titlesize = 20)    
    hm1 = heatmap!(phantom_low_cal[:, :, z_cal], colormap = :grays)
    Colorbar(f[1:2, 2], hm1)

    ax2 = CairoMakie.Axis(f[3:4, 1], title = "Calibration Phantom (High Energy)", titlesize = 20)    
    hm2 = heatmap!(phantom_high_cal[:, :, z_cal], colormap = :grays)
    Colorbar(f[3:4, 2], hm2)

    ax3 = CairoMakie.Axis(f[2:3, 3], title = "Eroded Masks", titlesize = 20)    
    heatmap!(phantom_high_cal[:, :, z_cal], colormap = :grays)
    heatmap!(mask_sel[:, :, z_cal], colormap = (:jet, 0.5))
    f
end

# ╔═╡ 119218ab-4351-422e-a9ac-6ec234c8edbb
md"""
## Step 1. Fit Calibration
"""

# ╔═╡ d1baf735-6010-4047-9a7b-7469a9cf4498
md"""
**Calibration Curve Fitting**

By measuring the intensities of the eroded calibration rods at two different energies (low and high), we can form a calibration curve. This curve will be used later to quantify unknown calcium densities based on their intensities.

"""

# ╔═╡ 1735bf46-3ea7-46f3-9860-eaf78c746bda
begin
    intensities_low_cal = zeros(length(densities_cal))
    intensities_high_cal = zeros(length(densities_cal))
    
    for idx in axes(masks_ero_cal, 4)
        mask_sel = Bool.(masks_ero_cal[:, :, :, idx])
        
        intensity_low = phantom_low_cal[mask_sel]
        intensities_low_cal[idx] = mean(intensity_low)

        intensity_high = phantom_high_cal[mask_sel]
        intensities_high_cal[idx] = mean(intensity_high)
    end
    intensities_low_cal, intensities_high_cal
end

# ╔═╡ 09152a13-9b68-4728-982b-5b60ec040e4f
df_cal = DataFrame(
    "Density Calibration (mg/cm^3)" => densities_cal,
    "Intensity Calibration (Low Energy)" => intensities_low_cal,
    "Intensity Calibration (High Energy)" => intensities_high_cal
)

# ╔═╡ e42ca699-20ab-4a3b-a3cb-cf833e0b7fb3
begin
	p0 = zeros(8)
	intensities_total_cal = hcat(intensities_low_cal, intensities_high_cal)
	fit_params = fit_calibration(intensities_total_cal, densities_cal, p0)
end

# ╔═╡ 859004b0-9f80-416f-b7f7-25eae5d9cba4
md"""
## Step 2. Calculate Materials
"""

# ╔═╡ c2c70677-2e39-411b-9c78-307e2af9e32f
md"""
**Measurement Phantom Creation and Analysis**

With our calibration established, we move to analyzing a measurement phantom. This phantom contains calcium rods of known densities, but the goal is to test our calibration's accuracy by quantifying these rods without directly referencing their true densities. After creating the phantom, its visualizations are presented, and the intensity of each rod is measured at two different energies. Using our calibration from the previous step, we then predict the density of calcium in each rod.

"""

# ╔═╡ 5b7742d2-99bc-49d6-8bc2-f581d08aa92d
begin
	densities_meas = [0.125, 0.275, 0.425] # mg/cm^3
	phantom_low_meas, masks_meas = create_calcium_measurement_phantom(size_3d, densities_meas; energy = 80)
	phantom_high_meas, _ = create_calcium_measurement_phantom(size_3d, densities_meas; energy = 135)
end;

# ╔═╡ f255fc25-87af-46b2-9b2e-c1f8d4c7a020
md"""
**Dilation of Masks for Measurement Phantom**

In the context of image processing, dilation is a mathematical morphological operation that enlarges the boundaries of the foreground object. 

In this specific step, we dilate the masks associated with the measurement phantom. The primary motivation behind this dilation is to circumvent the partial volume effect that may arise from the surrounding tissue. The partial volume effect can cause blurring and if we don't include the surrounding tissue, some of the calcium intensity can be blurred into the surrounding background tissue and be lost in our measurements
"""

# ╔═╡ 0a9c44d8-607a-4733-9c69-3e616ea34385
begin
    # Dilate the masks to avoid partial volume effect from surrounding tissue
    masks_dil_meas = copy(masks_meas)
    for idx in axes(masks_dil_meas, 4)
        for _ in 1:5
            masks_dil_meas[:, :, :, idx] = dilate(masks_dil_meas[:, :, :, idx])
        end
    end
end

# ╔═╡ 225b3b0a-3671-4ec8-94e3-bde37763389c
md"""
Select Slice: $(@bind z_meas PlutoUI.Slider(axes(phantom_low_meas, 3), show_value = true))

Select Mask Number: $(@bind mask_num_meas PlutoUI.Slider(axes(masks_meas, 4), show_value = true))
"""

# ╔═╡ 9bb99377-120e-45cb-8d5e-50a9ea8bdff0
let
    mask_dil = masks_dil_meas[:, :, :, mask_num_meas];
    
    f = Figure(resolution = (1000, 1000))
    ax = CairoMakie.Axis(
        f[1:2, 1],
        title = "Measurement Phantom (Low Energy)",
        titlesize = 20
    )   
    hm = heatmap!(phantom_low_meas[:, :, z_meas], colormap = :grays)
    Colorbar(f[1:2, 2], hm)

    ax = CairoMakie.Axis(
        f[3:4, 1],
        title = "Measurement Phantom (High Energy)",
        titlesize = 20
    )   
    hm = heatmap!(phantom_high_meas[:, :, z_meas], colormap = :grays)
    Colorbar(f[3:4, 2], hm)

    ax = CairoMakie.Axis(
        f[2:3, 3],
        title = "Dilated Masks",
        titlesize = 20
    )   
    hm = heatmap!(phantom_low_meas[:, :, z_meas], colormap = :grays)
    hm = heatmap!(mask_dil[:, :, z_meas], colormap = (:jet, 0.5))
    f
end

# ╔═╡ 1317e00f-d0fe-46e7-9e34-7723aa92a542
begin
    intensities_low_meas = zeros(length(densities_meas))
    intensities_high_meas = zeros(length(densities_meas))
    
    for idx in axes(masks_dil_meas, 4)
        mask = Bool.(masks_dil_meas[:, :, :, idx])
        
        intensity_low = phantom_low_meas[mask]
        intensities_low_meas[idx] = mean(intensity_low)

        intensity_high = phantom_high_meas[mask]
        intensities_high_meas[idx] = mean(intensity_high)
    end
end

# ╔═╡ 1510ceb8-982d-4e8c-a75a-295be0875f4f
densities_pred = [quantify(intensities_low_meas[i], intensities_high_meas[i], fit_params) for i in 1:length(densities_meas)]

# ╔═╡ 4a63a0bd-e53a-4318-8bc8-37d205c263ea
df_meas = DataFrame(
    "Ground Truth Densities (mg/cm^3)" => densities_meas,
    "Predicted Densities (mg/cm^3)" => densities_pred
)

# ╔═╡ 24a59bbe-1fc6-486a-90a2-43b018193a15
md"""
**Adjustments and Conclusions**

Initially, the `quantify` function may underestimate the densities due to the dilated masks including non-calcified background tissue. To address this, the densities are converted to mass. This adjustment provides results that are closer to the expected outcomes. In the end, we present a comparison between the true and predicted masses of the calcium rods.

"""

# ╔═╡ 6f25ba7c-3801-4ddc-a3ff-a91a698154cb
begin
	voxel_vol = 0.5^3
	vol = sum(masks_meas[:, :, :, 1]) * voxel_vol
	gt_mass = densities_meas .* vol # mg
	
	vol_dil = sum(masks_dil_meas[:, :, :, 1]) * voxel_vol
	mass_pred = [quantify(intensities_low_meas[i], intensities_high_meas[i], fit_params, vol_dil) for i in 1:length(densities_meas)]
end

# ╔═╡ 986ad370-30c3-48d6-b98b-d059336c3e8f
df_mass = DataFrame(
    "Ground Truth Mass (mg)" => gt_mass,
    "Predicted Mass (mg)" => mass_pred
)

# ╔═╡ Cell order:
# ╟─d67d6012-06a3-477f-9a52-6e25d949f774
# ╠═d749c49a-03b9-442a-9ebd-156d96125f2f
# ╠═7960b4b1-5db8-4394-b8b6-eddf9a330ac1
# ╟─56b17c1c-9e48-40b8-844d-c62d090bc9e0
# ╟─a17648bb-b023-442a-be2c-1e93f46785cd
# ╠═d830e491-9b40-4a4b-b34e-ba11aeec0468
# ╠═4bc19299-cd03-47b7-93cd-f6b5439e39d1
# ╟─e7114d1f-4273-446c-bb34-53d9329f5971
# ╠═60a723b6-ec12-4423-a9dd-ba687a6f148b
# ╠═22ea4370-0fee-4a11-9288-7c82fdcca108
# ╟─f0aaa209-9b87-45ba-9b5c-854087ef7acf
# ╟─d6d0a34b-8369-4bc6-b921-a50aee4fc3f4
# ╟─119218ab-4351-422e-a9ac-6ec234c8edbb
# ╟─d1baf735-6010-4047-9a7b-7469a9cf4498
# ╠═a50f6c95-1d50-4687-8ec5-226a62151d3e
# ╠═4912ed62-ee82-4fe7-8ac9-b9202e54fac4
# ╠═1735bf46-3ea7-46f3-9860-eaf78c746bda
# ╠═09152a13-9b68-4728-982b-5b60ec040e4f
# ╠═e42ca699-20ab-4a3b-a3cb-cf833e0b7fb3
# ╟─859004b0-9f80-416f-b7f7-25eae5d9cba4
# ╟─c2c70677-2e39-411b-9c78-307e2af9e32f
# ╠═5b7742d2-99bc-49d6-8bc2-f581d08aa92d
# ╟─f255fc25-87af-46b2-9b2e-c1f8d4c7a020
# ╠═0a9c44d8-607a-4733-9c69-3e616ea34385
# ╟─225b3b0a-3671-4ec8-94e3-bde37763389c
# ╟─9bb99377-120e-45cb-8d5e-50a9ea8bdff0
# ╠═1317e00f-d0fe-46e7-9e34-7723aa92a542
# ╠═1510ceb8-982d-4e8c-a75a-295be0875f4f
# ╠═4a63a0bd-e53a-4318-8bc8-37d205c263ea
# ╟─24a59bbe-1fc6-486a-90a2-43b018193a15
# ╠═6f25ba7c-3801-4ddc-a3ff-a91a698154cb
# ╠═986ad370-30c3-48d6-b98b-d059336c3e8f
