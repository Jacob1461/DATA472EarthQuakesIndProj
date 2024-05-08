using Pkg

include("build_dataframe.jl")
include("create_eventemsc.jl")
include("query_emsc.jl")

function get_emsc_quakes()
vec_of_earthquakes = query_emsc(120, 2.0)
earthquake_events = EarthquakeEvent[]
for event in vec_of_earthquakes
    new_event = create_event_emsc(event)
    push!(earthquake_events, new_event)
end

earthquake_dataframe = build_dataframe(earthquake_events)

#println(earthquake_dataframe)
return earthquake_dataframe
end