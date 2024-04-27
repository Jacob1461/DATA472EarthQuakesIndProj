using Pkg

include("geonetapi.jl")
include("usgsearthquakes.jl")
include("wrangle.jl")

geo_net_nz = get_geonet()
global_quakes = get_content_usgs()

cleaned_geo = clean_geonet(geo_net_nz)
cleaned_global = clean_usgs(global_quakes)

#println("#################################################################################################################################")
#println(cleaned_geo)
#println(cleaned_global)
println("#################################################################################################################################")

combined_df = combine_frames(cleaned_geo,cleaned_global)
print(combined_df)