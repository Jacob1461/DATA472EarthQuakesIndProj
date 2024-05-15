using Oxygen
using HTTP
using SQLite

include("../database/create_view.jl")


function api(db)
@get "/" function(req::HTTP.Request)
    return "Hello world"
end

# start the web server
serve(port=8000)
end