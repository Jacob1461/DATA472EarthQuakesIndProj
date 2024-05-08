using SQLite, DBInterface

function create_database()
    db = SQLite.DB("Earthquakes.db") # "Earthquakes.db" add to argument to make file based rather than in memory

    SQLite.execute(db, """
    CREATE TABLE IF NOT EXISTS earthquakes_table (
        earthquakeID TEXT PRIMARY KEY,
        country TEXT,
        time TEXT,
        magnitude REAL,
        locality TEXT, 
        depth REAL,
        mmi REAL,
        latitude REAL,
        longitude REAL,
        source TEXT,
        publicID TEXT)""")

    SQLite.execute(db, "DROP TABLE IF EXISTS temp_insert_data")
    SQLite.execute(db, """
    CREATE TABLE temp_insert_data (
        earthquakeID TEXT PRIMARY KEY,
        country TEXT,
        time TEXT,
        magnitude REAL,
        locality TEXT, 
        depth REAL,
        mmi REAL,
        latitude REAL,
        longitude REAL,
        source TEXT,
        publicID TEXT)""")

    SQLite.execute(db, """
        CREATE TABLE IF NOT EXISTS grouping_table (
        earthquakeID TEXT,
        source TEXT,
        groupID INTEGER,
        PRIMARY KEY (earthquakeID, groupID),
        FOREIGN KEY (earthquakeID) REFERENCES earthquakes_table(earthquakeID))""")

    #println(SQLite.tables(db))
    return db
end