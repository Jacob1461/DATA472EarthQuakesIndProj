using MySQL
using DataFrames
using Dates
using Distances
using DBInterface


function find_similar_earthquakes(conn::MySQL.Connection, earthquakes::DataFrame; max_distance_km::Float64, max_time_diff_hours::Float64)
    group_id = 1
    grouped = Dict{String, Tuple{Int, String}}()
    n = nrow(earthquakes)
    if n == 0
        println("No earthquakes to assign")
        return 
    end

    for i in 1:n
        eq1 = earthquakes[i, :]
        lat1, lon1, time1, mag1, src1 = eq1.latitude, eq1.longitude, eq1.time, eq1.magnitude, eq1.source
        similar = []
        for j in (i+1):n
            eq2 = earthquakes[j, :]
            lat2, lon2, time2, mag2 = eq2.latitude, eq2.longitude, eq2.time, eq2.magnitude
            distance = haversine(lat1, lon1, lat2, lon2)
            time_diff = abs(Dates.value(time1 - time2)) / (3600 * 1e9)  # convert nanoseconds to hours
            if distance <= max_distance_km && time_diff <= max_time_diff_hours && abs(mag1 - mag2) <= 0.1
                push!(similar, (eq2.earthquakeID, eq2.source))
            end
        end
        if !isempty(similar)
            push!(similar, (eq1.earthquakeID, src1))
            for (eq_id, src) in similar
                grouped[eq_id] = (group_id, src)
            end
            group_id += 1
        end
    end

    for (eq_id, (gid, src)) in grouped
        query = "INSERT INTO grouping_table (earthquakeID, source, groupID) VALUES ('$(MySQL.escape_string(eq_id))', '$(MySQL.escape_string(src))', $gid)"
        DBInterface.execute(conn, query)
    end
end
