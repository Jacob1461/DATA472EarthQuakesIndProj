using MySQL, DBInterface
using DataFrames
using JSON3
using DataStructures

function format_stats_table(stats_df::DataFrame)
    return [OrderedDict(
        "DATE" => row[:DATE],
        "today" => row[:today],
        "total" => row[:total],
        "max_mag" => row[:max_mag],
        "min_depth" => row[:min_depth]
    ) for row in eachrow(stats_df)]
end