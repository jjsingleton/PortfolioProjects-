-- This MySQL script models the basic use of the MySQL SELECT statement 

SELECT * 
FROM employee_demographics;

SELECT first_name, 
	last_name, 
    birth_date 
FROM employee_demographics;

SELECT first_name, 
	last_name, 
    birth_date,
    age,
    age + 10
FROM employee_demographics;

SELECT first_name, 
	last_name, 
    birth_date,
    age,
    (age + 10) * 10 -- PEMDAS
FROM employee_demographics;

SELECT DISTINCT gender
FROM employee_demographics;