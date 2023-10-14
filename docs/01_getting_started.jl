### A Pluto.jl notebook ###
# v0.19.26

#> [frontmatter]
#> title = "Getting Started"
#> category = "Tutorials"

using Markdown
using InteractiveUtils

# ╔═╡ a689b8ff-41c7-4083-a533-b73370410de1
# ╠═╡ show_logs = false
using Pkg; Pkg.activate("."); Pkg.instantiate()

# ╔═╡ 311b647f-1314-441d-901f-3655eabd4875
using MaterialDecomposition

# ╔═╡ 3fa63042-dbf8-4a59-ba41-00e6dde42c46
using PlutoUI

# ╔═╡ b13982a8-31f0-4134-8db9-b77c83265b3e
TableOfContents()

# ╔═╡ d00792b3-51e1-4a72-9920-92baf07f36e8
md"""
# Getting Started

Given a multi-energy CT scan with unknown materials (e.g. calcium, lipid, water, protein, etc) and the appropriate calibration scan, one can calculate the amount of material per voxel.
"""

# ╔═╡ e3aa868e-1ef7-43d5-adae-ac6a23a0fdbf
md"""
## Step 0. Prepare Calibration Scan

Multi-energy material decomposition requires that a calibration scan with known material(s) is prepared ahead of time. This calibration scan should have all of the same parameters (energy, etc) as the scan of interest.

Below is an image from [Measurement of coronary artery calcium volume using ultra-high-resolution computed tomography: A preliminary phantom and cadaver study](http://dx.doi.org/10.1016/j.ejro.2020.100253) which shows a commonly used calibration phantom containing various known densities of calcium
"""

# ╔═╡ 44185a1a-44cb-4303-992e-61c1e9d6dc05
Resource("https://www.researchgate.net/publication/344367457/figure/fig1/AS:939739788095488@1601062833431/Our-coronary-calcium-calibration-phantom-a-Photograph-of-the-coronary-calcium.png")

# ╔═╡ e7bf13b8-ad51-462a-ba39-6ba165dd09f9
md"""
## Step 1. Fit Calibration

Once the calibration phantom is scanned, the calibration scan is then used to prepare the fitted equation. This is similar to fitting a line given various points, just in multi-dimensional space.

The key function for this step in MaterialDecomposition.jl is `fit_calibration`
"""

# ╔═╡ 5214c739-8ae8-4843-9065-f51f8aee8c31
Resource("https://image.shutterstock.com/image-vector/types-correlation-scatter-plot-positive-260nw-2140738797.jpg")

# ╔═╡ 79f65861-e4b6-4805-acc6-c5c99b9121d0
md"""
## Step 2. Calculate Materials

Once the key equation is fit according to the data from the calibration scan (Step 0 & 1), this equation can then be used to quantify the amount of unknown material in future scans.

The key function in MaterialDecomposition.jl for this is `quantify()`
"""

# ╔═╡ 0d128764-56f3-48de-a5d0-50a36a8682e0
Resource("https://www.researchgate.net/publication/314971050/figure/fig3/AS:961372816945163@1606220549117/Sample-results-of-material-decomposition-of-PCD-CT-images-iodine-gadolinium-and_W640.jpg")

# ╔═╡ 4611790d-bf4d-4843-960b-0b6e501bb4c7
md"""
Source: [Dual-contrast agent photon-counting computed tomography of the heart: initial experience](https://link.springer.com/article/10.1007/s10554-017-1104-4)
"""

# ╔═╡ Cell order:
# ╠═a689b8ff-41c7-4083-a533-b73370410de1
# ╠═311b647f-1314-441d-901f-3655eabd4875
# ╠═3fa63042-dbf8-4a59-ba41-00e6dde42c46
# ╠═b13982a8-31f0-4134-8db9-b77c83265b3e
# ╟─d00792b3-51e1-4a72-9920-92baf07f36e8
# ╟─e3aa868e-1ef7-43d5-adae-ac6a23a0fdbf
# ╟─44185a1a-44cb-4303-992e-61c1e9d6dc05
# ╟─e7bf13b8-ad51-462a-ba39-6ba165dd09f9
# ╟─5214c739-8ae8-4843-9065-f51f8aee8c31
# ╟─79f65861-e4b6-4805-acc6-c5c99b9121d0
# ╟─0d128764-56f3-48de-a5d0-50a36a8682e0
# ╟─4611790d-bf4d-4843-960b-0b6e501bb4c7
