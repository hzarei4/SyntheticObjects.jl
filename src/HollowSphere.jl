using IndexFunArrays:rr
using FourierTools:ift

export HollowSphere

"""
    FourierSphere(sz::Vector{Int}, d::Float64, pixelsize::Vector{Float64}=[1.0, 1.0, 1.0])

Create a Fourier representation of a sphere.

# Arguments
- `sz::Vector{Int}`: A vector of integers representing the size of the sphere.
- `d::Float64`: A float representing the diameter of the sphere.
- `pixelsize::Vector{Float64}`: A vector of floats representing the pixel size. Default is [1.0, 1.0, 1.0].

# Returns
- `res::Array{Float64}`: A 3D array representing the Fourier sphere.

# Example
```julia
FourierSphere([128, 128, 128], 1.0, [1.0, 1.0, 1.0])
```
"""
function FourierSphere(sz::Vector{Int}, d::Float64, pixelsize::Vector{Float64}=[1.0, 1.0, 1.0])
    if length(pixelsize) > 2
        k = rr(Tuple(sz), scale=Tuple(1.0 ./ pixelsize ./ sz))
    else
        k = rr(Tuple(sz), "freq")
    end

    x = pi * k * d
    res = sin.(x) ./ x.^3 - cos.(x) ./ x.^2  # Element-wise operations with broadcasting

    mid = div.(sz, 2) .+1  # Integer division for finding the middle  
    res[mid[1], mid[2], mid[3]] = 1.0 / 3.0

    res = 3.0 .* res ./ sqrt(prod(sz)) 
    return res
end


"""
    HollowSphere(sz::Vector{Int}, rad1::Float64, thick::Float64=1.0, p::Vector{Float64}=[1.0, 1.0, 1.0])

Create a 3D representation of a hollow sphere.

# Arguments
- `sz::Vector{Int}`: A vector of integers representing the size of the sphere.
- `rad1::Float64`: A float representing the radius of the sphere.
- `thick::Float64`: A float representing the thickness of the sphere. Default is 1.0.
- `p::Vector{Float64}`: A vector of floats representing the pixel size. Default is [1.0, 1.0, 1.0].

# Returns
- `sph::Array{Float64}`: A 3D array representing the hollow sphere.

# Example
```julia
HollowSphere([128, 128, 128], 50.0, 10.0, [1.0, 1.0, 1.0])
```
"""
function HollowSphere(sz::Vector{Int}, rad1::Float64, thick::Float64=1.0, p::Vector{Float64}=[1.0, 1.0, 1.0])
    radinner = 2 .* rad1 .- thick ./ 2
    radout = 2 .* rad1 .+ thick ./ 2
    radratio = radout ./ radinner

    f = FourierSphere(sz, radout, p)
    f2 = FourierSphere(sz, radinner, p)
    fbig = abs.(ift(f))
    fsm = real(ift(f2))
    fsm .= fsm ./ (radratio.^3)  # Broadcast scaling in Julia
    sph = fbig - fsm

    return sph
end
