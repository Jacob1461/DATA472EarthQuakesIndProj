using MySQL, DBInterface
using DataFrames
using Dates

function insert_into_db(db, data_to_insert::DataFrame)
    data_to_insert.time = string.(data_to_insert.time, "yyyy-mm-ddTHH:MM:SS.sssZ")
    unique!(data_to_insert, :earthquakeID)
    DBInterface.execute(db, "CREATE TEMPORARY TABLE temp_insert_data LIKE earthquakes_table")
    DBInterface.load!(data_to_insert, db, "temp_insert_data")

    DBInterface.execute(db, "START TRANSACTION")
    DBInterface.execute(db, """
    DELETE FROM temp_insert_data
    WHERE earthquakeID IN (SELECT earthquakeID FROM earthquakes_table)
    """)
    DBInterface.execute(db, """
    INSERT INTO earthquakes_table (earthquakeID, country, time, magnitude, locality, depth, mmi, latitude, longitude, source, publicID)
    SELECT earthquakeID, country, time, magnitude, locality, depth, mmi, latitude, longitude, source, publicID FROM temp_insert_data
    ON DUPLICATE KEY UPDATE
    country = VALUES(country), time = VALUES(time), magnitude = VALUES(magnitude), locality = VALUES(locality),
    depth = VALUES(depth), mmi = VALUES(mmi), latitude = VALUES(latitude), longitude = VALUES(longitude),
    source = VALUES(source), publicID = VALUES(publicID)
    """)
    DBInterface.execute(db, "TRUNCATE TABLE temp_insert_data")
    DBInterface.execute(db, "COMMIT")
end
