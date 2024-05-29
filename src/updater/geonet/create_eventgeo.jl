using Dates
include("../Earthquake_event.jl")

#Add error handling to this part, incase something is not present in the api query
function create_event_geo(event::Dict{String, Any}) #GPT was used to help fix this function
    properties = event["properties"]
    geometry = event["geometry"]
    coordinates = geometry["coordinates"]

    publicID = properties["publicID"]
    time = DateTime(properties["time"], dateformat"yyyy-mm-ddTHH:MM:SS.sssZ") 

    depth = properties["depth"]
    magnitude = properties["magnitude"]
    magtype = "unknown"
    mmi = properties["mmi"] === nothing ? "-1" : string(properties["mmi"])
    locality = properties["locality"]
    coordinates = tuple(Float64(coordinates[1]), Float64(coordinates[2])) 
    country = "New Zealand"

    return EarthquakeEvent(publicID, time, depth, magnitude, magtype, mmi, locality, coordinates, country)
end