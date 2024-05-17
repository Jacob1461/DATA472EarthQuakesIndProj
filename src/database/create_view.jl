using MySQL, DBInterface, DataFrames

function get_view(db, datatable::String)
    try
        MySQL.execute(db, """
        CREATE VIEW IF NOT EXISTS temp_view AS
        SELECT *
        FROM $(datatable)
        """)
        df = DataFrame(DBInterface.execute(db, "SELECT * FROM temp_view"))
        MySQL.execute(db, "DROP VIEW IF EXISTS temp_view")

        return df
    catch e
        println("There was an error: ", e)
    end
end
