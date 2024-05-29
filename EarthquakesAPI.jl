using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Oxygen
using HTTP
using DataStructures
include("src/API/database_connection.jl")
include("src/API/query_to_json.jl")
include("src/API/QueryDB.jl")

@get "/data" function(req::HTTP.Request, limit::Int=100)
    conn = database_connection()
    dataf = query_database(conn, limit)
    res = create_geojson(dataf)
    return res
end


serve(host="0.0.0.0", port=8080)

