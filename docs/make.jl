using Documenter, SyntheticObjects

makedocs(sitename="SyntheticObjects.jl"
        , format="html"
        , doctest = true
        , modules = [SyntheticObjects]
        , pages = Any[
            "SyntheticObjects.jl" => "index.md",
        ]
        , 
        #make = Documenter.make_julia_cmd()
        )


deploydocs(repo = "github.com/hzarei4/SyntheticObjects.jl.git" 
            , target = "gh-pages"
            , sitename = "SyntheticObjects.jl"
            , modules = [SyntheticObjects]
            , pages = Any[
                "SyntheticObjects.jl" => "index.md",
            ]
            , 
            # make = Documenter.make_julia_cmd()
            )