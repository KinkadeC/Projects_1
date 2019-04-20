#initial commands
.headers off
.separator ','

#data stored in flight_databse.db; change file name if downloading new data
.open flight_database.db

#Setup table 'flights' for import from csv
CREATE TABLE flights(
"airline" TEXT,
"flight_number" INTEGER,
"origin_airport" TEXT,
"destination_airport" TEXT,
"departure_delay" INTEGER,
"distance" INTEGER,
"arrival_delay" INTEGER
);

.import flights.csv flights

#Setup table 'airports' for import from csv
CREATE TABLE airports(
"airport_code" TEXT,
"airport" TEXT,
"city" TEXT,
"state" TEXT,
"latitude" REAL,
"longitude" REAL
);

.import airports.csv airports

#Setup table 'airlines' for import from csv                      
CREATE TABLE airlines(   
"airline_code" TEXT,     
"airline"  TEXT          
);                       
                         
.import airlines.csv airlines
                         
#Create indices for all of the tables; should simplify some later queries
                         
CREATE INDEX flights_airline_index ON flights(airline);
CREATE INDEX flights_origin_airport_index ON flights(origin_airport);
CREATE INDEX flights_destination_airport_index ON flights(destination_airport);
CREATE INDEX airport_airport_index ON airports(airport_code);
CREATE INDEX airlines_airline_index ON airlines(airline_code);
                         
#Quick counts; Quick check to see how our sample size is looking
#Can alter airport codes of interest if needed
SELECT count(*)          
FROM flights             
WHERE (destination_airport = "SEA" AND arrival_delay > 20);
                         
SELECT count(*)          
FROM flights             
WHERE (origin_airport = "SFO" AND departure_delay > 20);
                         
select '';               
                         
#Calculate average delay of flights per airline                        
SELECT airlines.airline, avg(arrival_delay)
FROM flights             
INNER JOIN airlines ON flights.airline = airlines.airline_code
GROUP BY airlines.airline
ORDER BY avg(arrival_delay) DESC
LIMIT 5;                 
                         
select '';               
                         
#List every airline at each airport; may be useful for analysis later                         
SELECT DISTINCT airports.airport,airlines.airline
FROM flights             
INNER JOIN airlines ON flights.airline = airlines.airline_code
INNER JOIN airports ON flights.origin_airport = airports.airport_code
ORDER BY airports.airport ASC,airlines.airline ASC
LIMIT 30;                
                         
select '';               
                         
                       
#Calculate % of delayed flights from each airport
#Triple nested; could be a couple of separate queries, but doing it all at once is more efficient
SELECT airports.airport, t3.latepercent
FROM(
	SELECT t1.destination_airport AS dest_airport, (t1.late*100.0/t2.total) AS latepercent
	FROM(
		(SELECT destination_airport, COUNT(*) AS late
		FROM flights
		WHERE arrival_delay>30
		GROUP BY destination_airport) AS t1)
	INNER JOIN (
		SELECT destination_airport, COUNT(*) AS total
		FROM flights
		GROUP BY destination_airport) AS t2
	ON t1.destination_airport = t2.destination_airport
	GROUP BY t2.destination_airport
	) AS t3
INNER JOIN airports ON t3.dest_airport = airports.airport_code
ORDER BY airports.airport ASC
LIMIT 20;
                         
select '';               
                         


#Create View
CREATE VIEW airport_distances AS                        
SELECT DISTINCT t1.airport,t2.airport,(t1.latitude-t2.latitude)*(t1.latitude-t2.latitude)
FROM airports AS t1
INNER JOIN airports AS t2 on t1.airport < t2.airport
ORDER BY t1.airport ASC, t2.airport ASC;                         
  
#Get first 10 for dashboard table
SELECT * FROM airport_distances
LIMIT 10;  
                         
select '';               
                         
#Count total pairs for dashboard tables                         
SELECT COUNT(*)
FROM( SELECT * FROM airport_distances);
                         
                         
select '';               
                         


                         
