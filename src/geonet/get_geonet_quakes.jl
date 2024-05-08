include("create_eventgeo.jl")
include("querygeonet.jl")
include("build_dataframe.jl")
include("filter_and_push.jl")

using DataFrames

function get_geonet_quakes(mmi_lower::Int, mmi_upper::Int)
    @assert -1 <= mmi_lower <= 8 "MMI values are between -1 and 8 inc"
    @assert -1 <= mmi_upper <= 8 "MMI values are between -1 and 8 inc"
    @assert mmi_lower <= mmi_upper "MMI Lower must be lower than or equal to MMI Upper"
    geonet_base_url = "https://api.geonet.org.nz/quake?MMI="
    all_earthquakes = DataFrame()
    for mmi_level in mmi_lower:mmi_upper
        specific_api_url = geonet_base_url * string(mmi_level)
        specific_earthquakes_events = query_geonet(specific_api_url)
        earthquake_events = filter_and_push(specific_earthquakes_events)
        earthquakes_dataframe = build_dataframe(earthquake_events)
        append!(all_earthquakes, earthquakes_dataframe)
    end
    
    return all_earthquakes
end


#println(get_geonet_quakes(3,6))