using Pkg

Pkg.activate(".")
Pkg.update()
packages = ["HTTP", "JSON", "DataFrames", "Printf", "SQLite", "DBInterface"]

for package in packages
    Pkg.add(package)
end

using Pkg
Pkg.activate(".")
using DataFrames

include("database.jl")
using .DatabaseFunctionality

include("geonetapi.jl")
using .GeonetEarthQuakesApiModule

include("usgsearthquakes.jl")
using .USGSEarthQuakesApiModule

include("emsc_earthquakes.jl")
using .EMSCEarthQuakesApiModule