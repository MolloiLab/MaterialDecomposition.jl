module MaterialDecomposition

using Revise
using LsqFit


"""
	fit_calibration(calculated_calcium_intensities, calcium_densities, p0::AbstractVector=zeros(8))

Calibration equation, where `p0` is a vector of initial parameters that must be fit to underlying data 
(`calculated_calcium_intensities`) which contains the "high" and "low" energy measurements for various 
densities of calcium calibration rods (`known_calcium_densities`). `LsqFit.curve_fit` then returns calibrated 
parameters `p`.

Note: `calculated_calcium_intensities` is expected to contain "low energy" intensity calculations in the first 
column of the `n x 2` array and "high energy" intensity calculations in the second column of the `n x 2` array.
"""
function fit_calibration(
    calculated_calcium_intensities::AbstractMatrix, 
    known_calcium_densities::AbstractVector, 
    p0::AbstractVector = zeros(8))

    F(x, p) = (p[1] .+ (p[2] .* x[:, 1]) .+ (p[3] .* x[:, 2]) .+ (p[4] .* x[:, 1] .^ 2) .+ (p[5] .* x[:, 1] .* x[:, 2]) .+ (p[6] .* x[:, 2] .^ 2)) ./ (1 .+ (p[7] .* x[:, 1]) + (p[8] .* x[:, 2]))

    p = LsqFit.curve_fit(F, calculated_calcium_intensities, known_calcium_densities, p0).param
    return p
end

"""
	quantify(low_energy_intensity, high_energy_intensity, p, alg::MaterialDecomposition)
    quantify(low_energy_intensity, high_energy_intensity, p, vol_ROI, alg::MaterialDecomposition)

Given a dual-energy CT image. First, calculate the measured intensity of a region of interest (ROI) 
with suspected calcium for both low (`low_energy_intensity`) and high (`high_energy_intensity`) energy scans, 
then utilize previously calibrated parameters (`p`) to calculate the 
density of the suspected calcium within the ROI.
"""
function quantify(low_energy_intensity, high_energy_intensity, p)
    A = p[1] + (p[2] * low_energy_intensity) + (p[3] * high_energy_intensity) + (p[4] * low_energy_intensity^2) + (p[5] * low_energy_intensity * high_energy_intensity) + (p[6] * high_energy_intensity^2)
    B = 1 + (p[7] * low_energy_intensity) + (p[8] * high_energy_intensity)
    F = A / B
    return F
end

function quantify(low_energy_intensity, high_energy_intensity, p, vol_ROI)
    A = p[1] + (p[2] * low_energy_intensity) + (p[3] * high_energy_intensity) + (p[4] * low_energy_intensity^2) + (p[5] * low_energy_intensity * high_energy_intensity) + (p[6] * high_energy_intensity^2)
    B = 1 + (p[7] * low_energy_intensity) + (p[8] * high_energy_intensity)
    F = A / B
    mass = F * vol_ROI
    return mass
end

export fit_calibration, quantify


end
