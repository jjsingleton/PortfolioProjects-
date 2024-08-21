-- This MySQL script demonstrates how to create temporary tables

-- BASIC Method of creating temp tables 
CREATE TEMPORARY TABLE temp_table
(first_name varchar(50),
last_name varchar(50),
favorite_movie varchar(100)
);

SELECT * 
FROM temp_table; 

INSERT INTO temp_table
VALUES('JaCorey', 'Singleton', 'ATL');

SELECT * 
FROM temp_table; 

-- Creating temp table w/existing tables 
SELECT *
FROM employee_salary;

CREATE TEMPORARY TABLE salary_over_50k
SELECT *
FROM employee_salary
WHERE salary >= 50000;

SELECT * 
FROM salary_over_50k;
