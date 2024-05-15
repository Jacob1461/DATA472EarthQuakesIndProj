using Pkg
Pkg.activate(dirname(@__FILE__))
Pkg.instantiate()
#####
include("src/get_earthquakes.jl")
include("src/database/create_database.jl")
include("src/database/create_view.jl")
include("src/database/insert_into_db.jl")
include("src/API/APImain.jl")
#####

earthquakes_dataframe = get_quakes()

earthquakes_frame = get_quakes()
println(earthquakes_frame)
db = create_database()
insert_into_db(db, earthquakes_frame)
println("I think it worked?")

view_df = get_view(db, "earthquakes_table")
println(view_df)





