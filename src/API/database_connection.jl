using MySQL
using JSON, DBInterface

function database_connection()
println("attempting to connect")
db_host = "data472-jcl173-earthquakesdb.cyi9p9kw8doa.ap-southeast-2.rds.amazonaws.com"
db_user = ENV["DB_USERNAME"]
db_pass = ENV["DB_PASSWORD"]
db_name = "data472_jcl173_earthquakesdb"

conn = DBInterface.connect(MySQL.Connection,db_host,db_user,db_pass,db = db_name)
println("connected")
return conn

end


