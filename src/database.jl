module DatabaseFunctionality
export create_database, insert_into_db, get_view
using SQLite, DBInterface
using DataFrames
using Dates

function create_database()
    db = SQLite.DB("Earthquakes.db") # "Earthquakes.db" add to argument to make file based rather than in memory

    SQLite.execute(db, """
    CREATE TABLE IF NOT EXISTS earthquake_table (
        publicID TEXT PRIMARY KEY,
        country TEXT,
        time TEXT)""")

    SQLite.execute(db, """
    CREATE TABLE IF NOT EXISTS earthquake_details (
        details_id INTEGER PRIMARY KEY,
        publicID TEXT UNIQUE,
        locality TEXT,
        magnitude REAL,
        magtype TEXT,
        mmi REAL,
        latitude REAL,
        depth REAL,
        longitude REAL,
        FOREIGN KEY(publicID) REFERENCES earthquake_table(publicID))""")
    SQLite.execute(db, "DROP TABLE IF EXISTS temp_insert_data")
    SQLite.execute(db, """
    CREATE TABLE temp_insert_data (
        publicID TEXT PRIMARY KEY,
        country TEXT,
        time TEXT,
        magnitude REAL,
        magtype TEXT, 
        mmi REAL,
        locality TEXT,
        depth REAL,
        latitude REAL,
        longitude REAL)""")

    #println(SQLite.tables(db))
    return db
end


function insert_into_db(db::SQLite.DB, data_to_insert::DataFrame)
    # Convert time to string format if necessary

    
    data_to_insert.time = string.(data_to_insert.time, "yyyy-mm-ddTHH:MM:SS.sssZ")
    #data_to_insert.time = Dates.format(data_to_insert.time, "yyyy-mm-ddTHH:MM:SS.sssZ")
    unique!(data_to_insert, :publicID)

    # Load data into the temporary table
    SQLite.load!(data_to_insert, db, "temp_insert_data")
    #println("#########################")
    #println(get_view(db, "temp_insert_data"))
    #println("#########################")
    # Start a transaction
    SQLite.execute(db, "BEGIN")


    # Delete records in the temporary table that already exist in the main table
    deleted_count = SQLite.execute(db, """
    DELETE FROM temp_insert_data
    WHERE PublicID IN (SELECT PublicID FROM earthquake_table)
    """)
    #println("Deleted $(deleted_count) existing records from temporary table.")

    # Insert new records into the main table from the temporary table
    inserted_count_eqs = SQLite.execute(db, """
    INSERT OR IGNORE INTO earthquake_table (publicID, country, time)
    SELECT publicID, country, time FROM temp_insert_data
    """)
    #println("Inserted $(inserted_count_eqs) new records into the main table.")
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