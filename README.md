# DATA472EarthQuakesIndProf
Individual Data Engineering project for Data472

### End points:
```http://13.55.97.91:8080/data```
This is the most basic of my end points. Will return all earthquakes ordered by Date (newest first) 

```http://13.55.97.91:8080/data?limit=1000``` 
Optional argument to the data is limit which can be from 0 to inf

```http://13.55.97.91:8080/data/stats```
Returns a list of dictionaries. Date, number of earthquakes so far in that day, total quakes in the database at that day, and the earthquakeID with the highest magnitude or lowest depth in that day.


More instructures coming