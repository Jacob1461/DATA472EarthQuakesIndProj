using Distances


function haversine(lat1, lon1, lat2, lon2)
    earth_rad_km = 6371.0
    return Distances.haversine([lat1, lon1], [lat2, lon2], earth_rad_km )
end