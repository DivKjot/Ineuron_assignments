CREATE SCHEMA accidents;
USE accidents;

CREATE TABLE accident(
accident_index VARCHAR(20),
accident_severity int);

CREATE TABLE vehicles(
accident_index VARCHAR(20),
vehicle_type VARCHAR(50));

CREATE TABLE vehicle_types(
vehicle_code INT,
vehicle_type VARCHAR(10));

SHOW VARIABLES LIKE "local_infile";
SET GLOBAL local_infile =1;

LOAD DATA LOCAL INFILE "C:\\Users\\lenovo\\Desktop\\gani\\LEARNING\\#ONGOING PROJECTS\\ROAD SAFETY\\project\\Accidents_2015.csv"
INTO TABLE accident
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @dummy, @dummy, @dummy, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, accident_severity=@col2;

LOAD DATA LOCAL INFILE "C:\\Users\\lenovo\\Desktop\\gani\\LEARNING\\#ONGOING PROJECTS\\ROAD SAFETY\\project\\Vehicles_2015.csv"
INTO TABLE vehicles
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(@col1, @dummy, @col2, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy, @dummy)
SET accident_index=@col1, vehicle_type=@col2;

LOAD DATA LOCAL INFILE "C:\\Users\\lenovo\\Desktop\\gani\\LEARNING\\#ONGOING PROJECTS\\ROAD SAFETY\\project\\vehicle_types.csv"
INTO TABLE vehicle_types
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

CREATE TABLE accident_median(
vehicke_types VARCHAR(100),
severity INT);

-- Accident Severity and Total Accidents per Vehicle Type 
SELECT vt.vehicle_type AS 'Vehicle Type', 
a.accident_severity AS 'Severity', 
COUNT(vt.vehicle_type) AS 'Number of Accidents'
FROM accident a
JOIN vehicles v 
ON a.accident_index = v.accident_index
JOIN vehicle_types vt 
ON v.vehicle_type = vt.vehicle_code
GROUP BY 1
ORDER BY 2,3;

-- . Calculate the Average Severity by vehicle type. 

SELECT vt.vehicle_type AS type_of_vehicle, 
AVG(a.accident_severity) AS average_severity , 
COUNT(vt.vehicle_type) AS number_of_accidents
FROM accident AS a
INNER JOIN vehicles AS v
ON a.accident_index = v.accident_index
INNER JOIN vehicle_types vt
ON vt.vehicle_code = v.vehicle_type
GROUP BY type_of_vehicle
ORDER BY average_severity,number_of_accidents ;

-- Calculate the Average Severity and Total Accidents by Motorcycle. 

SELECT vt.vehicle_type AS type_of_vehicle, 
AVG(a.accident_severity) AS average_severity , 
COUNT(vt.vehicle_type) AS number_of_accidents
FROM accident AS a
INNER JOIN vehicles AS v
ON a.accident_index = v.accident_index
INNER JOIN vehicle_types vt
ON vt.vehicle_code = v.vehicle_type
WHERE vt.vehicle_type LIKE '%otorcycle%'
GROUP BY 1
ORDER BY 2,3;

