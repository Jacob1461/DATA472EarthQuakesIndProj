
using MySQL, DBInterface
using DataFrames


function get_stats_table(conn)
    sql = """
    CREATE VIEW stats_view AS 
    select * from stats_table)"""

    df = DataFrame(DBInterface.execute(db, "SELECT * FROM stats_view"))
    DBInterface.execute(db, "DROP VIEW IF EXISTS stats_view")
    println("RETURNED STATS TABLE")
    return df
end