using SQLite, DBInterface

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