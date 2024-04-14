using IndexFunArrays:rr, xx, yy, zz, phiphi
using FourierTools: shift

export Pollen3D

"""
    Pollen3D(sv = (128, 128, 128), dphi::Float64=0.0, dtheta::Float64=0.0)

Create a 3D representation of a pollen grain.

# Arguments
- `sv::Tuple`: A tuple of three integers representing the size of the volume in which the pollen grain will be created. Default is (128, 128, 128).
- `dphi::Float64`: A float representing the phi angle shift. Default is 0.0.
- `dtheta::Float64`: A float representing the theta angle shift. Default is 0.0.

# Returns
- `ret::Array{Float64}`: A 3D array representing the pollen grain.

# Example
```julia
Pollen3D((256, 256, 256), 0.0, 0.0)
```
"""
function Pollen3D(sv = (128, 128, 128), dphi::Float64=0.0, dtheta::Float64=0.0)
    x = xx(sv)
    y = yy(sv)
    z = zz(sv)

    m = (x .!= 0) 
    phi = zeros(size(x))  # Allocate
    phi[m] = atan.(y[m], x[m])

    phi .= phi .+ dphi  

    m = (z .!= 0)
    theta = zeros(size(x)) # Allocate
    theta[m] = asin.(z[m] ./ sqrt.(x[m].^2 + y[m].^2 + z[m].^2))

    theta .= theta .+ dtheta

    
    a = abs.(cos.(theta .* 20))
    # b=abs.(sin.(phi.*(cos.(theta).*10.0 .+1.0)))
    b = abs.(sin.(phi .* sqrt.(20^2 .* cos.(theta)) .- theta .+ pi/2)) 
    # b=abs.(cos.(phi.*9));
    c = ((0.4*sv[1] .+ (a .* b).^5 * sv[1]/20.0) .+ cos.(phi) .* sv[1]/20) 

    ret = rr(sv) .<= c
    ret = Array{Float64}(ret)
    ret .= (ret .*((rr(sv) .> (c .- sv[1]/100)))) 
    ret = permutedims(ret, [1, 3, 2]) 
    
    ret = abs.(shift(ret, (-round(Int, sv[1]/20), 0 ,0)))
    ret[ret .< 0.5] .= 0
    # ret = gaussf(ret, 0.5)  

    return ret
end
