using Pkg
Pkg.activate(".")
Pkg.instantiate()
include("src/updater/get_earthquakes.jl")
include("src/updater/database/create_database.jl")
include("src/updater/database/create_view.jl")
include("src/updater/database/insert_into_db.jl")
#####

earthquakes_dataframe = get_quakes()

earthquakes_frame = get_quakes()
println(earthquakes_frame)
db = create_database()
insert_into_db(db, earthquakes_frame)
#println("I think it worked?")

view_df = get_view(db, "earthquakes_table")
println(view_df)
println("Sucess!")