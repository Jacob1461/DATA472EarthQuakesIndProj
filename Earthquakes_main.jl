using Pkg
Pkg.activate(".")
include("src/updater/get_earthquakes.jl")
include("src/updater/database/create_database.jl")
include("src/updater/database/create_view.jl")
include("src/updater/database/insert_into_db.jl")
include("src/database_connection.jl")
include("src/updater/database/grouper/create_groups.jl")
include("src/updater/database/stats/stats_table.jl")
using DBInterface

function main_loop()
    while true
        println("Beginning...")
        earthquakes_frame = get_quakes()

        conn = database_connection()
        create_database(conn)
        println("Database connected")

        insert_into_db(conn, earthquakes_frame)
        println("Success!")

        println("Running Grouper")
        create_groups()
        println("DONE!")

        println("UPDATING STATS TABLE.....")
        stats_table()
        println("DONE STATS!")

        println("Closing Connection")
        DBInterface.close!(conn)
        println("Sleeping for 3 minutes...")
        sleep(180)
    end
end
main_loop()
