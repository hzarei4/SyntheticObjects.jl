using Cairo
using FourierTools:filter_gaussian

export annotation_3D, init_annonate, annotate_string!, matrix_read

"""
    annotation_3D(sz=(128,128, 1); numbers_or_alphabets="alphabets", font_size=120.0)
    
    repeat(reshape(t, (100, 400, 1)), outer=4)
"""

function annotation_3D(sz=(128,128, 1); filtering=true, numbers_or_alphabets="alphabets", font_size=Float64.(minimum(sz[1:2]))-10.0)
    arr = zeros(sz)

    alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    cr, c = init_annonate(sz)

    if numbers_or_alphabets == "alphabets"
        if size(arr)[3] > 26
            println("Number of slices is greater than 26. Please choose numbers instead of alphabets.")
            return
        end

        for i1 in 1:size(arr)[3]
            
            annotate_string!(cr, c, arr, string(alphabet[i1]), font_size, i1) # arr[:, :, i1] =
        end
        
    elseif numbers_or_alphabets == "numbers"
        for i1 in 1:size(arr)[3]
            annotate_string!(cr, c, arr, string(i1), font_size, i1)
        end
    end

    if filtering
        for i1 in 1:size(arr)[3]
            arr[:, :, i1] = filter_gaussian(arr[:, :, i1], sigma=5.0)
        end
        filter_gaussian(arr, sigma=0.5)
    else
        return arr
    end

end

function ()
    
end


#write_to_png(c,"sample_text_align_center.png")

function init_annonate(sz)
    c = CairoRGBSurface(sz[1:2]...);
    cr = CairoContext(c);

    save(cr);

    return cr, c
end

function annotate_string!(cr, c, arr, string_to_write::AbstractString, font_size::Float64, i1)

    save(cr);
    select_font_face(cr, "Sans", Cairo.FONT_SLANT_NORMAL,
    Cairo.FONT_WEIGHT_NORMAL);
    set_source_rgb(cr, 1.0, 1.0, 1.0);
    set_font_size(cr, font_size);
    extents = text_extents(cr, string_to_write);


    xy = ((c.height, c.width) .÷ 2 ) .- (extents[3]/2 + extents[1], (extents[4]/2 + extents[2]));
    #y = (50.0-(extents[4]/2 + extents[2]);

    move_to(cr, xy...);
    show_text(cr, string_to_write);

    arr[:, :, i1] = matrix_read(c)

    set_source_rgb(cr, 0.0, 0.0, 0.0);    # light gray
    rectangle(cr, 0.0, 0.0, c.height, c.width); # background
    fill(cr);
    restore(cr);

    return cr, c, arr
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
	surf = CairoImageSurface(z, Cairo.FORMAT_ARGB32)

    cr = CairoContext(surf)
    set_source_surface(cr,surface,0,0)
    paint(cr)

    r = surf.data
    return (r .- minimum(r))./maximum((r .- minimum(r)))
end

