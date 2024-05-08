include("../Earthquake_event.jl")
include("../extract_country.jl")
using Dates

function create_event_usgs(events)
    earthquake_events = EarthquakeEvent[]
    for event in events
       # try
            properties = event["properties"]
            geometry = event["geometry"]
            publicID = String(event["id"])
            unix_time = properties["time"]  # Unix time in milliseconds
            
            time = unix2datetime(unix_time / 1000)
            magnitude = properties["mag"]
            magtype = properties["magType"] === nothing ? "Unknown" : properties["magType"]
            mmi = properties["mmi"] === nothing ? "-1" : string(properties["mmi"])
            locality = properties["place"] === nothing ? "Unknown" : String(properties["place"])
            coordinates = (geometry["coordinates"][1],geometry["coordinates"][2])  # Assuming this always exists
            country = String(extract_country(locality))  # Ensure this function can handle 'Unknown'
            depth = geometry["coordinates"][3]
            #println(publicID, " ", time, " ",depth, " ", magnitude," ", magtype," ", mmi," ", locality," ", coordinates," ",country)
            new_event = EarthquakeEvent(publicID, time,depth, magnitude, magtype, mmi, locality, coordinates,country)
            push!(earthquake_events, new_event)
        #catch e
           # println("Error creating event: ", e)
           # println("Event data: ", event)
        #end
        
    end
    return earthquake_events
end
