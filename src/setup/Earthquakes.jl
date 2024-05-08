# Main file for running the EarthQuakes scripts

#TODO 
"""Work on making the code less error prone"""

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

db = create_database()

function get_data()
    mmi_lower_bound = 3
    mmi_upper_bound = 6
    geonet_earthquakes = get_geonet_quakes(mmi_lower_bound, mmi_upper_bound)
    #println(geonet_earthquakes)
    usgs_earthquakes = get_content_usgs()
    #println(usgs_earthquakes)
    emsc_quakes = query_emsc(50, 3.5)
    #println(emsc_quakes)
    combined_frame = vcat(geonet_earthquakes, usgs_earthquakes, emsc_quakes)
    #println(combined_frame)
return combined_frame
end

earthquakes_data = get_data()
println(earthquakes_data)


insert_into_db(db, earthquakes_data)
earthquake_table_view = get_view(db, "earthquake_table")




#There were 296 entries 11:07pm 5th may. Check that entry adding is working
