using Cairo
# using FourierTools:filter_gaussian

export resolution_test, annotation_3D!, matrix_read, annotation_3D

"""
    annotation_3D!(sz=(128,128, 1); numbers_or_alphabets="alphabets", font_size=Float64.(minimum(sz[1:2]))-10.0, bkg=0.9)

    Create a 3D array of alphabets or numbers with varying font sizes and background levels.

# Arguments
- `sz::Tuple`: A tuple of three integers representing the size of the volume. Default is (128, 128, 1).
- `numbers_or_alphabets::String`: A string representing whether to use alphabets or numbers. Default is "alphabets".
- `font_size::Float64`: A float representing the font size. Default is the minimum of the first two elements of `sz` minus 10.0.
- `bkg::Float64`: A float representing the background level. Default is 0.9.

# Returns
    A 3D array of alphabets or numbers with varying font sizes and background levels.
    
"""
function annotation_3D!(arr; numbers_or_alphabets="alphabets", font_size=Float64.(minimum(size(arr)[1:2]))-10.0, bkg=0.9)

    sz = size(arr);
    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

    cr, c = init_annonate(sz)

    if numbers_or_alphabets == "alphabets"
        if size(arr)[3] > length(alphabet)
            println("Number of slices is greater than 26. Please choose numbers instead of alphabets.")
            return
        end

        for i1 in 1:sz[3]
            modi = mod(i1-1, length(alphabet)) +1
            annotate_string!(cr, c, arr, string(alphabet[modi]), font_size, i1, bkg) # arr[:, :, i1] =
        end
        
    elseif numbers_or_alphabets == "numbers"
        for i1 in 1:sz[3]
            annotate_string!(cr, c, arr, string(i1), font_size, i1, bkg)
        end
    end

    return arr#(arr./maximum(arr))
end

function annotation_3D(::Type{T}, sz=(128,128, 1); numbers_or_alphabets="alphabets", font_size=Float64.(minimum(sz[1:2]))-10.0, bkg=0.9) where {T}
    arr = zeros(T, sz)
    annotation_3D!(arr; numbers_or_alphabets=numbers_or_alphabets, font_size=font_size, bkg=bkg)
    return (arr./maximum(arr))
end

function annotation_3D(sz=(128,128, 1); numbers_or_alphabets="alphabets", font_size=Float64.(minimum(sz[1:2]))-10.0, bkg=0.9)
     return annotation_3D(Float32, sz; numbers_or_alphabets=numbers_or_alphabets, font_size=font_size, bkg=bkg)
end

"""
    resolution_test(sz = (100, 100, 1); numbers_or_alphabets="alphabets")

    Create a 3D array of alphabets or numbers with varying font sizes and background levels.

# Arguments
- `sz::Tuple`: A tuple of three integers representing the size of the volume. Default is (100, 100, 1).
    Note that the first two elements are multiplied by 10 to defined the array size. The third elements will contain varying alphabets or numbers.
- `numbers_or_alphabets::String`: A string representing whether to use alphabets or numbers. Default is "alphabets".

# Returns
    A 3D array of alphabets or numbers with varying font sizes and background levels.

# Example

```jldoctest
julia> resolution_test(; sz_each_section=(100, 100), num_slices=1, numbers_or_alphabets="alphabets")
```
"""
function resolution_test(::Type{T}, sz = (512, 512, 1); divisions = (8, 8), numbers_or_alphabets="alphabets") where {T}
    arr_final = zeros(T, sz)
    size_per_division = sz[1:2].÷divisions
    letter_space = (size_per_division..., sz[3])
        
    for font in 1:divisions[1]
        for bkg_lvl in 1:divisions[2]
            my_bg = (bkg_lvl-1.0)/divisions[2]
            my_fs = Float64(size_per_division[1]*font/divisions[1])
            arr_final[(font-1)*size_per_division[1]+1:font*size_per_division[1],
                (bkg_lvl-1)*size_per_division[2]+1:bkg_lvl*size_per_division[2], :] .= annotation_3D(letter_space, numbers_or_alphabets=numbers_or_alphabets, font_size=my_fs, bkg=my_bg) 
        end
    end

    return ((arr_final .- minimum(arr_final)) ./ maximum(arr_final .- minimum(arr_final)))
end

# TODO make the size proportional to the divisions

resolution_test(sz::Tuple{Int, Int}; kwargs...) = resolution_test(Tuple((sz..., 1)); kwargs...)[:, :, 1]
resolution_test(sz; kwargs...) = resolution_test(Float32, sz; kwargs...)

function init_annonate(sz)
    c = CairoRGBSurface(sz[1:2]...);
    cr = CairoContext(c);
    save(cr);

    return cr, c
end

function annotate_string!(cr, c, arr, string_to_write::AbstractString, font_size::Float64, i1, bkg)

    # println("annotating $string_to_write at fs $font_size and bg $bkg")
    save(cr);
    set_source_rgb(cr, bkg, bkg, bkg);    # background color
    rectangle(cr, 0.0, 0.0, c.height, c.width); # background boundry
    fill(cr);
    restore(cr);

    save(cr);
    select_font_face(cr, "Sans", Cairo.FONT_SLANT_NORMAL, Cairo.FONT_WEIGHT_NORMAL);
    set_source_rgb(cr, 1.0, 1.0, 1.0);
    set_font_size(cr, font_size);
    extents = text_extents(cr, string_to_write);

    xy = ((c.height, c.width) .÷ 2 ) .- (extents[3]/2 + extents[1], (extents[4]/2 + extents[2]));

    move_to(cr, xy...);
    show_text(cr, string_to_write);

    arr[:, :, i1] = matrix_read(c)#./maximum(matrix_read(c))

    set_source_rgb(cr, 0.0, 0.0, 0.0);    # white
    rectangle(cr, 0.0, 0.0, c.height, c.width); # background
    fill(cr);
    restore(cr);
    save(cr);

    #return cr, c, arr
end

"""
function matrix_read(surface)
	paint the input surface into a matrix image of the same size to access
	the pixels.
"""
function matrix_read(surface)
	w = Int(surface.width)
	h = Int(surface.height)
	z = zeros(UInt32,w,h)
	surf = CairoImageSurface(z, Cairo.FORMAT_RGB24)

    cr = CairoContext(surf)
    set_source_surface(cr,surface,0,0)
    paint(cr)

    r = surf.data
    return r #(r .- minimum(r))./maximum((r .- minimum(r)))
end

