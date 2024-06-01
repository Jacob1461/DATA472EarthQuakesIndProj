# DATA472EarthQuakesIndProf
Individual Data Engineering project for Data472

## End points:
```http://13.55.97.91:8080/data```
This is the most basic of my end points. Will return all earthquakes ordered by Date (newest first) 

```http://13.55.97.91:8080/data?limit=1000``` 
Optional argument to the data is limit which can be from 0 to inf

```http://13.55.97.91:8080/data/stats```
Returns a list of dictionaries. Date, number of earthquakes so far in that day, total quakes in the database at that day, and the earthquakeID with the highest magnitude or lowest depth in that day.


## Project description 
My project is about continually sourcing earthquake events form several sources around the world. The project has two parts:
 - The Updater: is a series of scripts that deal with sourcing new earthquakes and updating the entries in the database, these scripts also calculate groupings of earthquakes. Earthquakes that share a GroupID are said to be similar in time and location, they may be necessarily be the same earthquake but they are similar, possibly aftershocks. the Updater script also keeps a stats table which contains the current interesting quakes for that day, that is the highest magnitude reported today, and the shallowest earthquake, as well as counts for that day and overall.
- The API: This series of scripts runs an Oxygen API server on the hosting machine, this is responsible for querying the database of stored earthquakes and formatting them to GEOJson response format.


### To set up an instance of this project
For my project I have used two Ec2 instances on Aws, one for each part (Updater and API). To start:
- Generate docker images by running this code:
``` docker build -t earthquakesupdater -f Dockerfile.updater . --progress=plain```
``` docker save -o earthquakesupdater.tar earthquakesupdater``
``` docker build -t earthquakesapi -f Dockerfile.api . --progress=plain ```
``` docker save -o earthquakesapi.tar earthquakesapi ```
Copy the two .tar image files to the EC2 (You could also use docker hub and pull them from the machines)

- You need to create a .env file to store the database credentials
``` nano .env ```
and add three fields
``` DB_USERNAME=username ```
``` DB_PASSWORD=password ```
``` DB_HOST=endPointOfRds.com ```

- Download docker to the Ec2 machine 

``` sudo apt-get update ```
``` sudo apt-get install docker.io -y ```
``` sudo systemctl start docker ```
``` sudo systemctl enable docker ```

- Run the docker file by running this command:
``` sudo docker run -d --env-file .env -p 8080:8080 earthquakesupdater ```

- Optionally you can upload the earthquakes_updater_runner bash file which will delete the container and restart it every 24 hours.

- Repeat these steps for the other image as well. The API VM has two bash files located in the EC2 folder on github. Make them both executable and run them. The Check api will check that the api is running, and if not (and the container hasn't just started up) then it will stop all docker containers then restart the API docker images (don't run this bash file if both images are on one machine).


#### LLM usage
- Chat Gpt has been used in several scripts (particularly in the earlier stage of the project) for assistance in debugging and learning how to use new tools and help write scripts (like bash files).