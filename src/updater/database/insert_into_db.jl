using MySQL, DBInterface
using DataFrames
using Dates

function insert_into_db(db::MySQL.Connection, data_to_insert::DataFrame)
    data_to_insert.time_formatted = Dates.format.(data_to_insert.time, "yyyy-mm-ddTHH:MM:SS.sss")
    sql = """
    INSERT INTO earthquakes_table (earthquakeID, country, time, magnitude, locality, depth, mmi, latitude, longitude, source, publicID)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ON DUPLICATE KEY UPDATE
    country = VALUES(country), time = VALUES(time), magnitude = VALUES(magnitude), locality = VALUES(locality),
    depth = VALUES(depth), mmi = VALUES(mmi), latitude = VALUES(latitude), longitude = VALUES(longitude),
    source = VALUES(source), publicID = VALUES(publicID)
    """

    DBInterface.execute(db, "START TRANSACTION")
    
    try
        stmt = DBInterface.prepare(db, sql)
        
        for row in eachrow(data_to_insert)
            DBInterface.execute(stmt, (
                row.earthquakeID, 
                row.country, 
                row.time_formatted, 
                row.magnitude, 
                row.locality, 
                row.depth, 
                row.mmi, 
                row.latitude, 
                row.longitude, 
                row.source, 
                row.publicID
            ))
        end
        
        DBInterface.execute(db, "COMMIT")
    catch e
        DBInterface.execute(db, "ROLLBACK")
        println("There was an error message in insert_into_db")
        throw(e)
    end
end
