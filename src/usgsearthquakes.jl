module USGSEarthQuakesApiModule
export get_content_usgs

using Dates
using HTTP
using JSON
using DataFrames

struct EarthquakeEvent
    publicID::String
    time::DateTime
    magnitude::Union{Float64, Int, Nothing}
    magtype::Union{String, Nothing}
    mmi::Union{Float64, Int, Nothing}
    locality::String
    coordinates::Vector{Float64}
    url::Union{String, Nothing}
    country::String
end

get_country(place::String) = strip(split(place, ",")[end])

function create_event(event::Dict{String, Any})
    try
        properties = event["properties"]
        geometry = event["geometry"]
        publicID = event["id"]
        unix_time = properties["time"]  # Unix time in milliseconds
        
        dt = unix2datetime(unix_time / 1000)
        magnitude = properties["mag"]
        magtype = properties["magType"]
        mmi_value = properties["mmi"]
        locality = properties["place"] === nothing ? "Unknown" : properties["place"]
        coordinates = geometry["coordinates"]  # Assuming this always exists
        url = properties["url"]
        country = get_country(locality)  # Ensure this function can handle 'Unknown'
        
        return EarthquakeEvent(publicID, dt, magnitude, magtype, mmi_value, locality, coordinates, url, country)
    catch e
        println("Error creating event: ", e)
        println("Event data: ", event)
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
                country = [event.country for event in earthquake_events],
                time = [event.time for event in earthquake_events],
                magnitude = [event.magnitude for event in earthquake_events],
                magtype = [event.magtype for event in earthquake_events],
                mmi = [event.mmi for event in earthquake_events],
                locality = [event.locality for event in earthquake_events],
                depth = [event.coordinates[3] for event in earthquake_events],
                coordinates = [(event.coordinates[1], event.coordinates[2]) for event in earthquake_events])
    return df
end

end
