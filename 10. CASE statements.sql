-- This MySQL script models the basic use of the CASE statement

SELECT first_name,
	last_name,
    age,
CASE
	WHEN age <= 30 THEN 'Young' 
END 
FROM employee_demographics;

SELECT first_name,
	last_name,
    age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 and 50 THEN 'Old'
    WHEN age >= 50 THEN "On Death's Door"
END AS Age_Bracket 
FROM employee_demographics;

-- Pay Increase and Bonus 
-- < 50000 = 5%
-- > 50000 = 7%
-- Finance = 10% Bonus

SELECT *
FROM employee_salary;

SELECT first_name,
	last_name,
    salary,
CASE 
	WHEN salary > 50000 THEN salary + (salary * 0.05)
    WHEN salary < 50000 THEN salary + (salary * 0.07)
END AS New_Salary 
FROM employee_salary;

SELECT * 
FROM employee_salary;
SELECT *
FROM parks_departments;
SELECT *
FROM employee_salary;

SELECT first_name,
	last_name,
    salary,
CASE 
    WHEN dept_id = 6 THEN (salary * .10)
END AS Bonus 
FROM employee_salary;

