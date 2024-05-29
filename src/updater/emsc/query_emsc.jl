using Pkg

using HTTP
using JSON
using Printf

function query_emsc(amount::Int, min_mag::Float64)
    link = @sprintf("https://www.seismicportal.eu/fdsnws/event/1/query?limit=%d&format=json&minmag=%.1f", amount, min_mag)
    response = HTTP.request("GET", link)

    json_data = JSON.parse(String(response.body))
    events = json_data["features"]

   return events
 end
 earthquake_events = EarthquakeEvent[]


