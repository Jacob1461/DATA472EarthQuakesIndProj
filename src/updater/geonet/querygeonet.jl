
using HTTP
using JSON

function query_geonet(link::String)
    response = HTTP.request("GET", link)

    json_data = JSON.parse(String(response.body))
    events = json_data["features"]

    return events
end