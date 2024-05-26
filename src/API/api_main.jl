using Oxygen
using HTTP
include("database_connection.jl")
include("query_to_json.jl")
include("QueryDB.jl")

@get "/data" function(req::HTTP.Request, limit::Int=100)
    conn = database_connection()
    dataf = query_database(conn, limit)
    res = create_geojson(dataf)
    return res
end

serve()

