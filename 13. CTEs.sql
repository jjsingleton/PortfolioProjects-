-- This MySQL script demonstrates CTEs (common table expressions)

-- subquery 
SELECT AVG(avg_sal)
FROM (SELECT gender,
	AVG(salary) avg_sal,
    MAX(salary) max_sal, 
    MIN(salary) min_sal, 
    COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
) example_subquery;

-- CTE  
WITH CTE_Example AS
(
SELECT gender,
	AVG(salary) avg_sal,
    MAX(salary) max_sal, 
    MIN(salary) min_sal, 
    COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT AVG(avg_sal)
FROM CTE_Example;

-- CTE alias  
WITH CTE_Example (Gender, AVG_Sal, MAX_Sal, MIN_Sal, COUNT_Sal) AS
(
SELECT gender,
	AVG(salary) avg_sal,
    MAX(salary) max_sal, 
    MIN(salary) min_sal, 
    COUNT(salary) count_sal
FROM employee_demographics dem
JOIN employee_salary sal
	ON dem.employee_id = sal.employee_id
GROUP BY gender
)
SELECT *
FROM CTE_Example;

-- Multiple CTE 
WITH CTE_Example AS
(
SELECT employee_id,
	gender,
    birth_date
FROM employee_demographics dem
WHERE birth_date > '1985-01-01'
),
CTE_Example2 AS
(
SELECT employee_id,
	salary
FROM employee_salary
WHERE salary > 50000
)
SELECT *
FROM CTE_Example
JOIN CTE_Example2
	ON CTE_Example.employee_id = CTE_Example2.employee_id;