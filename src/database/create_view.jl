function get_view(db, datatable::String)
    try
        # Create the view
        SQLite.execute(db, """
        CREATE VIEW IF NOT EXISTS temp_view AS
        SELECT *
        FROM $(datatable)
        """)
        
        df = DataFrame(DBInterface.execute(db, "SELECT * FROM temp_view")) |> DataFrame
        SQLite.execute(db, "DROP VIEW IF EXISTS temp_view")
        
        return df
    catch e
        println("There was an error: ", e)
    end
end