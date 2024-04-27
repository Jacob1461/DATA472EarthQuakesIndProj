using DataFrames


quality_best(row) = row.quality == "best"

function clean_geonet(geodataset::DataFrame)
    df = filter(quality_best, geodataset)
    
    empty_col = [nothing for _ in 1:nrow(df)]
    
  
    df_new = df[:, [:publicID, :country, :locality, :mmi, :time, :coordinates]]
    insertcols!(df_new, 4, :magnitude => empty_col)
    insertcols!(df_new, 8, :link => empty_col)
    
    return df_new
end


function clean_usgs(usgsdataset::DataFrame)
    df_new = select(usgsdataset,[:publicID, :country, :locality, :magnitude, :mmi, :time, :coordinates, :link])
    return df_new
end

function combine_frames(df1::DataFrame, df2::DataFrame)
    return vcat(df1, df2)
end

