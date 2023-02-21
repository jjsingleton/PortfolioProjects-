/*
Project Description: This project explores Gulf Coast Regional Medicare Hospital Spending aggregated by claim type, 
					 during index hospital admission, for the calendar year 2021. Utilizing MySQL Server tools, 
                     in this project we take the forementioned data and transform it to make it more usable for analysis.

Skills Used: This project highlights one’s ability to perform table joins, table alterations, create temporary tables,
			 as well a creating stored functions using MySQL syntax. 
                     
Data Source: The data used for this MySQL project was the 
			 Medicare Hospital Spending by Claim
             obtained from the Centers for Medicare & Medicaid Services
             
Data Source/Dictionary Link: https://data.cms.gov/provider-data/dataset/nrth-mfg3/

*/
/*
Create Schema and Import table 
This step was done using the MySQL data import wizard

CREATE SCHEMA `Medicare Spending`;

*/

/* 
Data Preprocessing
*/

-- Return the number of columns and rows of each table in the database
SELECT TABLE_NAME, COUNT(*) as Number_of_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'facility'
UNION ALL
SELECT TABLE_NAME, COUNT(*) as Number_of_Columns
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'claims';

SELECT 'facility', COUNT(*) Number_of_Rows
FROM facility
UNION ALL
SELECT 'claims', COUNT(*) Number_of_Rows 
FROM claims;

-- Display the contents of facility table
SELECT *
FROM facility;

-- Return each unique facility and store it's contents by creating a view
CREATE VIEW v_MedicalCenters
AS 
SELECT DISTINCT *
FROM facility;

SELECT * 
FROM v_MedicalCenters;

-- Create a temp table showing only the Gulf Coast Region Facilities
CREATE TEMPORARY TABLE tbl_GulfCoast 
SELECT *
FROM v_MedicalCenters
WHERE State IN ('AL', 'FL', 'LA', 'MS', 'TX');

SELECT *
FROM tbl_GulfCoast;

-- Display the contents of claims table
SELECT *
FROM claims;

-- Add a column to the claims table that gives each claim a unique ID
ALTER TABLE claims 
ADD COLUMN Claim_ID INT(10) UNSIGNED NOT NULL AUTO_INCREMENT FIRST,
ADD PRIMARY KEY (Claim_ID); 

-- Create temp table using the claims table 
-- set the Period attribute to those During Index Hospital Admission 
CREATE TEMPORARY TABLE tbl_Period 
SELECT *
FROM claims
WHERE Period = 'During Index Hospital Admission';

SELECT *
FROM tbl_Period;

-- Drop temp tables
DROP TABLE IF EXISTS tbl_GulfCoast;
DROP TABLE IF EXISTS tbl_Period;

-- Create a view by joining the claims and facility tables together
-- Join the tables using the same conditions of temp tables
CREATE VIEW v_GC_During
AS 
SELECT c.`Facility ID`,
	   f.`Facility Name`,
       f.State,
       c.Claim_ID,
	   c.Period,
       c.`Claim Type`,
       c.`Avg Spndg Per EP Hospital`,
       c.`Avg Spndg Per EP State`,
       c.`Avg Spndg Per EP National`,
       c.`Percent of Spndg Hospital`,
       c.`Percent of Spndg State`,
       c.`Percent of Spndg National`
	FROM claims c
	LEFT JOIN v_MedicalCenters f
		ON c.`Facility ID` = f.`Facility ID`
        WHERE c.Period = 'During Index Hospital Admission'
			AND (f.State IN ('AL', 'FL', 'LA', 'MS', 'TX'))
        ORDER BY c.Claim_ID;
        
SELECT *
FROM v_GC_During;

/*
Insight Queries using v_GC_During
These queries pertains to medicare spending from Gulf Coast Region faciliites where the claims occured during hospital stay
*/

-- Identify the total number of claims made
-- WHERE `Avg Spndg Per EP Hospital` != 0
-- The where condition eliminates claims where 0 money was spent [no claims were made]
SELECT COUNT(Claim_ID) as TotalClaims
FROM v_GC_During
WHERE `Avg Spndg Per EP Hospital` != 0;

-- Identify the total number of claims per state
SELECT State,
       COUNT(Claim_ID) as TotalClaims_State
FROM v_GC_During
WHERE `Avg Spndg Per EP Hospital` != 0
GROUP BY 1;

-- Identify the various claim types
SELECT DISTINCT `Claim Type`
FROM v_GC_During;

-- Claim Type totals
-- Do not include claims with zero spending value
SELECT `Claim Type`,
    COUNT(IF(`Avg Spndg Per EP Hospital` != 0,
            `Claim Type`,
            NULL)) AS TotalClaims
FROM v_GC_During
GROUP BY 1;

-- Return the total number of claims/per type in every state
SELECT State,
	   `Claim Type`,
	   COUNT(`Claim Type`) AS Claim_Totals 
FROM v_GC_During
WHERE `Avg Spndg Per EP Hospital` != 0
GROUP BY 1,2;

-- Identify the total avg spending 
SELECT SUM(`Avg Spndg Per EP Hospital`) AS AvgTotalSpending
FROM v_GC_During;

-- Return the total avg spending by state 
SELECT State,
       SUM(`Avg Spndg Per EP Hospital`) AS AvgTotalSpending
FROM v_GC_During
GROUP BY 1
ORDER BY AvgTotalSpending ASC;

-- Return the total avg spending by facility 
SELECT `Facility ID`,
	   `Facility Name`,
       State,
       SUM(`Avg Spndg Per EP Hospital`) as AvgTotalSpending
FROM v_GC_During
GROUP BY 1,2,3
ORDER BY AvgTotalSpending DESC;

-- Avg Spndg per state/national for each claim type 
SELECT DISTINCT State, 
				`Claim Type`, 
				`Avg Spndg Per EP State`,
                `Avg Spndg Per EP National`
FROM v_GC_During;

-- Stored function 
-- spending level (state target)
DELIMITER //
CREATE FUNCTION f_SpndgLvl (`Avg Spndg Per EP Hospital` INT, `Avg Spndg Per EP State` INT)
RETURNS varchar(50)
READS SQL DATA
DETERMINISTIC
BEGIN

   DECLARE spending_level varchar(50);

   IF `Avg Spndg Per EP Hospital` < `Avg Spndg Per EP State` THEN
      SET spending_level = 'Below State Avg';

   ELSEIF `Avg Spndg Per EP Hospital` > `Avg Spndg Per EP State` THEN
      SET spending_level = 'Above State Avg';
      
   ELSEIF (`Avg Spndg Per EP Hospital` = `Avg Spndg Per EP State`) THEN
      SET spending_level = 'At State Avg';    

   END IF;

   RETURN spending_level;

END; //

DELIMITER ;

-- call function
SELECT `Facility ID`,
	   `Facility Name`,
       State,
       `Claim Type`,
       `Avg Spndg Per EP Hospital`,
       `Avg Spndg Per EP State`,
       f_SpndgLvl(`Avg Spndg Per EP Hospital`, `Avg Spndg Per EP State`) as SpendingLevel
FROM v_GC_During;


