using MySQL, DBInterface, DataFrames

function get_view(db, datatable::String, orderby::Union{String, Nothing}=nothing)
    try
        DBInterface.execute(db, "DROP VIEW IF EXISTS temp_view")
        if orderby === nothing
            DBInterface.execute(db, """
            CREATE VIEW temp_view AS
            SELECT *
            FROM $datatable
            """)
        elseif isa(orderby, String)
            DBInterface.execute(db, """
            CREATE VIEW temp_view AS
            SELECT *
            FROM $datatable
            ORDER BY $orderby
            """)
            # I can somewhat justify doing this as I know the input that will be inserted into the SQL 
            # Will be clean because it will be done by the code and not through the user (or hacker) of the API
        end

        df = DataFrame(DBInterface.execute(db, "SELECT * FROM temp_view"))
        DBInterface.execute(db, "DROP VIEW IF EXISTS temp_view")

        return df
    catch e
        println("There was an error in the create_view: ", e)
    end
end
