using Dates

struct EarthquakeEvent
    publicID::String
    time::DateTime
    depth::Float64
    magnitude::Float64
    magtype::String
    mmi::String
    locality::String
    coordinates::Tuple{Float64, Float64}
    country::String
end