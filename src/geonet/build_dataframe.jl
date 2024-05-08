using DataFrames


function build_dataframe(earthquake_events)
    df = DataFrame(publicID = [event.publicID for event in earthquake_events],
    country = ["New Zealand" for _ in earthquake_events],
    time = [event.time for event in earthquake_events],
    magnitude = [event.magnitude for event in earthquake_events],
    magtype = ["unknown" for _ in earthquake_events],
    mmi = [event.mmi for event in earthquake_events],
    locality = [event.locality for event in earthquake_events],
    depth = [event.depth for event in earthquake_events],
    latitude = [event.coordinates[1] for event in earthquake_events],
    longitude = [ event.coordinates[2] for event in earthquake_events])
    return df
end