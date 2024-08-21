-- This MySQL script models how to create triggers and events

-- triggers (takes place when events occur) 
SELECT *
FROM employee_demographics;

SELECT *
FROM employee_salary;


DELIMITER $$
CREATE TRIGGER employee_insert
	AFTER INSERT ON employee_salary
    FOR EACH ROW 
BEGIN
	INSERT INTO employee_demographics (employee_id, first_name, last_name)
    VALUES (NEW.employee_id, NEW.first_name, NEW.last_name);
END $$
DELIMITER ;

INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES(13, 'Jackie', 'Christie', 'Entertainment CEO', 1000000, NULL); 


-- EVENTS (takes place when scheduled) 

SELECT *
FROM employee_demographics;

DELIMITER $$
CREATE EVENT delete_retirees
ON SCHEDULE EVERY 1 MONTH
DO 
BEGIN
	DELETE
	FROM employee_demographics
    WHERE age >= 60;
END $$
DELIMITER ;

-- troubleshooting  
SHOW VARIABLES LIKE 'event%';
