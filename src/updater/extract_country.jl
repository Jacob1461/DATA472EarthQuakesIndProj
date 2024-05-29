function extract_country(place::String)
    parts = split(place, ",")
    return strip(parts[end])
end


