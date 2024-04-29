module USGSEarthQuakesApiModule
export get_content_usgs
using Pkg
using Dates
using HTTP
using JSON
using DataFrames

struct EarthquakeEvent
    publicID::String
    time::DateTime
    magnitude::Float64
    mmi::Union{Float64, Int}
    locality::String
    coordinates::Vector{Float64}
    url::String
    country::String
end

get_country(place::String) = strip(split(place, ",")[end])

function create_event(event::Dict{String, Any})
    try
    properties = event["properties"]
    geometry = event["geometry"]
    publicID = event["id"]
    
    time = DateTime(properties["time"])
    magnitude = properties["mag"]
    mmi_value = isnothing(properties["mmi"]) ? -1 : properties["mmi"]
    locality = properties["place"]
    coordinates = geometry["coordinates"]
    url = properties["url"]
    country = get_country(locality)
    return EarthquakeEvent(publicID, time, magnitude, mmi_value, locality, coordinates, url, country)
    catch 
        println(event)
    end
end

function get_content_usgs()
    link = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson"
    response = HTTP.request("GET", link)

    json_data = JSON.parse(String(response.body))
    events = json_data["features"]
    #println(events)
    earthquake_events = EarthquakeEvent[]

    for event in events
        push!(earthquake_events, create_event(event))
    end


    df = DataFrame(publicID = [event.publicID for event in earthquake_events],
                time = [event.time for event in earthquake_events],
                magnitude = [event.magnitude for event in earthquake_events],
                mmi = [event.mmi for event in earthquake_events],
                locality = [event.locality for event in earthquake_events],
                coordinates = [event.coordinates for event in earthquake_events],
                country = [event.country for event in earthquake_events],
                link = [event.url for event in earthquake_events])
    return df
end

end
#global_quakes = get_content_usgs()
#println(global_quakes)