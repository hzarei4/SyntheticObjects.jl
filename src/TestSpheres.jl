using IndexFunArrays:gaussian
using FourierTools:conv_psf, conv

export TestSpheres

"""
    TestSpheres(asize = [200, 200, 100], ScaleX = 25, d = 100, Zfoc = asize[3] ÷ 2)

Create a 3D representation of test spheres.

# Arguments
- `asize::Vector{Int}`: A vector of integers representing the size of the volume in which the spheres will be created. Default is [200, 200, 100].
- `ScaleX::Int`: An integer representing the scale factor. Default is 25.
- `d::Int`: An integer representing the diameter of the spheres. Default is 100.
- `Zfoc::Int`: An integer representing the z-coordinate of the focal slice. Default is asize[3] ÷ 2.

# Returns
- `myPos::Array{Float64}`: A 3D array representing the test spheres.

# Example
```julia
TestSpheres([300, 300, 150], 50, 200, 75)
```
"""
function TestSpheres(asize = [200, 200, 100], ScaleX = 25, d = 100, Zfoc = asize[3] ÷ 2)
    # Bead Creation
    strength = 255
    sphere_radius = 90 / ScaleX 
    mySigma = floor(Int, sphere_radius / 2.5)
    sbox = ceil(Int, sphere_radius * (1 + sqrt(2)))

    b = zeros(sbox, sbox, sbox)
    b[sbox ÷ 2, sbox ÷ 2, sbox ÷ 2] = strength # Central pixel
    myblob = gaussian(b, sigma=mySigma) # Gaussian blob
    
    # Position Calculation
    mymiddleX = asize[1] ÷ 2
    mymiddleY = asize[2] ÷ 2
    dist = d / ScaleX

    # Ensure sufficient image dimensions (with warnings)
    if asize[3] < 2 * Zfoc + 2 * dist
        println("Warning: z-size insufficient. Extending")
        asize[3] = floor(2 * Zfoc + 2 * dist)
    end
    if asize[1] < 3 * dist
        println("Warning: x-size insufficient. Extending")
        asize[1] = floor(3 * dist)
    end

    myPos = zeros(Tuple(asize))

    # In-focal Positions
    myPos[mymiddleX - floor(Int, dist / 2), mymiddleY, Zfoc] = 1
    myPos[mymiddleX + floor(Int, dist / 2), mymiddleY, Zfoc] = 1

    # Out-of-Focus 
    myPos[mymiddleX - 2 * floor(Int, dist / 2), mymiddleY, Zfoc + floor(Int, dist)] = 1
    myPos[mymiddleX + 2 * floor(Int, dist / 2), mymiddleY, Zfoc + floor(Int, dist)] = 1

    # Random Positions
    nb = 300
    maxX, maxY, maxZ = asize[1] - 1, asize[2] - 1, asize[3] - 1
    posX = rand(1:maxX, nb)
    posY = rand(1:maxY, nb)
    posZ = rand(1:maxZ, nb)

    for i in 1:nb
        myPos[posX[i], posY[i], posZ[i]] = 1
    end

    obj = zeros(Tuple(asize))
    # Create object
    if (0)
        a=conv_psf(myPos, myblob); # put the blobs at the right positions #TODO Not at the same size
        obj=brightness.*a[a.>0.5];
    else
        obj=myPos; # just white pixels
    end
    return obj
end
