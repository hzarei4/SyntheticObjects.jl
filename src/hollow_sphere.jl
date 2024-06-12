export hollow_sphere!, hollow_sphere, object_3D

"""
hollow_sphere(obj, radius=0.8, center=sz.÷2 .+1; thickness=0.8)

Create a 3D representation of a hollow sphere.

# Arguments
- `obj`: A 3D array representing the object into which the sphere will be added.
- `radius`: A float representing the radius of the sphere.
- `thickness`: A float representing the thickness of the sphere in pixels. Default is 0.8.
- `center`: A tuple representing the center of the sphere. Default is the center of the object.

# Returns
- `sph::Array{Float64}`: A 3D array representing the hollow sphere.

# Example
```jldoctest
# create a centered sphere of 80% of the object size with a thickness of 0.8 pixels
julia> obj = zeros(Float64, (128, 128, 128));
julia> hollow_sphere(obj, 0.8)
```
"""
function hollow_sphere!(obj, radius=0.8, center=size(obj).÷2 .+1; thickness=0.8)
    draw_sphere!(obj, size(obj).*radius./2, center, thickness=thickness)
    return obj
end

"""
hollow_sphere([DataType], sz= (128, 128, 128), radius=0.8, center=sz.÷2 .+1; thickness=0.8)

Create a 3D representation of a hollow sphere.

# Arguments
- `DataType`: The optional datatype of the output array. Default is Float32.
- `sz`: A vector of integers representing the size of the sphere.
- `radius`: A float representing the radius of the sphere.
- `thickness`: A float representing the thickness of the sphere in pixels. Default is 0.8.
- `center`: A tuple representing the center of the sphere. Default is the center of the object.

# Returns
- `sph::Array{Float64}`: A 3D array representing the hollow sphere.

# Example
```jldoctest
# create a centered sphere of 80% of the object size with a thickness of 0.8 pixels
julia> hollow_sphere()
```
"""
function hollow_sphere(::Type{T}, sz= (128, 128, 128), radius=0.8, center=sz.÷2 .+1; thickness=0.8) where {T}
    obj = zeros(T, sz)
    hollow_sphere!(obj, radius, center, thickness=thickness)
    return obj
end

function hollow_sphere(sz= (128, 128, 128), radius=0.8, center=sz.÷2 .+1; thickness=0.8)
    return hollow_sphere(Float32, sz, radius, center, thickness=thickness)
end

"""
    object_3D([DataType], sz, radius=0.8, center=sz.÷2 .+1; thickness=0.8)

Create a 3D object with a hollow sphere (cell membrane), another hollow sphere (nucleus), a hollow small sphere (vesicle), a filled small sphere (), and a line.

# Arguments
- `DataType`: The optional datatype of the output array. Default is Float32.
- `sz`: A vector of integers representing the size of the object. Default is (128, 128, 128).
- `radius`: A float (or tuple) representing the relative radius of the cell sphere.
- `center`: A tuple representing the center of the object.
- `thickness`: A float representing the thickness of the membranes in pixels. Default is 0.8.

"""
function object_3D(::Type{T}, sz= (128, 128, 128), radius=0.8, center=sz.÷2 .+1; thickness=0.8) where {T}
    obj = hollow_sphere(T, sz, radius, center, thickness=thickness)
    nucleus_offset = ntuple((d)-> (d==1) ? - radius*(sz[1] ./ 4) : sz[d]/20 ,length(sz))
    hollow_sphere!(obj, radius./2, center.+nucleus_offset, thickness=thickness)

    vesicle1_offset = ntuple((d)-> (d==1) ? sz[1] .÷ 3 : 0 ,length(sz))
    hollow_sphere!(obj, radius./10, center.+vesicle1_offset, thickness=thickness)

    vesicle2_offset = ntuple((d)-> (d==2) ? sz[1] .÷ 3 : 0 ,length(sz))
    draw_sphere!(obj, sz.*radius./20, center.+vesicle2_offset, thickness=thickness, filled=true)

    line_dir = ntuple((d)-> (d==1) ? sz[1] .÷ 2.2 : 0 ,length(sz))
    draw_line!(obj, center .- line_dir, center .+ line_dir, thickness=thickness)

    return obj
end

function object_3D(sz= (128, 128, 128), radius=0.8, center=sz.÷2 .+1; thickness=0.8)
    return object_3D(Float32, sz, radius, center, thickness=thickness)
end

