using SyntheticObjects
using Test

@testset "Pollen" begin
    sz = (128, 128, 128)
    pollen = pollen3D(sz)
    @test size(pollen) == sz
    @test typeof(pollen) == Array{Float32, 3}
    @test maximum(pollen) ≈ 1.0
    @test minimum(pollen) == 0.0
    
end

@testset "Filaments" begin
    sz = (128, 128, 128)
    filaments = filaments3D(sz)
    @test size(filaments) == sz
    @test typeof(filaments) == Array{Float32, 3}
end

@testset "Annotations" begin
    sz = (128, 128, 5)
    annotation = annotation_3D(sz)
    @test size(annotation) == sz
    @test typeof(annotation) == Array{Float32, 3}
    @test maximum(annotation) ≈ 1.0
end