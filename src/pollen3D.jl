using IndexFunArrays:rr, xx, yy, zz, phiphi

export pollen3D, pollen3D!

"""
    pollen3D(sv = (128, 128, 128), dphi::Float64=0.0, dtheta::Float64=0.0)

Create a 3D representation of a pollen grain.

# Arguments
- `sv::Tuple`: A tuple of three integers representing the size of the volume in which the pollen grain will be created. Default is (128, 128, 128).
- `dphi::Float64`: A float representing the phi angle offset in radians. Default is 0.0.
- `dtheta::Float64`: A float representing the theta angle offset in radians. Default is 0.0.

# Returns
- `ret::Array{Float64}`: A 3D array representing the pollen grain.

# Example
```jldoctest
pollen3D((256, 256, 256), 0.0, 0.0)
```
"""
function pollen3D(sv = (128, 128, 128); dphi=0.0, dtheta=0.0, thickness=0.8)
    return pollen3D(Float32, sv; dphi=dphi, dtheta=dtheta, thickness=thickness)
end

function pollen3D(::Type{T}, sv = (128, 128, 128); dphi=0.0, dtheta=0.0, thickness=0.8) where {T}
    obj = zeros(T, sv)
    pollen3D!(obj; dphi=dphi, dtheta=dtheta, thickness=thickness)
    return obj
end

function pollen3D!(arr; dphi=0.0, dtheta=0.0, thickness = 0.8, intensity=1.0, filled=false)
    sv = size(arr)
    x = xx(eltype(arr), sv)
    y = yy(eltype(arr),sv)
    z = zz(eltype(arr),sv)

    phi = phiphi(eltype(arr), sv)

    m = (z .!= 0)
    theta = zeros(eltype(arr), size(x)) # Allocate
    theta[m] = asin.(z[m] ./ sqrt.(x[m].^2 + y[m].^2 + z[m].^2)) .+ dtheta

    a = abs.(cos.(theta .* 20))

    b = abs.(sin.((phi .+ dphi) .* sqrt.(max.(zero(eltype(arr)), 20^2 .* cos.(theta))) .- theta .+ pi/2)) 

    # calculate the relative distance to the surface of the pollen grain
    dc = ((0.4*sv[1] .+ (a .* b).^5 * sv[1]/20.0) .+ cos.(phi .+ dphi) .* sv[1]/20) .- rr(sv)


    sigma2 = 2*thickness^2
    arr .+= gauss_value.(dc, sigma2, intensity, thickness, filled)
    return arr
end
