using Pkg
Pkg.add("HTTP")
Pkg.add("JSON")
Pkg.add("DataFrames")

using HTTP
using JSON
using DataFrames
############################

link = "https://api.geonet.org.nz/quake?MMI="


function get_geonet()
df = DataFrame()
mmi_start = 3
mmi_end = 8
# Process the response data from each request
for i in mmi_start:mmi_end 
    api_link = link*string(i)
    response = HTTP.request("GET", api_link)
    if response.status == 200
        json_data = JSON.parse(String(response.body))
        
        # Extract the seismic events from the JSON response
        events = json_data["features"]
        
        # Extract properties for each event and append to DataFrame
        for event in events
            properties = event["properties"]
            geometry = event["geometry"]
            coordinates = geometry["coordinates"]
            push!(df, (publicID = properties["publicID"],
                       time = properties["time"],
                       depth = properties["depth"],
                       magnitude = properties["magnitude"],
                       mmi = properties["mmi"],
                       locality = properties["locality"],
                       quality = properties["quality"],
                       coordinates = coordinates))
        end
    else
        println("Error in request $i: ", response.status)
    end
end
new_column = ["New Zealand" for _ in 1:nrow(df)]

insertcols!(df, 2, :country => new_column)
return df
end




