using SyntheticObjects
using View5D

sz = (128,128,128)

pollen = pollen3D(sz);
filaments = filaments3D(sz);

@ve pollen filaments
volume(pollen)
volume(filaments)


arr = zeros(sz)