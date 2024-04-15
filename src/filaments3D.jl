using FourierTools: shift, conv_psf, rotate
using IndexFunArrays:gaussian

export filaments3D, draw_line!, filaments_new!, filaments_rand!

"""
    filaments(asize = [100, 100, 100], Zfoc = asize[3] ÷ 2)

Create a 3D representation of filaments.

# Arguments
- `asize::Vector{Int}`: A vector of integers representing the size of the volume in which the filaments will be created. Default is [100, 100, 100].
- `Zfoc::Int`: An integer representing the z-coordinate of the focal slice. Default is asize[3] ÷ 2.

# Returns
- `obj::Array{Float64}`: A 3D array representing the filaments.

# Example
```julia
filaments((200, 200, 200))
```
"""
function filaments3D(sz = (128,128,128); num_filaments=10, seeding=true, Zfoc = sz[3] ÷ 2, thickness=0.8)
    if seeding
        Random.seed!(42)
    end

    obj = zeros(sz)  # Equivalent of newim
    mid = sz .÷ 2

    # Focal Slice 
    obj[mid[1] - floor(Int, 0.3 * sz[1]) : mid[1] + floor(Int, 0.3 * sz[1]), mid[2], Zfoc] .= 10
    focalSlice = obj[:, :, Zfoc]

    # Replace with Gaussian blurring function 
    myspot2 = gaussian(size(focalSlice), offset=Tuple(mid[1:2]), sigma=thickness)  
    focalSlice = conv_psf(focalSlice, myspot2)  # Assuming Images.jl has 'conv'

    obj[:, :, Zfoc] = focalSlice

    # ... (Implement similar logic for a, b, c, d )

    # a=select_rois(rotate(focalSlice,pi/5),size(focalSlice));
    a= rotate(focalSlice,pi/5)
    # b=shift(select_rois(rotate(focalSlice,0.7*pi),size(focalSlice)),[-20 0 0]);
    b=shift(rotate(focalSlice,0.7*pi),(-20, 0));
    c=shift(rotate(focalSlice,0.1*pi),(10, -5));
    d=shift(rotate(focalSlice,0.5),(0, 3));
    focalSlice2=focalSlice+a+b+c+d;


    obj[:,:,Zfoc]=focalSlice2;

    # Additional Filaments
    randAx = floor.(Int, 2 * rand(num_filaments)) .+ 1 
    randShifts = rand(-20:20, num_filaments)
    randRots = 5 .* rand(num_filaments)
    tmp3d = zeros(Tuple(sz))
    tmp3d[:, :, Zfoc] = a + b

    for i in 1:num_filaments÷2
        # Need implementations for rotate, select_rois, shift
        tmp = shift(rotate(tmp3d, randRots[i], filter(!=(randAx[i]), Tuple([1, 2, 3]))), (randShifts[i], 0, 0))
        obj += tmp  # Note: Julia indexing
    end

    # Similar loop for the second half of randAx
    for i in num_filaments÷2:num_filaments
        # Need implementations for rotate, select_rois, shift
        tmp = shift(rotate(tmp3d, randRots[i]*pi, filter(!=(randAx[i]), Tuple([1, 2, 3]))), (0, randShifts[i], 0))
        obj += tmp  # Note: Julia indexing
    end

    obj[obj .< 0] .= 0  # Clipping
    return obj
end

function filaments_rand!(arr; num_filaments=10, seeding=true)
    if seeding
        Random.seed!(42)
    end
    
    for i in 1:num_filaments
        #println("Drawing line $i")
        draw_line!(arr, Tuple(rand(10.0:size(arr, 1)-10, (1, 3))),  Tuple(rand(10.0:size(arr, 1)-10, (1, 3))), thickness= rand(0.0:2.0))
    end

end


function sqr_dist_to_line(p::CartesianIndex, start, n)
    # Implementations for is_on_line
    d = Tuple(p) .- start
    return sum(abs2.(d .- sum(d.*n).*n)), sum(d.*n), sqrt(sum(abs2.(sum(d.*n).*n)));
end

function draw_line!(arr, start, stop; thickness=0.5)
    direction = stop .- start
    line_length = sqrt(sum(abs2.(direction)))
    n = direction ./ line_length
    # Implementations for draw_line
    for p in CartesianIndices(arr)
        if (sqrt(sum(abs2.(Tuple(p) .- start))) < 2*thickness  || sqrt(sum(abs2.(Tuple(p) .- stop))) < 2*thickness)
            arr[p] = exp(-min(sum(abs2.(Tuple(p) .- start)), sum(abs2.(Tuple(p) .- stop)))/(2*thickness^2));
        end

        d2, t =sqr_dist_to_line(p, start, n)
        if (t > 0 && t < line_length && d2 < 4*thickness^2)
            arr[p] = exp(-d2/(2*thickness^2));
        end

    end
end

