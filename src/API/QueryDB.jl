using DBInterface
using MySQL

function query_database(conn, limit::Int)
    query = """
    SELECT e.earthquakeID, e.country, e.time, e.magnitude, e.locality, e.depth, e.mmi, e.latitude, e.longitude, e.source, e.publicID, 
           IFNULL(g.groupID, -1) as groupID
    FROM earthquakes_table e
    LEFT JOIN grouping_table g ON e.earthquakeID = g.earthquakeID
    ORDER BY e.time DESC
    LIMIT $limit
    """
    result = DBInterface.execute(conn, query)
    df = DataFrame(result)
    println("Returned $limit results")
    return df
end
