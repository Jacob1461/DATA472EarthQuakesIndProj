using Pkg
Pkg.add("Printf")
using Printf


limit = 100  # Example value for limit
minmag = 5.0  # Example value for minimum magnitude

link_template = 
link = @sprintf("https://www.seismicportal.eu/fdsnws/event/1/query?limit=%d&format=json&minmag=%.1f", limit, minmag)

println(link)