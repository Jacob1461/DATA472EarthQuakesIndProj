using MySQL
using DBInterface
using DataFrames

function query_database(conn, limit::Int)
    query = """
    SELECT earthquakeID, country, time, magnitude, locality, depth, mmi, latitude, longitude, source, publicID 
    FROM earthquakes_table
    ORDER BY time DESC
    LIMIT $limit
    """
result = DBInterface.execute(conn, query)
df = DataFrame(result)
println("Returned $limit results")
return df
end

