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

println("Sucess!")

println("Closing Connection")
DBInterface.close!(conn)