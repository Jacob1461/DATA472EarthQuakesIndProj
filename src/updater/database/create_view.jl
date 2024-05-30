using MySQL, DBInterface, DataFrames

function get_view(db, datatable::String)
    try
        DBInterface.execute(db, "DROP VIEW IF EXISTS temp_view")

        DBInterface.execute(db, """
        CREATE VIEW temp_view AS
        SELECT *
        FROM $datatable
        """)

        df = DataFrame(DBInterface.execute(db, "SELECT * FROM temp_view"))
        DBInterface.execute(db, "DROP VIEW IF EXISTS temp_view")

        return df
    catch e
        println("There was an error in the create_view: ", e)
    end
end
