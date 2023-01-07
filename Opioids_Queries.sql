/*
Project Description: This project explores raw data reports specific to opioid related drug overdoses and deaths amongst human begins 
					 located in the United States of America between the years of January 2019 through December 2021. Utilizing MySQL 
                     Server tools, in this project we take the forementioned data and transform it to make it more usable for analysis.

Skills Used: This project highlights one’s ability to clean data, create views, create stored procedures with input parameters, 
			 Year-Over-Year analysis, and the utilization of window/ fetching (LAG) and aggregate functions. 

Data Source: The data used for this MySQL project was the 
			 VSRR Provisional Drug Overdose Death Counts 
             obtained from the Center for Disease Control and Prevention
             
Data Source Link: https://data.cdc.gov/NCHS/VSRR-Provisional-Drug-Overdose-Death-Counts/xkb8-kh2a  

Data Dictionary: https://www.cdc.gov/nchs/nvss/vsrr/drug-overdose-data.htm
*/


/*
Create Schema and Import table 
This step was done using the MySQL data import wizard
*/
CREATE SCHEMA `Opioids`;

/* 
Clean-up Data and Prepare for Analysis using SQL Queries (Data Preprocessing)
*/

-- Display first 100 rows of overdose table
SELECT *
FROM overdose
LIMIT 100;

-- Return the number of columns and rows of overdose table
SELECT COUNT(*) as Number_of_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'overdose';

SELECT COUNT(*) as Number_of_Rows
FROM overdose;

-- Return the column names and data types of the overdose table
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'overdose';

-- Remove columns irrelevant to analysis
ALTER TABLE overdose
DROP COLUMN Period,
DROP COLUMN `Percent Complete`,
DROP COLUMN `Percent Pending Investigation`,
DROP COLUMN `Footnote`,
DROP COLUMN `Footnote Symbol`;

-- Return the updated number of columns and rows of overdose table
SELECT COUNT(*) as Number_of_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'overdose';

SELECT COUNT(*) as Number_of_Rows
FROM overdose;

-- Review updated overdose table
SELECT * 
FROM overdose;

-- Rename columns
ALTER TABLE overdose
CHANGE COLUMN State Abbr VARCHAR(2);

ALTER TABLE overdose
CHANGE COLUMN `State Name` State VARCHAR(50);

ALTER TABLE overdose
CHANGE COLUMN `Data Value` Reported_Overdoses VARCHAR(50);

ALTER TABLE overdose
CHANGE CoLUMN `Predicted Value` Predicted_Overdoses VARCHAR(50);

-- Return updated overdose table
SELECT * 
FROM overdose;

