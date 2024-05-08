include("query_usgs.jl")
include("create_eventusgs.jl")
include("build_dataframe.jl")


function get_usgs_quakes()
    response = get_content_usgs()
    earth_quake_events = create_event_usgs(response)
    earthquakes_dataframe = build_dataframe(earth_quake_events)
    return earthquakes_dataframe
end

#println(get_usgs_quakes())

