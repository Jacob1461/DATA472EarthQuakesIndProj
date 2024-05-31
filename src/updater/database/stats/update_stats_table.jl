using Pkg
Pkg.activate(".")

using MySQL, DBInterface
using DataFrames
using JSON3

include("create_stats_table.jl")
include("get_stats_table.jl")

function update_stats(conn)
    create_database()
    stats = get_stats_table(conn)
    println(stats)
    
end