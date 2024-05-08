include("../Earthquake_event.jl")

function filter_and_push(events)
    earthquake_events = EarthquakeEvent[]
    for event in events
        if event["properties"]["quality"]== "best"
            push!(earthquake_events, create_event_geo(event))
        end
    end
    return earthquake_events
end