using JSON

include("../extract_country.jl")
include("../Earthquake_event.jl")
include("../format_time.jl")



function create_event_emsc(event::Dict{String, Any})
    properties = event["properties"]
    geometry = event["geometry"]
    coordinates = geometry["coordinates"]

    publicID = properties["unid"]
    
    unformatted_time = properties["time"]
    
    time = format_time(strip(unformatted_time))
    depth = properties["depth"]
    magnitude = properties["mag"]
    mmi = "-1"
    locality = properties["flynn_region"]
    magtype = properties["magtype"]
    country = extract_country(locality)
    coordinates = tuple(Float64(coordinates[1]), Float64(coordinates[2])) 

    return EarthquakeEvent(publicID, time, depth, magnitude, magtype,mmi, locality, coordinates,country)
end