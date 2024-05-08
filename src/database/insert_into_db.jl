using SQLite, DBInterface
using DataFrames
using Dates

function insert_into_db(db::SQLite.DB, data_to_insert::DataFrame)

    data_to_insert.time = string.(data_to_insert.time, "yyyy-mm-ddTHH:MM:SS.sssZ")
    
    unique!(data_to_insert, :publicID)

    SQLite.load!(data_to_insert, db, "temp_insert_data")

    SQLite.execute(db, "BEGIN")
    
    SQLite.execute(db, """
    DELETE FROM temp_insert_data
    WHERE PublicID IN (SELECT PublicID FROM earthquake_table)
    """)
    
    SQLite.execute(db, """
    INSERT OR IGNORE INTO earthquake_table (publicID, country, time)
    SELECT publicID, country, time FROM temp_insert_data
    """)
    
    SQLite.execute(db, """
    INSERT OR IGNORE INTO earthquake_details (publicID, locality, magnitude, magtype, mmi,depth, latitude, longitude)
    SELECT publicID, locality, magnitude, magtype, mmi,depth, latitude, longitude FROM temp_insert_data
    """)

    # Drop the temporary table
    SQLite.execute(db, "DROP TABLE temp_insert_data")
    # Commit the transaction
    SQLite.execute(db, "COMMIT")
end