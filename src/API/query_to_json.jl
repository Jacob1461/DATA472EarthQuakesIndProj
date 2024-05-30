using DataFrames
using JSON3
using DataStructures

using DataFrames
using JSON3
using OrderedCollections

function create_geojson(df::DataFrame; api_version::String="2.0", description::String="This API provides earthquake data including coordinates, depth, time, source, public ID, locality, magnitude, country, and MMI.")
    features = OrderedDict{String, Any}[]
    for row in eachrow(df)
        feature = OrderedDict(
            "type" => "Feature",
            "geometry" => OrderedDict(
                "type" => "Point",
                "coordinates" => [row[:longitude], row[:latitude]]
            ),
            "properties" => OrderedDict(
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

    geojson = OrderedDict(
        "apiVersion" => api_version,
        "description" => description,
        "type" => "FeatureCollection",
        "features" => features
    )
    return JSON3.write(geojson)
end
