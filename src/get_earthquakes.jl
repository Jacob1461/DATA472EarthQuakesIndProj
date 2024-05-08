include("emsc/get_emsc_data.jl")
include("geonet/get_geonet_quakes.jl")
include("usgs/get_usgc_quakes.jl")

function get_quakes()
    geonet_quakes = get_geonet_quakes(3,4)
    usgs_quakes = get_usgs_quakes()
    emsc_quakes = get_emsc_quakes()

    return vcat(geonet_quakes, usgs_quakes, emsc_quakes)
end


