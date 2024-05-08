using Dates
using JSON

function format_time(time_string)
    try #Geonet case
        time = DateTime(time_string, dateformat"yyyy-mm-ddTHH:MM:SS.sssZ") 
    catch e
    end
    try #USGS case
        unix_time = time_string
        dt = unix2datetime(unix_time / 1000)
    catch e
    end
    try #emsc case
        main_part_fmt = dateformat"yyyy-mm-dd\THH:MM:SS"
        microsecond_fmt = dateformat".ssssssZ"
        datetime_part, microsecond_part = split(time_string, '.', limit=2)
        datetime_part *= "Z"  # Append 'Z' back to the main datetime part
        
        # Parse the datetime part up to seconds
        dt = DateTime(datetime_part, dateformat"yyyy-mm-dd\THH:MM:SSZ")
        return dt
    catch e
    throw(DomainError(time, "Was not able to convert String to a time"))
    end
end
