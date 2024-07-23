export draw_line!, draw_sphere!, gauss_value

function sqr_dist_to_line(p::CartesianIndex, start, n)
    # Implementations for is_on_line
    d = Tuple(p) .- start
    return sum(abs2.(d .- sum(d.*n).*n)), sum(d.*n), sqrt(sum(abs2.(sum(d.*n).*n)));
end

"""
    draw_line!(arr, start, stop; thickness=0.5, intensity=one(eltype(arr)))

Draw a line in a 3D array by adding a Gaussian profile to the array.

#Arguments:
- `arr::Array`: A 3D array to which the line will be added.
- `start`: The starting point of the line as a tuple.
- `stop`: The stopping point of the line as a tuple.
- `thickness`: The thickness of the line. Default is 0.5.
- `intensity::Float64`: The intensity of the line. Default is 1.0.

"""
function draw_line!(arr, start, stop; thickness=0.5, intensity=one(eltype(arr)))
    direction = stop .- start
    line_length = sqrt(sum(abs2.(direction)))
    n = direction ./ line_length
    # Implementations for draw_line
    # println("Drawing line from $start to $stop")
    sigma2 = 2*thickness^2
    for p in CartesianIndices(arr)
        d2, t =sqr_dist_to_line(p, start, n)
        if (d2 < 4*thickness^2)
            if (t > 0 && t < line_length)
                arr[p] += intensity *exp(-d2/sigma2); # Gaussian profile
            elseif (t < 0 && t > -2*thickness)
                arr[p] += intensity *exp(-d2/sigma2)*exp(-(t*t)/sigma2); # Gaussian profile
            elseif (t > line_length && t < line_length + 2*thickness)
                arr[p] += intensity *exp(-d2/sigma2)*exp(-(t-line_length)^2/sigma2); # Gaussian profile
            end
        end
    end
end


"""
    draw_sphere!(arr, radius, center; thickness=0.8, intensity=one(eltype(arr)))

Draw a sphere in a 3D array by adding a Gaussian profile to the array.

#Arguments:
- `arr::Array`: A 3D array to which the sphere will be added.
- `radius`: The radius of the sphere as a number or tuple.
- `center`: The center of the sphere as a tuple. DEFAULT: size(arr).÷2 .+1 which is the (bottom-right) pixel from the center of the array
- `thickness`: The thickness of the sphere. Default is 0.8.
- `intensity::Float64`: The intensity of the sphere. Default is 1.0.

# Example

```jldoctest
julia> arr = zeros(Float32, (128, 128, 128));
julia> draw_sphere!(arr, 10);

julia> draw_sphere!(arr, (20,30,40), (50,30,80));
```

"""
function draw_sphere!(arr, radius, center=size(arr).÷2 .+1; thickness=0.8, intensity=one(eltype(arr)), filled=false)
    # Implementations for draw_line
    # println("Drawing line from $start to $stop")
    # creats on IndexFunArray to be used to measure distance. Note that this does not allocate or access an array
    d = rr(eltype(arr), size(arr), offset=center, scale=1 ./radius)
    rel_thickness = thickness ./ maximum(radius)
    sigma2 = 2*rel_thickness^2
    for p in CartesianIndices(arr)
        myd = d[p] .- one(real(eltype(arr)))
        if (filled)
            if (myd < 0)
                arr[p] += intensity;
            elseif (myd < 2*rel_thickness)
                arr[p] += intensity*exp(-myd*myd/sigma2); # Gaussian profile
            end
        else
            if (abs.(myd) < 2*rel_thickness)
                arr[p] += intensity*exp(-myd*myd/sigma2); # Gaussian profile
            end
        end
    end
end

function gauss_value(myd, sigma2, intensity, thickness, filled)::typeof(myd)
    ret = let 
        if (filled)
            if (myd > 0)
                intensity;
            elseif (myd < 2*thickness)
                intensity*exp(-myd*myd/sigma2); # Gaussian profile
            else
                0.0
            end
        else
            if (abs.(myd) < 2*thickness)
                intensity*exp(-myd*myd/sigma2); # Gaussian profile
            else
                0.0
            end
        end
    end    
    return ret
end
