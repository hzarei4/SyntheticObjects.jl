using Documenter, SyntheticObjects

makedocs(sitename="SyntheticObjects.jl",
        #format="html"
        doctest = false,
        modules = [SyntheticObjects]
        , pages = Any[
            "SyntheticObjects.jl" => "index.md",
        ]
        )


deploydocs(repo = "github.com/hzarei4/SyntheticObjects.jl.git")