module EMSCEarthQuakesApiModule
export query_emsc
using HTTP
using Dates
using JSON
using DataFrames
using Printf

struct SismicEarthquakeEvent
    publicID::String
    time::DateTime
    depth::Float64
    magnitude::Float64
    magtype::String
    locality::String
    coordinates::Tuple{Float64, Float64}
end

function parse_custom_date(date_str)
    # First try parsing without microseconds
    main_part_fmt = dateformat"yyyy-mm-dd\THH:MM:SS"
    microsecond_fmt = dateformat".ssssssZ"
    
    try
        # Attempt to split the datetime and microseconds
        datetime_part, microsecond_part = split(date_str, '.', limit=2)
        datetime_part *= "Z"  # Append 'Z' back to the main datetime part
        
        # Parse the datetime part up to seconds
        dt = DateTime(datetime_part, dateformat"yyyy-mm-dd\THH:MM:SSZ")
        return dt
        # if contains(microsecond_part, 'Z')
        #     # Strip the 'Z' and parse microseconds
        #     microsecond_part = replace(microsecond_part, "Z" => "")
        #     microseconds = parse(Int, microsecond_part) * 10^(6 - length(microsecond_part))
        #     return dt + Dates.Millisecond(microseconds ÷ 1000)
        # else
        #     return dt
        # end
    catch e
        println("Failed to parse '$date_str': $e")
    end
    
    error("Date format not recognized: $date_str")
end



function create_event(event::Dict{String, Any})
    properties = event["properties"]
    geometry = event["geometry"]
    coordinates = geometry["coordinates"]

    publicID = properties["unid"]
    
    unformatted_time = properties["time"]
    #println(unformatted_time)
    
    time = parse_custom_date(strip(unformatted_time))
    depth = properties["depth"]
    magnitude = properties["mag"]

    locality = properties["flynn_region"]
    magtype = properties["magtype"]
    coordinates = tuple(Float64(coordinates[1]), Float64(coordinates[2])) 

    return SismicEarthquakeEvent(publicID, time, depth, magnitude, magtype, locality, coordinates)
end

function query_emsc(amount::Int, min_mag::Float64)
    link = @sprintf("https://www.seismicportal.eu/fdsnws/event/1/query?limit=%d&format=json&minmag=%.1f", amount, min_mag)

    response = HTTP.request("GET", link)

    json_data = JSON.parse(String(response.body))
    events = json_data["features"]

    earthquake_events = SismicEarthquakeEvent[]

    for event in events
        new_event = create_event(event)
        if new_event !== nothing
            push!(earthquake_events, new_event)
        else
            println("Skipped an entry because it was nothing")
        end
    end


    df = DataFrame(publicID = [event.publicID for event in earthquake_events],
                country = [nothing for _ in earthquake_events],
                time = [event.time for event in earthquake_events],
                magnitude = [event.magnitude for event in earthquake_events],
                magtype = [event.magtype for event in earthquake_events],
                mmi = [nothing for _ in earthquake_events],
                locality = [event.locality for event in earthquake_events],
                depth = [event.depth for event in earthquake_events],
                coordinates = [event.coordinates for event in earthquake_events])
    return df
end
end