using MySQL, DBInterface
using DataFrames
using JSON3
using DataStructures

function format_stats_table(stats_df::DataFrame)
    return OrderedDict(
        "DATE" => stats_df[1, :DATE],
        "today" => stats_df[1, :today],
        "total" => stats_df[1, :total],
        "max_mag" => stats_df[1, :max_mag],
        "min_depth" => stats_df[1, :min_depth]
    )
end