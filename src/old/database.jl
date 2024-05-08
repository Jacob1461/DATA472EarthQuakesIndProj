module DatabaseFunctionality
export create_database, insert_into_db, get_view
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



function get_view(db, datatable::String)
    try
        # Create the view
        SQLite.execute(db, """
        CREATE VIEW IF NOT EXISTS temp_view AS
        SELECT *
        FROM $(datatable)
        """)

        # Query the view and convert to DataFrame
        df = DataFrame(DBInterface.execute(db, "SELECT * FROM temp_view")) |> DataFrame

        # Drop the view after use
        SQLite.execute(db, "DROP VIEW IF EXISTS temp_view")
        
        return df
    catch e
        println("There was an error: ", e)
    end
end

end