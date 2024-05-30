using DataFrames

function assign_earthquakeID(combined_frame::DataFrame)
    earthquakeIDs = [string(row.source, "_", row.publicID) for row in eachrow(combined_frame)]
    insertcols!(combined_frame,1, :earthquakeID => earthquakeIDs)
    return combined_frame
end