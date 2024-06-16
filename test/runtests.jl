using SyntheticObjects
using Test

@testset "Pollen" begin
    sz = (128, 128, 128)
    arr_pollen = pollen(sz)
    @test size(arr_pollen) == sz
    @test typeof(arr_pollen) == Array{Float32, 3}
    @test maximum(arr_pollen) ≈ 1.0
    @test minimum(arr_pollen) == 0.0
    
end

@testset "Filaments" begin
    sz = (128, 128, 128)
    arr_filaments = filaments(sz)
    @test size(arr_filaments) == sz
    @test typeof(arr_filaments) == Array{Float32, 3}
end

@testset "ResolutionTest" begin
    sz = (128, 128, 5)
    arr_res_test = resolution_test(sz)
    @test size(arr_res_test) == sz
    @test typeof(arr_res_test) == Array{Float32, 3}
    @test maximum(arr_res_test) ≈ 1.0
end