include("emsc/get_emsc_data.jl")
include("geonet/get_geonet_quakes.jl")
include("usgs/get_usgc_quakes.jl")
include("assign_earthquake_ID.jl")
include("database/create_database.jl")
include("database/create_view.jl")
include("database/insert_into_db.jl")

function get_quakes()
    geonet_quakes = get_geonet_quakes(3,7)
    usgs_quakes = get_usgs_quakes()
    emsc_quakes = get_emsc_quakes()

    combintation_frame_no_ID = vcat(geonet_quakes, usgs_quakes, emsc_quakes)
    combintation_frame_ID = assign_earthquakeID(combintation_frame_no_ID)
    # Changed the column order of most important to least important information (rearranged before insertion into db)
    combintation_frame_ID = combintation_frame_ID[:, ["earthquakeID","country","time", "magnitude", "locality", "depth", "mmi", "latitude", "longitude", "source", "publicID"]] 
    return combintation_frame_ID

end

earthquakes_frame = get_quakes()
println(earthquakes_frame)
db = create_database()
insert_into_db(db, earthquakes_frame)
#println("I think it worked?")

# view_df = get_view(db, "earthquakes_table")
# println(view_df)


