using DataFrames
using JSON3

function create_geojson(df::DataFrame)
    features = []
    for row in eachrow(df)
        feature = Dict(
            "type" => "Feature",
            "geometry" => Dict(
                "type" => "Point",
                "coordinates" => [row[:longitude], row[:latitude]]
            ),
            "properties" => Dict(
                "earthquakeID" => row[:earthquakeID],
                "country" => row[:country],
                "time" => string(row[:time]),
                "magnitude" => row[:magnitude],
                "locality" => row[:locality],
                "depth" => row[:depth],
                "mmi" => row[:mmi],
                "source" => row[:source],
                "publicID" => row[:publicID]
            )
        )
        push!(features, feature)
    end

    geojson = Dict(
        "type" => "FeatureCollection",
        "features" => features
    )
    return JSON3.write(geojson)
end