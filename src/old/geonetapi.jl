module GeonetEarthQuakesApiModule
export get_geonet_quakes
using HTTP
using JSON
using DataFrames
using Dates

##############
#TODO 
# Remove all the println statements 
# Possibly work on the @asserts to make them more helpful
# Add more code comments and function docstrings
############################

struct GeoEarthquakeEvent
    publicID::String
    time::DateTime
    depth::Float64
    magnitude::Float64
    mmi::Int
    locality::String
    quality::String
    coordinates::Tuple{Float64, Float64}
    country::String
end


#Add error handling to this part, incase something is not present in the api query
function create_event(event::Dict{String, Any}) #GPT was used to help fix this function
    properties = event["properties"]
    geometry = event["geometry"]
    coordinates = geometry["coordinates"]

    publicID = properties["publicID"]
    time = DateTime(properties["time"], dateformat"yyyy-mm-ddTHH:MM:SS.sssZ") 

    depth = properties["depth"]
    magnitude = properties["magnitude"]
    mmi = properties["mmi"] === nothing ? -1 : properties["mmi"]
    locality = properties["locality"]
    quality = properties["quality"]
    coordinates = tuple(Float64(coordinates[1]), Float64(coordinates[2])) 
    country = "New Zealand"
    #println([time, depth, magnitude, mmi, locality, quality, coordinates]) 

    return GeoEarthquakeEvent(publicID, time, depth, magnitude, mmi, locality, quality, coordinates, country)
end

function query_geonet(link::String)
    response = HTTP.request("GET", link)

    json_data = JSON.parse(String(response.body))
    events = json_data["features"]

    earthquake_events = GeoEarthquakeEvent[]

    for event in events
        if event["properties"]["quality"]== "best"
            push!(earthquake_events, create_event(event))
        end
    end

    
    df = DataFrame(publicID = [event.publicID for event in earthquake_events],
                country = ["New Zealand" for _ in earthquake_events],
                time = [event.time for event in earthquake_events],
                magnitude = [event.magnitude for event in earthquake_events],
                magtype = ["unknown" for _ in earthquake_events],
                mmi = [event.mmi for event in earthquake_events],
                locality = [event.locality for event in earthquake_events],
                depth = [event.depth for event in earthquake_events],
                latitude = [event.coordinates[1] for event in earthquake_events],
                longitude = [ event.coordinates[2] for event in earthquake_events])
    return df
end

#Rather than adding the constant value 'New Zealand' add it as a value in the GeoEarthquakeEvent struct instead
function get_geonet_quakes(mmi_lower::Int, mmi_upper::Int)
    @assert -1 <= mmi_lower <= 8 "MMI values are between -1 and 8 inc"
    @assert -1 <= mmi_upper <= 8 "MMI values are between -1 and 8 inc"
    @assert mmi_lower <= mmi_upper "MMI Lower must be lower than or equal to MMI Upper"
    geonet_base_url = "https://api.geonet.org.nz/quake?MMI="
    earthquakes = DataFrame()
    for mmi_level in mmi_lower:mmi_upper
        #println("Getting the earthquakes of MMI: " * string(mmi_level))
        specific_api_url = geonet_base_url * string(mmi_level)
        #println(specific_api_url)
        earth_quakes_specific_mmi = query_geonet(specific_api_url)
        append!(earthquakes, earth_quakes_specific_mmi)
    end
    
    return earthquakes
end

end


