var documenterSearchIndex = {"docs":
[{"location":"#SyntheticObjects.jl-Documentation","page":"SyntheticObjects.jl","title":"SyntheticObjects.jl Documentation","text":"","category":"section"},{"location":"","page":"SyntheticObjects.jl","title":"SyntheticObjects.jl","text":"pollen3D\nobject_3D\nfilaments3D \ndraw_sphere!\nannotation_3D!\ndraw_line!\nfilaments3D!\nmatrix_read\nspokes_object \nhollow_sphere! \nresolution_offset \nhollow_sphere  ","category":"page"},{"location":"#SyntheticObjects.pollen3D","page":"SyntheticObjects.jl","title":"SyntheticObjects.pollen3D","text":"pollen3D(sv = (128, 128, 128), dphi::Float64=0.0, dtheta::Float64=0.0)\n\nCreate a 3D representation of a pollen grain.\n\nArguments\n\nsv::Tuple: A tuple of three integers representing the size of the volume in which the pollen grain will be created. Default is (128, 128, 128).\ndphi::Float64: A float representing the phi angle offset in radians. Default is 0.0.\ndtheta::Float64: A float representing the theta angle offset in radians. Default is 0.0.\n\nReturns\n\nret::Array{Float64}: A 3D array representing the pollen grain.\n\nExample\n\npollen3D((256, 256, 256), 0.0, 0.0)\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.object_3D","page":"SyntheticObjects.jl","title":"SyntheticObjects.object_3D","text":"object_3D([DataType], sz, radius=0.8, center=sz.÷2 .+1; thickness=0.8)\n\nCreate a 3D object with a hollow sphere (cell membrane), another hollow sphere (nucleus), a hollow small sphere (vesicle), a filled small sphere (), and a line.\n\nArguments\n\nDataType: The optional datatype of the output array. Default is Float32.\nsz: A vector of integers representing the size of the object. Default is (128, 128, 128).\nradius: A float (or tuple) representing the relative radius of the cell sphere.\ncenter: A tuple representing the center of the object.\nthickness: A float representing the thickness of the membranes in pixels. Default is 0.8.\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.filaments3D","page":"SyntheticObjects.jl","title":"SyntheticObjects.filaments3D","text":"filaments3D([DataType], sz= (128, 128, 128), rand_offset=0.05, rel_theta=1.0, num_filaments=50, apply_seed=true, thickness=0.8)\n\nCreate a 3D representation of filaments.\n\nArguments\n\nDataType: The datatype of the output array. Default is Float32.\nsz: A tuple of integers representing the size of the volume into which the filaments will be created. Default is (128, 128, 128).\nradius: A tuple of real numbers (or a single real number) representing the relative radius of the volume in which the filaments will be created.    Default is 0.8. If a tuple is used, the filamets will be created in a corresponding elliptical volume.   Note that the radius is only enforced in the version filaments3D which creates the array rather than adding.\nrand_offset: A tuple of real numbers representing the random offsets of the filaments in relation to the size. Default is 0.05.\nrel_theta: A real number representing the relative theta range of the filaments. Default is 1.0.\nnum_filaments: An integer representing the number of filaments to be created. Default is 50.\napply_seed: A boolean representing whether to apply a seed to the random number generator. Default is true.\nthickness: A real number representing the thickness of the filaments in pixels. Default is 0.8.\n\nThe result is added to the obj input array\n\nExample\n\n\n# create a 100x100x100 volume with 100 filaments where only the central slice has a random arrangement of filaments\njulia> obj = filaments3D((100,100,100); rel_theta=0, rand_offset=(0.2, 0.2, 0));\n\n# create a 100x100x100 volume with 100 filaments arranged in 3D\njulia> obj = filaments3D((100,100,100));\n\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.draw_sphere!","page":"SyntheticObjects.jl","title":"SyntheticObjects.draw_sphere!","text":"draw_sphere!(arr, radius, center; thickness=0.8, intensity=one(eltype(arr)))\n\nDraw a sphere in a 3D array by adding a Gaussian profile to the array.\n\n#Arguments:\n\narr::Array: A 3D array to which the sphere will be added.\nradius: The radius of the sphere as a number or tuple.\ncenter: The center of the sphere as a tuple. DEFAULT: size(arr).÷2 .+1 which is the (bottom-right) pixel from the center of the array\nthickness: The thickness of the sphere. Default is 0.8.\nintensity::Float64: The intensity of the sphere. Default is 1.0.\n\nExample\n\njulia> arr = zeros(Float32, (128, 128, 128));\njulia> draw_sphere!(arr, 10);\n\njulia> draw_sphere!(arr, (20,30,40), (50,30,80));\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.annotation_3D!","page":"SyntheticObjects.jl","title":"SyntheticObjects.annotation_3D!","text":"annotation_3D!(sz=(128,128, 1); numbers_or_alphabets=\"alphabets\", font_size=Float64.(minimum(sz[1:2]))-10.0, bkg=0.9)\n\nCreate a 3D array of alphabets or numbers with varying font sizes and background levels.\n\nArguments\n\nsz::Tuple: A tuple of three integers representing the size of the volume. Default is (128, 128, 1).\nnumbers_or_alphabets::String: A string representing whether to use alphabets or numbers. Default is \"alphabets\".\nfont_size::Float64: A float representing the font size. Default is the minimum of the first two elements of sz minus 10.0.\nbkg::Float64: A float representing the background level. Default is 0.9.\n\nReturns\n\nA 3D array of alphabets or numbers with varying font sizes and background levels.\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.draw_line!","page":"SyntheticObjects.jl","title":"SyntheticObjects.draw_line!","text":"draw_line!(arr, start, stop; thickness=0.5, intensity=one(eltype(arr)))\n\nDraw a line in a 3D array by adding a Gaussian profile to the array.\n\n#Arguments:\n\narr::Array: A 3D array to which the line will be added.\nstart: The starting point of the line as a tuple.\nstop: The stopping point of the line as a tuple.\nthickness: The thickness of the line. Default is 0.5.\nintensity::Float64: The intensity of the line. Default is 1.0.\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.filaments3D!","page":"SyntheticObjects.jl","title":"SyntheticObjects.filaments3D!","text":"filaments3D!(obj; radius = 0.8, rand_offset=0.05, rel_theta=1.0, num_filaments=50, apply_seed=true, thickness=0.8)\n\nCreate a 3D representation of filaments.\n\nArguments\n\nobj: A 3D array representing the volume into which the filaments will be added.\nradius: A tuple of real numbers (or a single real number) representing the relative radius of the volume in which the filaments will be created.    Default is 0.8. If a tuple is used, the filamets will be created in a corresponding elliptical volume.   Note that the radius is only enforced in the version filaments3D which creates the array rather than adding.\nrand_offset: A tuple of real numbers representing the random offsets of the filaments in relation to the size. Default is 0.05.\nrel_theta: A real number representing the relative theta range of the filaments. Default is 1.0.\nnum_filaments: An integer representing the number of filaments to be created. Default is 50.\napply_seed: A boolean representing whether to apply a seed to the random number generator. Default is true.\nthickness: A real number representing the thickness of the filaments in pixels. Default is 0.8.\n\nThe result is added to the obj input array\n\nExample\n\n\n# create a 100x100x100 volume with 10 filaments where only the central slice has a random arrangement of filaments\njulia> obj = rand(100,100,100); # create an array of random numbers\njulia> filaments3D!(obj; num_filaments=10, rel_theta=0, rand_offset=(0.1,0.1,0), intensity=2.0);\n\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.matrix_read","page":"SyntheticObjects.jl","title":"SyntheticObjects.matrix_read","text":"function matrix_read(surface) \tpaint the input surface into a matrix image of the same size to access \tthe pixels.\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.spokes_object","page":"SyntheticObjects.jl","title":"SyntheticObjects.spokes_object","text":"spokes_object(imgSize = (256, 256), numSpikes = 21, continuous = true, makeRound = true)\n\nGenerates a 2D or 3D representation of a spokes object.\n\nArguments\n\nimgSize::Tuple{Int, Int}: A tuple of integers representing the size of the image. Default is (256, 256).\nnumSpikes::Int: An integer representing the number of spikes. Default is 21.\ncontinuous::Bool: A boolean indicating whether the spokes are continuous. Default is true.\nmakeRound::Bool: A boolean indicating whether the object is round. Default is true.\n\nReturns\n\nobj2::Array{Float64}: A 2D or 3D array representing the spokes object.\n\nExample\n\nspokes_object((512, 512), 30, false, false)\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.hollow_sphere!","page":"SyntheticObjects.jl","title":"SyntheticObjects.hollow_sphere!","text":"hollow_sphere(obj, radius=0.8, center=sz.÷2 .+1; thickness=0.8)\n\nCreate a 3D representation of a hollow sphere.\n\nArguments\n\nobj: A 3D array representing the object into which the sphere will be added.\nradius: A float representing the radius of the sphere.\nthickness: A float representing the thickness of the sphere in pixels. Default is 0.8.\ncenter: A tuple representing the center of the sphere. Default is the center of the object.\n\nReturns\n\nsph::Array{Float64}: A 3D array representing the hollow sphere.\n\nExample\n\n# create a centered sphere of 80% of the object size with a thickness of 0.8 pixels\njulia> obj = zeros(Float64, (128, 128, 128));\njulia> hollow_sphere(obj, 0.8)\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.resolution_offset","page":"SyntheticObjects.jl","title":"SyntheticObjects.resolution_offset","text":"resolution_offset(sz = (100, 100, 1); numbers_or_alphabets=\"alphabets\")\n\nCreate a 3D array of alphabets or numbers with varying font sizes and background levels.\n\nArguments\n\nsz::Tuple: A tuple of three integers representing the size of the volume. Default is (100, 100, 1).   Note that the first two elements are multiplied by 10 to defined the array size. The third elements will contain varying alphabets or numbers.\nnumbers_or_alphabets::String: A string representing whether to use alphabets or numbers. Default is \"alphabets\".\n\nReturns\n\nA 3D array of alphabets or numbers with varying font sizes and background levels.\n\nExample\n\njulia> resolution_test(; sz_each_section=(100, 100), num_slices=1, numbers_or_alphabets=\"alphabets\")\n\n\n\n\n\n","category":"function"},{"location":"#SyntheticObjects.hollow_sphere","page":"SyntheticObjects.jl","title":"SyntheticObjects.hollow_sphere","text":"hollow_sphere([DataType], sz= (128, 128, 128), radius=0.8, center=sz.÷2 .+1; thickness=0.8)\n\nCreate a 3D representation of a hollow sphere.\n\nArguments\n\nDataType: The optional datatype of the output array. Default is Float32.\nsz: A vector of integers representing the size of the sphere.\nradius: A float representing the radius of the sphere.\nthickness: A float representing the thickness of the sphere in pixels. Default is 0.8.\ncenter: A tuple representing the center of the sphere. Default is the center of the object.\n\nReturns\n\nsph::Array{Float64}: A 3D array representing the hollow sphere.\n\nExample\n\n# create a centered sphere of 80% of the object size with a thickness of 0.8 pixels\njulia> hollow_sphere()\n\n\n\n\n\n","category":"function"}]
}
