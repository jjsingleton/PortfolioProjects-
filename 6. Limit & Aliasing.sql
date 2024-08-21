-- This MySQL script models the basic use of LIMIT and aliases in MySQL 

SELECT *
FROM employee_demographics
LIMIT 3;

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 3;

SELECT *
FROM employee_demographics
ORDER BY age DESC
LIMIT 2, 1;

-- Aliasing 

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender;

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING avg_age > 40;