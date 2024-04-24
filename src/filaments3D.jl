using IndexFunArrays:gaussian
using Random

export filaments3D, filaments3D!

"""
    filaments3D!(obj; radius = 0.8, rand_offset=0.05, rel_theta=1.0, num_filaments=50, apply_seed=true, thickness=0.8)

Create a 3D representation of filaments.

# Arguments
- `obj`: A 3D array representing the volume into which the filaments will be added.
- `radius`: A tuple of real numbers (or a single real number) representing the relative radius of the volume in which the filaments will be created. 
    Default is 0.8. If a tuple is used, the filamets will be created in a corresponding elliptical volume.
    Note that the radius is only enforced in the version `filaments3D` which creates the array rather than adding.
- `rand_offset`: A tuple of real numbers representing the random offsets of the filaments in relation to the size. Default is 0.05.
- `rel_theta`: A real number representing the relative theta range of the filaments. Default is 1.0.
- `num_filaments`: An integer representing the number of filaments to be created. Default is 50.
- `apply_seed`: A boolean representing whether to apply a seed to the random number generator. Default is true.
- `thickness`: A real number representing the thickness of the filaments in pixels. Default is 0.8.

The result is added to the obj input array

# Example
```julia

# create a 100x100x100 volume with 10 filaments where only the central slice has a random arrangement of filaments
julia> obj = rand(100,100,100); # create an array of random numbers
julia> filaments3D!(obj; num_filaments=10, rel_theta=0, rand_offset=(0.1,0.1,0), intensity=2.0);

```
"""
function filaments3D!(obj; intensity = 1.0, radius = 0.8, rand_offset=0.05, rel_theta=1.0, num_filaments=50, apply_seed=true, thickness=0.8)
    # save the state of the rng to reset it after the function is done
    rng = copy(Random.default_rng());
    if apply_seed
        Random.seed!(42)
    end

    sz = size(obj)
    mid = sz .÷ 2 .+1

    # draw random lines equally distributed over the 3D sphere
    for n in 1:num_filaments
        phi = 2π*rand()
        #theta should be scaled such that the distribution over the unit sphere is uniform
        theta = acos(rel_theta*(1 -  2 * rand()));
        pos = (sz.*radius./2) .* (sin(theta) * cos(phi), sin(theta) * sin(phi), cos(theta));
        pos_offset = Tuple(rand_offset.*sz.*(rand(3).-0.5))
        # println("Drawing line $n at theta = $theta and phi = $phi")
        draw_line!(obj, pos.+pos_offset.+mid, mid.+pos_offset.-pos, thickness=thickness, intensity=intensity)
    end

    # reset the rng to the state before this function was called
    copy!(Random.default_rng(), rng);

    return obj
end

"""
    filaments3D([DataType], sz= (128, 128, 128), rand_offset=0.05, rel_theta=1.0, num_filaments=50, apply_seed=true, thickness=0.8)

Create a 3D representation of filaments.

# Arguments
- `DataType`: The datatype of the output array. Default is Float32.
- `sz`: A tuple of integers representing the size of the volume into which the filaments will be created. Default is (128, 128, 128).
- `radius`: A tuple of real numbers (or a single real number) representing the relative radius of the volume in which the filaments will be created. 
    Default is 0.8. If a tuple is used, the filamets will be created in a corresponding elliptical volume.
    Note that the radius is only enforced in the version `filaments3D` which creates the array rather than adding.
- `rand_offset`: A tuple of real numbers representing the random offsets of the filaments in relation to the size. Default is 0.05.
- `rel_theta`: A real number representing the relative theta range of the filaments. Default is 1.0.
- `num_filaments`: An integer representing the number of filaments to be created. Default is 50.
- `apply_seed`: A boolean representing whether to apply a seed to the random number generator. Default is true.
- `thickness`: A real number representing the thickness of the filaments in pixels. Default is 0.8.

The result is added to the obj input array

# Example
```julia

# create a 100x100x100 volume with 100 filaments where only the central slice has a random arrangement of filaments
julia> obj = filaments3D((100,100,100); rel_theta=0, rand_offset=(0.2, 0.2, 0));

# create a 100x100x100 volume with 100 filaments arranged in 3D
julia> obj = filaments3D((100,100,100));

```
"""
function filaments3D(::Type{T}, sz= (128, 128, 128); intensity=one(T), radius = 0.8, rand_offset=0.2, num_filaments=50, rel_theta=1.0, apply_seed=true, thickness=0.8) where {T}
    obj = zeros(T, sz)
    filaments3D!(obj; intensity=intensity, radius=radius, rand_offset=rand_offset, 
        num_filaments=num_filaments, apply_seed=apply_seed, rel_theta=rel_theta, thickness) 
    obj .*= (rr(eltype(obj), size(obj), scale=1 ./(sz .* radius./2)) .< 1.0)
    return obj
end

function filaments3D(sz= (128, 128, 128); intensity=one(Float32), radius = 0.8, rand_offset=0.2, num_filaments=50, rel_theta=1.0, apply_seed=true, thickness=0.8)
    return filaments3D(Float32, sz; intensity=intensity, radius=radius, rand_offset=rand_offset,
        num_filaments=num_filaments, apply_seed=apply_seed, thickness, rel_theta=rel_theta) 
end


# function filaments_rand!(arr; num_filaments=10, seeding=true)
#     if seeding
#         Random.seed!(42)
#     end
    
#     for i in 1:num_filaments
#         #println("Drawing line $i")
#         draw_line!(arr, Tuple(rand(10.0:size(arr, 1)-10, (1, 3))),  Tuple(rand(10.0:size(arr, 1)-10, (1, 3))), thickness= rand(0.0:2.0))
#     end

# end
