using HTTP
using JSON

function get_content_usgs()
    link = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson"
    response = HTTP.request("GET", link)
    json_data = JSON.parse(String(response.body))
    events = json_data["features"]
    return events
end
