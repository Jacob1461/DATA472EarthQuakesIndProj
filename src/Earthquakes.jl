# Main file for running the EarthQuakes scripts

#TODO 
"""Work on making the code less error prone"""

using Pkg
Pkg.activate(".")

include("geonetapi.jl")
using .GeonetEarthQuakesApiModule

include("usgsearthquakes.jl")
using .USGSEarthQuakesApiModule

include("wrangle.jl")
using .WrangleFrames

include("emsc_earthquakes.jl")
using .EMSCEarthQuakesApiModule



mmi_lower_bound = 3
mmi_upper_bound = 6
geonet_earthquakes = get_geonet_quakes(mmi_lower_bound, mmi_upper_bound)
#println(geonet_earthquakes)

usgs_earthquakes = get_content_usgs()
#println(usgs_earthquakes)

emsc_quakes = query_emsc(50, 3.5)
#println(emsc_quakes)


combined_frame = vcat(geonet_earthquakes, usgs_earthquakes, emsc_quakes)
println(combined_frame)


