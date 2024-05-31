using MySQL, DBInterface


function make_stats_table(conn)
    sql = """
    CREATE TABLE IF NOT EXISTS earthquakes_table (
    time DATETIME PRIMARY KEY,
    total DOUBLE DEFAULT 0,
    max_mag DOUBLE DEFAULT 0,
    max_depth DOUBLE DEFAULT 0
    min_depth DOUBLE DEFAULT 0
    most_effected_country VARCHAR(255)) """
    DBInterface.execute(conn,sql)
    println("Stats connected to DB")
end