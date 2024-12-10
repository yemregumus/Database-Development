

/* 
NOTES
-- Make sure you follow the course style guide for SQL as posted on blackboard.
-- Data should always be sorted in a logical way, for the question, even if the 
   question does not specify to sort it.
*/

-- Q1
/* 
Provide a list of ALL departments, what city they are located in, and the name
of the current manager, if there is one.  
*/
SELECT
    d.department_name,
    l.city,
    e.first_name || ' ' || e.last_name AS "Manager Name"
FROM departments d 
    LEFT JOIN locations l ON d.location_id = l.location_id
    LEFT JOIN employees e ON e.employee_id = d.manager_id
--WHERE d.manager_id IS NOT NULL no need to put this 
ORDER BY d.department_name;
-- Q2
/*
Allow the user to enter the name of a country, or any part of the name, and 
then list all employees, with their job title, currently working in that country.
*/
SELECT 
    e.first_name || ' ' || e.last_name AS "Employee Name",
    e.job_id AS "Job Title",
    c.country_name AS "Country Name"
FROM employees e
    JOIN departments d USING(department_id) --use ON
    JOIN locations l USING(location_id)--use ON
    RIGHT OUTER JOIN countries c ON c.country_id = l.country_id--right outter with on
WHERE upper(country_name) LIKE '%' || trim(upper('&Country')) || '%'
ORDER BY 
    last_name, 
    first_name;

    
-- Q3
/*
Provide a contact list of all employees, and if they have a manager, 
the name of their direct manager.
*/
SELECT 
    e1.employee_id AS "EmpID",
    e1.first_name || ' ' || e1.last_name AS "Employee Name",
    e1.email AS "E-MAIL",
    e1.phone_number AS "Phone Number",
    e2.first_name || ' ' || e2.last_name AS "Direct Manager Name"
FROM employees e1 
    LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id
ORDER BY e1.employee_id;
    
    
-- Q4
/*
Provide a list of locations in the database, that currently do not have 
any employees working there.
*/
SELECT 
            city,
            location_id     
FROM
            locations
LEFT OUTER JOIN departments USING(location_id)
LEFT OUTER JOIN employees USING(department_id) 
WHERE employee_id IS NULL
ORDER BY city;


-- Q5
/*
Provide a list of employees whom are currently still in the same job that they
started in (i.e. they have never changed job titles).
*/
SELECT
    e.first_name || ' ' || e.last_name AS EmployeeName,
    e.employee_id AS "EmployeeID"
FROM employees e 
LEFT OUTER JOIN job_history j ON e.employee_id = j.employee_id
WHERE j.employee_id IS NULL
ORDER BY EmployeeName;

    
    
    
    
    
    
    