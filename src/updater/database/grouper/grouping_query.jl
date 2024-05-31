using MySQL, DBInterface
using DataFrames
using Dates

function get_unassigned_earthquakes(conn)
    current_time = Dates.now()
    cutoff_time = current_time - Hour(4)  # Quakes younger than 12hrs will not be grouped
    formatted_cutoff_time = Dates.format(cutoff_time, "yyyy-mm-dd HH:MM:SS")
    query = """
    SELECT e.earthquakeID, e.latitude, e.longitude, e.time, e.magnitude, e.source 
    FROM earthquakes_table e 
    LEFT JOIN grouping_table g ON e.earthquakeID = g.earthquakeID 
    WHERE g.earthquakeID IS NULL AND e.time < '$(formatted_cutoff_time)'
    """
    result = DBInterface.execute(conn, query)
    return DataFrame(result)
end
