-- This MySQL script models the basic use of the MySQL HAVING clause compared to the WHERE statement

SELECT gender, AVG(age)
FROM employee_demographics 
GROUP BY gender
HAVING AVG(age) > 40;

SELECT *
FROM employee_salary;

SELECT occupation, AVG(salary)
FROM employee_salary
GROUP BY occupation;

SELECT occupation, AVG(salary)
FROM employee_salary
WHERE occupation LIKE '%manager%'
GROUP BY occupation
HAVING AVG(salary) > 75000;