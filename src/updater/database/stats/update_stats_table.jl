using MySQL, DBInterface
using DataFrames
using Dates

function update_stats(conn)
    today_date = Dates.today()
    sql_today = """
    SELECT 
        COUNT(*) as today_count, 
        (SELECT earthquakeID FROM earthquakes_table WHERE DATE(time) = '$today_date' ORDER BY magnitude DESC LIMIT 1) as max_mag_id,
        (SELECT earthquakeID FROM earthquakes_table WHERE DATE(time) = '$today_date' ORDER BY depth ASC LIMIT 1) as min_depth_id
    FROM earthquakes_table
    WHERE DATE(time) = '$today_date';
    """
    result_today = DataFrame(DBInterface.execute(conn, sql_today))
    today_count = result_today.today_count[1]
    max_mag_id = result_today.max_mag_id[1]
    min_depth_id = result_today.min_depth_id[1]

    sql_total = "SELECT COUNT(*) as total_count FROM earthquakes_table;"
    result_total = DataFrame(DBInterface.execute(conn, sql_total))
    total_count = result_total.total_count[1]

    sql_update = """
    INSERT INTO stats_table (DATE, today, total, max_mag, min_depth)
    VALUES ('$today_date', $today_count, $total_count, '$max_mag_id', '$min_depth_id')
    ON DUPLICATE KEY UPDATE 
        today = VALUES(today), 
        total = VALUES(total), 
        max_mag = VALUES(max_mag), 
        min_depth = VALUES(min_depth);
    """
    DBInterface.execute(conn, sql_update)
    
    println("UPDATED STATS TABLE")
end
