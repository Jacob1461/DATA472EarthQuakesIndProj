# Main file for running the EarthQuakes scripts
using Pkg

include("geonetapi.jl")
using .GeonetEarthQuakesApiModule

include("usgsearthquakes.jl")
using .USGSEarthQuakesApiModule

include("wrangle.jl")
using .WrangleFrames

mmi_lower_bound = 3
mmi_upper_bound = 6
geonet_earthquakes = get_geonet_quakes(mmi_lower_bound, mmi_upper_bound)
#println(geonet_earthquakes)

usgs_earthquakes = get_content_usgs()
#println(usgs_earthquakes)

combined = wrangle_frames(geonet_earthquakes, usgs_earthquakes)
println(combined)



