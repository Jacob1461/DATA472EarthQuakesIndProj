using MySQL
using DataFrames
using Dates
using Distances
using DBInterface

include("../../../database_connection.jl")
include("find_similar_quakes.jl")
include("grouping_query.jl")
include("haversine.jl")


function create_groups()
    conn = database_connection()
    try
        earthquakes = get_unassigned_earthquakes(conn)
        find_similar_earthquakes(conn, earthquakes, max_distance_km=10.0, max_time_diff_hours=1.0)
    finally
        DBInterface.close!(conn)
    end
end