-- Change 'Reported_Overdoses' & 'Predicted_Overdoses' columns datatype
-- before altering table, update values
-- set a '0' value in the fields where you have empty values (which can't be converted to int)
UPDATE overdose 
SET Reported_Overdoses = '0' 
WHERE trim(Reported_Overdoses) = '';

UPDATE overdose
SET Predicted_Overdoses = '0'
WHERE trim(Predicted_Overdoses) = '';

ALTER TABLE overdose
MODIFY COLUMN Reported_Overdoses INT;

ALTER TABLE overdose
MODIFY COLUMN Predicted_Overdoses INT;

-- Return the updated column names and datatypes 
SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'overdose';

-- Replace Zero int values with NULL
UPDATE overdose 
SET Reported_Overdoses = NULL 
WHERE Reported_Overdoses = 0;

UPDATE overdose 
SET Predicted_Overdoses = NULL 
WHERE Predicted_Overdoses = 0;

-- Check for null/missing values 
SELECT State, COUNT(*) as Num_Null_Missing
FROM overdose
WHERE State IS NULL OR State = ''
GROUP BY State;

SELECT Abbr, COUNT(*) as Num_Null_Missing
FROM overdose
WHERE Abbr IS NULL OR Abbr = ''
GROUP BY Abbr;

SELECT Year, COUNT(*) as Num_Null_Missing
FROM overdose
WHERE Year IS NULL OR Year = ''
GROUP BY Year;

SELECT Month, COUNT(*) as Num_Null_Missing
FROM overdose
WHERE Month IS NULL OR Month = ''
GROUP BY Month;

SELECT Indicator, COUNT(*) as Num_Null_Missing
FROM overdose
WHERE Indicator IS NULL OR Indicator = ''
GROUP BY Indicator;

SELECT Reported_Overdoses, COUNT(*) as Num_Null_Missing
FROM overdose
WHERE Reported_Overdoses IS NULL OR Reported_Overdoses = ''
GROUP BY Reported_Overdoses;

SELECT Predicted_Overdoses, COUNT(*) as Num_Null_Missing
FROM overdose
WHERE Predicted_Overdoses IS NULL OR Predicted_Overdoses = ''
GROUP BY Predicted_Overdoses;

-- Display the number of unique values in each column followed by a list of each unique  value
-- Categorical Data Only
SELECT COUNT(DISTINCT State) as DistinctStateNames
FROM overdose;

SELECT DISTINCT State
FROM overdose;

SELECT COUNT(DISTINCT Abbr) as DistinctStateAbbrvs
FROM overdose;

SELECT DISTINCT Abbr
FROM overdose;

SELECT COUNT(DISTINCT Year) as DistinctYears
FROM overdose;

SELECT DISTINCT Year
FROM overdose;

SELECT COUNT(DISTINCT Month) as DistinctMonths
FROM overdose;

SELECT DISTINCT Month
FROM overdose;

SELECT COUNT(DISTINCT Indicator) as DistinctIndicators
FROM overdose;

SELECT DISTINCT Indicator
FROM overdose;

/*
Analyze data by running various queries to gain insight
*/
-- Create view displaying drug overdoses proceeded by death 
-- Limit view to display the years between 2019-2021 only   
CREATE VIEW v_years2019thru2021
AS 
SELECT *
FROM overdose
WHERE (Year = 2019 OR Year = 2020 OR Year = 2021)
AND Indicator = 'Number of Drug Overdose Deaths'
Order By Year, State;

-- Call View v_years2019thru2021
SELECT * 
FROM v_years2019thru2021;

-- Create view displaying drug overdose deaths between years 2019-2021 w/ALL Indicators
CREATE VIEW v_Indicators2019_2021
AS 
SELECT *
FROM overdose
WHERE (Year = 2019 OR Year = 2020 OR Year = 2021)
Order By Year, State;

-- Call View v_Indicators2019_2021
SELECT * 
FROM v_Indicators2019_2021;

-- Using v_years2019thru2021 return the total number of reported & predicted overdoses per year 
SELECT State, 
       Abbr, 
       Year, 
       SUM(Reported_Overdoses) AS TotalReportedOverdoses, 
       SUM(Predicted_Overdoses) AS TotalPredicted
FROM v_years2019thru2021
GROUP BY Year, State, Abbr
ORDER BY State;

-- Display the total number of reported and predicted overdose deaths in the United States 
-- Limit search between the 2019-2021 time period
SELECT Abbr,
	   State, 
       Year,
       SUM(Reported_Overdoses) AS TotalOverdoseDeaths,
       SUM(Predicted_Overdoses) AS TotalPredictedDeaths
FROM v_years2019thru2021
WHERE Abbr = 'US'
GROUP BY Year, Abbr, State;

-- Create a view showing the total number of reported overdoses per year for each state
-- Exclude United States
CREATE VIEW v_TotalOverdoseDeaths
AS
SELECT Abbr, State, Year, SUM(Reported_Overdoses) as TotalReportedOverdoses
FROM v_years2019thru2021
WHERE Abbr <> 'US'
GROUP BY Year, Abbr, State;

-- Call v_TotalOverdoseDeaths view
-- Order by Year and TotalReportedOverdoses ascending
SELECT *
FROM v_TotalOverdoseDeaths
ORDER BY Year, TotalReportedOverdoses ASC;

-- Show the state with the highest overdose deaths for each year 
SELECT Year, 
       State, 
       TotalReportedOverdoses
FROM v_TotalOverdoseDeaths
WHERE TotalReportedOverdoses IN (SELECT MAX(TotalReportedOverdoses) FROM v_TotalOverdoseDeaths GROUP BY Year);

-- Return the 5 states/territories with the highest reported drug overdoses in the year 2021
SELECT State, 
       TotalReportedOverdoses 
FROM v_TotalOverdoseDeaths 
WHERE Year = 2021
ORDER BY TotalReportedOverdoses DESC 
LIMIT 5;

-- Show the state with the lowest overdose death for each year 
SELECT Year, 
	   State, 
       TotalReportedOverdoses
FROM v_TotalOverdoseDeaths
WHERE TotalReportedOverdoses IN (SELECT MIN(TotalReportedOverdoses) FROM v_TotalOverdoseDeaths GROUP BY Year);

-- Return the 5 states/territories with the lowest reported drug overdoses in the year 2021
SELECT State, TotalReportedOverdoses 
FROM v_TotalOverdoseDeaths 
WHERE Year = 2021
ORDER BY TotalReportedOverdoses ASC 
LIMIT 5;

-- Create a stored procedure using v_TotalOverdoseDeaths
-- Display year, state abbrv and name, and the total number of drug overdose deaths
-- Use the year and state columns as user input parameters 
DELIMITER //

CREATE PROCEDURE sp_OD_Deaths_by_YearState(
	IN YearValue INT, StateName VARCHAR(50)
)
BEGIN
	SELECT *
	FROM v_TotalOverdoseDeaths
    WHERE (Year = YearValue AND State = StateName);
END //

DELIMITER ;

-- Call newly defined stored procedure sp_OD_Deaths_by_YearState
-- specifiy the year as 2019 and state as Louisiana
CALL sp_OD_Deaths_by_YearState(2019, 'Louisiana');

-- Year-Over-Year
SELECT Year,
       State,
       TotalReportedOverdoses,
       LAG(TotalReportedOverdoses) OVER (ORDER BY Year) AS ReportedODs_Previous_Year,
       TotalReportedOverdoses - LAG(TotalReportedOverdoses) OVER (ORDER BY Year) AS YOY_Difference,
       CONCAT(ROUND((((TotalReportedOverdoses - LAG(TotalReportedOverdoses) OVER (ORDER BY Year)) / LAG(TotalReportedOverdoses) OVER (ORDER BY Year)) * 100),2), '%') AS YOY_Percent_Diff
FROM   v_TotalOverdoseDeaths
WHERE State = 'California';

-- Year-Over-Year_ALL
SELECT Year,
       State,
       TotalReportedOverdoses,
       LAG(TotalReportedOverdoses) OVER (ORDER BY Year) AS ReportedODs_Previous_Year,
       TotalReportedOverdoses - LAG(TotalReportedOverdoses) OVER (PARTITION BY State ORDER BY State, Year) AS YOY_Difference,
       CONCAT(ROUND((((TotalReportedOverdoses - LAG(TotalReportedOverdoses) OVER (PARTITION BY State ORDER BY State, Year)) / LAG(TotalReportedOverdoses) OVER (PARTITION BY State ORDER BY State, Year)) * 100),2), '%') AS YOY_Percent_Diff
FROM   v_TotalOverdoseDeaths;


/*
Queries for Tableau Visuals:
*/
-- 1
-- Total reported and predicted deaths in the year 2021
-- United States is removed from this query
SELECT State, Abbr, SUM(Reported_Overdoses) as TotalReportedOverdoses, SUM(Predicted_Overdoses) as TotalPredicted
FROM v_years2019thru2021
WHERE (Year = 2021 AND Abbr <> 'US')
GROUP BY State, Abbr
ORDER BY State;

-- 2
-- Top five states with the highest reported overdoses in 2021
SELECT State, 
       TotalReportedOverdoses 
FROM v_TotalOverdoseDeaths 
WHERE Year = 2021
ORDER BY TotalReportedOverdoses DESC 
LIMIT 5;

-- 3
-- Top five states with the lowest reported overdoses in 2021
SELECT State, TotalReportedOverdoses 
FROM v_TotalOverdoseDeaths 
WHERE Year = 2021
ORDER BY TotalReportedOverdoses ASC 
LIMIT 5;

-- 4
-- Reported deaths 
-- Filtered by drug type, month, and years '19-'21
SELECT *, 
	   CONCAT(Month, " ", Year) AS MonthYr  
FROM  v_Indicators2019_2021;

-- 5
-- Year-Over-Year_ALL
SELECT Year,
       State,
       Abbr,
       TotalReportedOverdoses,
       LAG(TotalReportedOverdoses) OVER (ORDER BY Year) AS ReportedODs_Previous_Year,
       TotalReportedOverdoses - LAG(TotalReportedOverdoses) OVER (PARTITION BY State ORDER BY State, Year) AS YOY_Difference,
       CONCAT(ROUND((((TotalReportedOverdoses - LAG(TotalReportedOverdoses) OVER (PARTITION BY State ORDER BY State, Year)) / LAG(TotalReportedOverdoses) OVER (PARTITION BY State ORDER BY State, Year)) * 100),2), '%') AS YOY_Percent_Diff
FROM   v_TotalOverdoseDeaths;

-- 6
-- US Grand Totals
SELECT Abbr,
	   State, 
       Year,
       SUM(Reported_Overdoses) AS TotalOverdoseDeaths,
       SUM(Predicted_Overdoses) AS TotalPredictedDeaths
FROM v_years2019thru2021
WHERE Abbr = 'US'
GROUP BY Year, Abbr, State;

-- 7
-- Grand OD Totals By State
SELECT State,
       Abbr,
       SUM(TotalReportedOverdoses) AS 3YrGrandODTotal
FROM v_TotalOverdoseDeaths
GROUP BY State, Abbr;
		
  
	

