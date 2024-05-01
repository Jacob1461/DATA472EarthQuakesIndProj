using Pkg
Pkg.add("HTTP")
Pkg.add("JSON")
Pkg.add("DataFrames")

using HTTP
using JSON
using DataFrames

using Dates
using JSON
using DataFrames

struct SismicEarthquakeEvent
    publicID::String
    time::DateTime
    depth::Float64
    magnitude::Float64
    magtype::String
    locality::String
    coordinates::Tuple{Float64, Float64}
end

function parse_flexible_datetime(datetime_str) #Chat gpt made this function because something something varying level of date percision means DateTime gets weird and breaks
    # Detect and count fractional second digits
    decimal_index = findfirst('.', datetime_str)
    if isnothing(decimal_index)
        # No fractional seconds
        format_str = "yyyy-MM-ddTHH:mm:ssZ"
    else
        # Count the number of digits after the decimal point and before 'Z'
        end_index = findfirst('Z', datetime_str)
        fractional_digits = end_index - decimal_index - 1
        fractional_format = "S"^fractional_digits  # Repeat 'S' as many times as there are fractional digits
        format_str = "yyyy-MM-ddTHH:mm:ss.$fractional_format" * "Z"
    end

    return DateTime(datetime_str, DateFormat(format_str))
end

function create_event(event::Dict{String, Any}) #GPT was used to help fix this function
    properties = event["properties"]
    geometry = event["geometry"]
    coordinates = geometry["coordinates"]

    publicID = properties["unid"]
    
    unformatted_time = properties["time"]
    println(unformatted_time)
    time = parse_flexible_datetime(unformatted_time)
    

    depth = properties["depth"]
    magnitude = properties["mag"]

    locality = properties["flynn_region"]
    magtype = properties["magtype"]
    coordinates = tuple(Float64(coordinates[1]), Float64(coordinates[2])) 

    return SismicEarthquakeEvent(publicID, time, depth, magnitude, magtype, locality, coordinates)
end

function query_seismic(amount::Int)
    link = "https://www.seismicportal.eu/fdsnws/event/1/query?limit=$amount&format=json"
    response = HTTP.request("GET", link)

    json_data = JSON.parse(String(response.body))
    events = json_data["features"]

    earthquake_events = SismicEarthquakeEvent[]

    for event in events
        if earthquake_events !== nothing
            push!(earthquake_events, create_event(event))
        else
            println("Skipped an entry because it was nothing")
        end
    end


    df = DataFrame(publicID = [event.publicID for event in earthquake_events],
                time = [event.time for event in earthquake_events],
                depth = [event.depth for event in earthquake_events],
                magnitude = [event.magnitude for event in earthquake_events],
                magtype = [event.magtype for event in earthquake_events],
                locality = [event.locality for event in earthquake_events],
                coordinates = [event.coordinates for event in earthquake_events])
    return df
end


println(query_seismic(25))