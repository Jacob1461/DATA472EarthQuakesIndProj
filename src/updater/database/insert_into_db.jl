using SQLite, DBInterface
using DataFrames
using Dates

function insert_into_db(db::SQLite.DB, data_to_insert::DataFrame)

    data_to_insert.time = string.(data_to_insert.time, "yyyy-mm-ddTHH:MM:SS.sssZ")
    unique!(data_to_insert, :earthquakeID)
    SQLite.load!(data_to_insert, db, "temp_insert_data")

    SQLite.execute(db, "BEGIN")
    
    SQLite.execute(db, """
    DELETE FROM temp_insert_data
    WHERE earthquakeID IN (SELECT earthquakeID FROM earthquakes_table)
    """)
    
    SQLite.execute(db, """
    INSERT OR IGNORE INTO earthquakes_table (earthquakeID, country, time, magnitude, locality, depth, mmi, latitude, longitude, source, publicID)
    SELECT earthquakeID, country, time, magnitude, locality, depth, mmi, latitude, longitude, source, publicID FROM temp_insert_data
    """)
    
    SQLite.execute(db, "DELETE FROM temp_insert_data") #Changed from drop table, is more efficient to just delete all records rather than re making the table very time
    SQLite.execute(db, "COMMIT")
end