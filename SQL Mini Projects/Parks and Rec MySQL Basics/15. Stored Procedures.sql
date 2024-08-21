-- This MySQL script models how to create stored procedures with and without parameters

-- basic sp example  
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CREATE PROCEDURE large_salaries()
SELECT *
FROM employee_salary
WHERE salary >= 50000;

CALL large_salaries();

-- complex sp 
DELIMITER $$
CREATE PROCEDURE large_salaries2()
BEGIN 
	SELECT *
	FROM employee_salary
	WHERE salary >= 50000;
	SELECT *
	FROM employee_salary
	WHERE salary >= 10000;
END $$
DELIMITER ; 

CALL large_salaries2();

-- parameters 
DELIMITER $$
CREATE PROCEDURE large_salaries3(emp_ID_param INT)
BEGIN 
	SELECT salary
	FROM employee_salary
    WHERE employee_id = emp_ID_param;
END $$
DELIMITER ; 

CALL large_salaries3(1);