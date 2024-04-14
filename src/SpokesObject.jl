using IndexFunArrays:xx, yy, zz, phiphi, rr

export SpokesObject



"""
    SpokesObject(imgSize = (256, 256), numSpikes = 21, continuous = true, makeRound = true)

Generates a 2D or 3D representation of a spokes object.

# Arguments
- `imgSize::Tuple{Int, Int}`: A tuple of integers representing the size of the image. Default is (256, 256).
- `numSpikes::Int`: An integer representing the number of spikes. Default is 21.
- `continuous::Bool`: A boolean indicating whether the spokes are continuous. Default is true.
- `makeRound::Bool`: A boolean indicating whether the object is round. Default is true.

# Returns
- `obj2::Array{Float64}`: A 2D or 3D array representing the spokes object.

# Example
```julia
SpokesObject((512, 512), 30, false, false)
```
"""
function SpokesObject(imgSize = (256, 256), numSpikes = 21, continuous = true, makeRound = true)
    if makeRound
        obj = zeros(imgSize)
        rr_coords = rr(imgSize) #, "freq")
        obj[rr_coords .< 100.0] .= 1.0 
   else
        xx_coords = xx(imgSize) #, "freq")
        yy_coords = yy(imgSize) #, "freq")
        obj = (abs.(xx_coords) .< 0.4) .* (abs.(yy_coords) .< 0.4)
    end

    zchange = 1
    if length(imgSize) > 2 && imgSize[3] > 1
        zchange = zz(imgSize) #, "freq")
    end

    myphiphi = length(imgSize) > 2 ? repeat(phiphi(imgSize[1:2]), outer=(1, 1, imgSize[3])) : phiphi(imgSize)

    if !continuous
        obj[mod.(myphiphi .+ pi .+ 2 * pi * zchange, 2 * pi / numSpikes) .< 2 * pi / numSpikes / 2] .= 0
        obj2 = obj
    else
        obj2 = obj .* (1 .+ cos.(numSpikes * (myphiphi .+ 2 * pi * zchange)))
        
    end
    
    return Array{Float64}(obj2)
end
