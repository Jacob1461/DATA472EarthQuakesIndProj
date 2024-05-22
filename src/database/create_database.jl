using MySQL, DBInterface
using JSON
include("database_creds.jl")

config_file = "/home/ubuntu/config.json"

config = read_config(config_file)

db_username = config["db_username"]
db_password = config["db_password"]

function create_database()
    host = "data472-jcl173-earthquakesdb.cyi9p9kw8doa.ap-southeast-2.rds.amazonaws.com"
    user = db_username
    password = db_password   
    database_name = "data472-jcl173-earthquakesdb"

    conn = MySQL.Connection(
        host = host,
        user = user,
        password = password,
        db = database_name
    )

    MySQL.execute(conn, """
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

    MySQL.execute(conn, "DROP TABLE IF EXISTS temp_insert_data")
    MySQL.execute(conn, """
    CREATE TABLE temp_insert_data (
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

    MySQL.execute(conn, """
        CREATE TABLE IF NOT EXISTS grouping_table (
        earthquakeID VARCHAR(255),
        source VARCHAR(255),
        groupID INT,
        PRIMARY KEY (earthquakeID, groupID),
        FOREIGN KEY (earthquakeID) REFERENCES earthquakes_table(earthquakeID))""")

    #println(MySQL.tables(conn))
    return conn
end
