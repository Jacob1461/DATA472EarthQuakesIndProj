using MySQL, DBInterface
using JSON

function create_database(conn)
    
    DBInterface.execute(conn, """
    CREATE TABLE IF NOT EXISTS earthquakes_table (
        earthquakeID VARCHAR(255) PRIMARY KEY,
        country VARCHAR(255),
        time DATETIME,
        magnitude DOUBLE,
        locality VARCHAR(255), 
        depth DOUBLE,
        mmi DOUBLE,
        latitude DOUBLE,
        longitude DOUBLE,
        source VARCHAR(255),
        publicID VARCHAR(255))""")

    DBInterface.execute(conn, "DROP TABLE IF EXISTS temp_insert_data")

    DBInterface.execute(conn, """
        CREATE TABLE IF NOT EXISTS grouping_table (
        earthquakeID VARCHAR(255),
        source VARCHAR(255),
        groupID INT,
        PRIMARY KEY (earthquakeID, groupID),
        FOREIGN KEY (earthquakeID) REFERENCES earthquakes_table(earthquakeID))""")

    #println(MySQL.tables(conn))
    return conn
end