# Earthquakes 

### This is a basic idea of the bits and pieces
[Schema diagram for the project](EarthquakesSchema.png)


### Getting started
In a command line (or anywhere) you can run the *Earthquakes_main* file in the base directory of the project.
``` julia Earthquakes_main.jl ```

### Notes on current state of project
- Currently using Sqlite database, I am changing this to MySQL on RDS aws. This is so I can have more than one connection to the db at once (api, as well as the code adding stuff). This means that storing the database file in the github repo is only temporary.

- Currently running the code will query the three data sources and add any new quakes to the db, then the get_view function is called and what is returned to the console is the entire db of quakes. This is not what will happen in the file version of the code, its just to make sure things work and the number of earthquakes in the db are always increasing. In the final version of the code the api will return the bits that are important.

- I am yet to impliment earthquake grouping.

- I will get around to containerizing my project in docker at some point before the due date.


