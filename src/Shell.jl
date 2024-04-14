using IndexFunArrays:xx, yy, zz
using FourierTools:rotate

export Shell

# Generates a shell of variable size, width, and rotation
# a=myShell(n,p,w,rot)
# n: size of one side (integer is required). Default 200
# p: portion of the shell. Default 1
# w: width of the shell. Default 1
# rot: rotation angles [phi theta psi]. Default 0 0 0

"""
    Shell(n = 200, p =0.5, w = 1.0, rot_angle = 0.0, rot_plane = (1, 2))

Generates a 3D representation of a shell of variable size, width, and rotation.

# Arguments
- `n::Int`: An integer representing the size of one side of the shell. Default is 200.
- `p::Float64`: A float representing the portion of the shell. Default is 0.5.
- `w::Float64`: A float representing the width of the shell. Default is 1.0.
- `rot_angle::Float64`: A float representing the rotation angle. Default is 0.0.
- `rot_plane::Tuple{Int, Int}`: A tuple of integers representing the rotation plane. Default is (1, 2).

# Returns
- `a::Array{Float64}`: A 3D array representing the shell.

# Example
```julia
Shell(300, 0.6, 1.0, 0.2, (2, 3))
```
"""
function Shell(n = 200, p =0.5, w = 1.0, rot_angle = 0.0, rot_plane = (1, 2))
    asize = (n, n, n)

    r = asize[1] * 0.4  # Radius 
    xx_coords = xx(asize)
    yy_coords = yy(asize)
    zz_coords = zz(asize)

    rr_var = sqrt.(xx_coords .^ 2 + yy_coords .^ 2 + zz_coords .^ 2)
    a = exp.(-(rr_var .- r) .^ 2 ./ (2 * w^2))  # Full shell

    cut = floor(Int, size(a, 3) * p) : size(a, 3) - 1
    a[:, :, cut] .= 0  # Portion of the shell


    a = rotate(a, rot_angle, rot_plane) 

    return a
end
