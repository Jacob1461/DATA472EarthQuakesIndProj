module WrangleFrames
export wrangle_frames
using DataFrames


quality_best(row) = row.quality == "best"
function clean_geonet(geodataset::DataFrame)
    df = filter(quality_best, geodataset)
    df_new = df[:, [:publicID, :country, :locality, :magnitude, :mmi, :time, :coordinates, :link]]
    
    return df_new
end

function clean_usgs(usgsdataset::DataFrame)
    df_new = select(usgsdataset,[:publicID, :country, :locality, :magnitude, :mmi, :time, :coordinates, :link])
    return df_new
end

function combine_frames(df1::DataFrame, df2::DataFrame)
    return vcat(df1, df2)
end

function wrangle_frames(geonet_df::DataFrame, usgs_df::DataFrame)
    cleaned_geo = clean_geonet(geonet_df)
    cleaned_usgs = clean_usgs(usgs_df)
    combination_frame = combine_frames(cleaned_geo, cleaned_usgs)
    return combination_frame
end

end
