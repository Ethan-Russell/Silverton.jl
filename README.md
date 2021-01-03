Silverton
=========

To install, run [julia](https://julialang.org/downloads/), and add the package using the package manager:

```julia
using Pkg
Pkg.develop(PackageSpec(url="https://github.com/Ethan-Russell/Silverton.jl.git"))
using Silverton
```

Then to run the game, create a game and advance it.
```julia
game = SilvertonGame()
advance!(game)
```