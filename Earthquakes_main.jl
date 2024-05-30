using Pkg
Pkg.activate(".")
include("src/updater/get_earthquakes.jl")
include("src/updater/database/create_database.jl")
include("src/updater/database/create_view.jl")
include("src/updater/database/insert_into_db.jl")
using DBInterface
#####
println("Begining...")
earthquakes_frame = get_quakes()
#println(earthquakes_frame)
conn = create_database()
println("Database connected")
insert_into_db(conn, earthquakes_frame)
view_df = get_view(conn, "earthquakes_table")
#println(view_df)
n = nrow(view_df) - nrow(earthquakes_frame)
println("Sucess!")
println("Added $n entries to the database")

println("Closing Connection")
DBInterface.close!(conn)