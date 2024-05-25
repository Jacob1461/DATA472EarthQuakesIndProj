using JSON

function read_config(file_path::String)
    file = open(file_path, "r")
    data = JSON.parse(read(file, String))
    close(file)
    return data
end


