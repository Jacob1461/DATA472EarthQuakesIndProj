using MySQL, DBInterface

include("create_stats_table.jl")
include("update_stats_table.jl")
include("../../../database_connection.jl")

function stats_table()
    try 
        conn = database_connection()
        make_stats_table(conn)
        update_stats(conn)
    catch e
        println("THERE WAS AN ERROR IN STATS TABLE")
        println(e)
    end
end

