# BoltzmannMachinesRPlots

This R package can be used to plot monitoring output of the functions `monitored_fitdbm`, `monitored_fitrbm`, `monitored_stackrbms` and `monitored_traindbm!` from the [BoltzmannMachines](https://github.com/stefan-m-lenz/BoltzmannMachines.jl) Julia package in R.

It can be used when these functions are directly called via the [JuliaConnectoR](https://github.com/stefan-m-lenz/JuliaConnectoR) in R, or when the output of the corresponding equivalents in the package [dsBoltzmannMachines](https://github.com/stefan-m-lenz/dsBoltzmannMachines) is to be be plotted.

The package can be installed via `devtools`:

    devtools::install_github("stefan-m-lenz/BoltzmannMachinesRPlots")
