using MySQL, DBInterface
using DataFrames
using Dates

function insert_into_db(db::MySQL.Connection, data_to_insert::DataFrame)
    data_to_insert.time = string.(data_to_insert.time, "yyyy-mm-ddTHH:MM:SS.sssZ")
    unique!(data_to_insert, :earthquakeID)
    sql = """
    INSERT INTO earthquakes_table (earthquakeID, country, time, magnitude, locality, depth, mmi, latitude, longitude, source, publicID)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
    country = VALUES(country), time = VALUES(time), magnitude = VALUES(magnitude), locality = VALUES(locality),
    depth = VALUES(depth), mmi = VALUES(mmi), latitude = VALUES(latitude), longitude = VALUES(longitude),
    source = VALUES(source), publicID = VALUES(publicID)
    """
    MySQL.execute(db, "START TRANSACTION")
    
    for row in eachrow(data_to_insert)
        MySQL.execute(db, sql, row.earthquakeID, row.country, row.time, row.magnitude, row.locality, row.depth, row.mmi, row.latitude, row.longitude, row.source, row.publicID)
    end
    MySQL.execute(db, "COMMIT")
end
