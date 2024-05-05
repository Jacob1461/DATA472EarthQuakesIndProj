using HTTP
using JSON



function get_country(longitude, latitude)
    url = "https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude"
    response = HTTP.get(url)
    result = JSON.parse(String(response.body))
    country = get(result, "address", Dict())["country"]
    return country
end

function get_coordinates(coordinates::Tuple) #It is long, lat not lat long for some reason
    
    places = []
    for _ in coordinates
        push!(places, get_country(coordinates[1], coordinates[2]))
        sleep(1.1) #Api usage doc said that a maximum of 1 request per person per second.
    end
    return places
end
    
