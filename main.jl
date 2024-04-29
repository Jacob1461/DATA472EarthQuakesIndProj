# Main file for running the EarthQuakes scripts

using Pkg

include("geonetapi.jl")
using .GeonetEarthQuakesApiModule

include("usgsearthquakes.jl")
using .USGSEarthQuakesApiModule

geonet_earthquakes = get_geonet_quakes(3,6)
println(geonet_earthquakes)

usgs_earthquakes = get_content_usgs()
println(usgs_earthquakes)

