# SyntheticObjects

| **Documentation**                       | **Build Status**                          | **Code Coverage**               |
|:---------------------------------------:|:-----------------------------------------:|:-------------------------------:|
| [![][docs-stable-img]][docs-stable-url] [![][docs-dev-img]][docs-dev-url] | [![][CI-img]][CI-url] | [![][codecov-img]][codecov-url] |



This package creates several synthetic objects in Julia to further process in the image processing routines.

## Installation
`SyntheticObjects.jl` can be installed using the command:

```julia
julia> ] add SyntheticObjects
```


## Examples

```julia
julia> using SyntheticObjects

# this generates a pollen grain object array
arr_pollen = pollen3D((256, 256, 256));

# Or you can create a set of filaments in 3D:
arr_filaments = filaments3D((100,100,100); rel_theta=0, rand_offset=(0.2, 0.2, 0))
```



[docs-dev-img]: https://img.shields.io/badge/docs-dev-orange.svg 
[docs-dev-url]: https://hzarei4.github.io/SyntheticObjects.jl/dev/ 

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg 
[docs-stable-url]: https://hzarei4.github.io/SyntheticObjects.jl/stable/

[codecov-img]: https://codecov.io/gh/hzarei4/SyntheticObjects.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/hzarei4/SyntheticObjects.jl

[CI-img]: https://github.com/hzarei4/SyntheticObjects.jl/workflows/CI/badge.svg
[CI-url]: https://github.com/hzarei4/SyntheticObjects.jl/actions?query=workflow%3ACI 