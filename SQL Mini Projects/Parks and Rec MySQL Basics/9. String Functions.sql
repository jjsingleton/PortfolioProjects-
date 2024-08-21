-- This MySQL script models the use of string functions 

-- LENGTH 
SELECT LENGTH('skyfall');

SELECT first_name, 
	LENGTH(first_name)
FROM employee_demographics
ORDER BY 2;

-- UPPER & LOWER 
SELECT UPPER('sky');
SELECT LOWER('SKY');

SELECT first_name, 
	UPPER(first_name)
FROM employee_demographics
ORDER BY 2;

-- TRIM 
SELECT TRIM('          sky       ');
SELECT LTRIM('          sky       ');
SELECT RTRIM('          sky       ');

-- Substring 
SELECT * 
FROM employee_demographics;

SELECT first_name, 
	LEFT(first_name, 4)
FROM employee_demographics;

SELECT first_name, 
	LEFT(first_name, 4), 
    RIGHT(first_name, 4)
FROM employee_demographics;

SELECT first_name, 
	LEFT(first_name, 4), 
    RIGHT(first_name, 4),
    SUBSTRING(first_name, 3,2)
FROM employee_demographics;

SELECT first_name, 
	LEFT(first_name, 4), 
    RIGHT(first_name, 4),
    SUBSTRING(first_name, 3,2),
    birth_date,
    SUBSTRING(birth_date, 6,2) AS birth_mmonth
FROM employee_demographics;

-- REPLACE 
SELECT *
FROM employee_demographics;

SELECT first_name, 
	REPLACE(first_name, 'a', 'z')
FROM employee_demographics;

-- LOCATE 
SELECT LOCATE('o', 'JaCorey');


SELECT first_name,
	LOCATE('An', first_name)
FROM employee_demographics;

-- CONCAT 
SELECT first_name,
	last_name,
CONCAT(first_name, ' ', last_name) AS full_name
FROM employee_demographics;
