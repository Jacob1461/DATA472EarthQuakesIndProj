using MySQL, DBInterface


function make_stats_table(conn)
    sql = """
    CREATE TABLE IF NOT EXISTS stats_table (
    DATE DATETIME PRIMARY KEY,
    today INT DEFAULT 0,
    total INT DEFAULT 0,
    max_mag VARCHAR(255) DEFAULT 0,
    min_depth VARCHAR(255) DEFAULT 0);
    """
    DBInterface.execute(conn,sql)
end