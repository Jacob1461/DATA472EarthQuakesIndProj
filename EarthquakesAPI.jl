using Pkg
Pkg.activate(".")
Pkg.instantiate()

using Oxygen
using HTTP
using DataStructures
include("src/API/database_connection.jl")
include("src/API/query_to_json.jl")
include("src/API/QueryDB.jl")

@get "/data" function(req::HTTP.Request, limit=100)
    try 
        @assert isa(limit, Int)
        @assert limit > 0
        conn = database_connection()
        dataf = query_database(conn, limit)
        res = create_geojson(dataf)
        DBInterface.close!(conn)
        return res
    catch e
        return HTTP.Response(500, JSON.json(Dict("error" => "Internal server error", "details" => string(e))))
    end
end


serve(host="0.0.0.0", port=8080)