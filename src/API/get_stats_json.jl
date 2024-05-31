include("../create_view.jl")
include("format_stats.jl")

function get_stats_json(conn)
    stats_table = get_view(conn, "stats_table", "DATE DESC")
    json_stats = format_stats_table(stats_table)
    return json_stats
end