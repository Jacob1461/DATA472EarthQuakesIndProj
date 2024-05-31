using Pkg
Pkg.activate(".")

using Oxygen
using HTTP
using DataStructures
include("src/database_connection.jl")
include("src/API/query_to_json.jl")
include("src/API/QueryDB.jl")
include("src/API/get_stats_json.jl")


@get "/data" function(req::HTTP.Request, limit=100)
    try 
        if !isa(limit, Int)
            limit = tryparse(int, limit)
        end
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

@get "/data/stats" function(req::HTTP.Request)
    try
        conn = database_connection()
        stats = get_stats_json(conn)
        DBInterface.close!(conn)
        return HTTP.Response(200, JSON.json(stats))
    catch e
        return HTTP.Response(500, JSON.json(Dict("error" => "Internal server error", "details" => string(e))))
    end
end

serve(host="0.0.0.0", port=8080)