
-- Purpose: Lab 4 DBS301

-- ***********************

 

--Q1 answer

SELECT department_id
FROM departments

MINUS

SELECT department_id
FROM departments
WHERE department_id LIKE '50';

--Q2 answer

--2.         HR department requests a list of countries that have no departments located in them.
--Display country ID and the country name. Use SET operators. 

SELECT
    country_id,
    country_name
FROM countries

MINUS

SELECT
    country_id,
    country_name
FROM countries
INNER JOIN locations USING(country_id)
INNER JOIN departments USING(location_id);

--3.         The Vice President needs very quickly a list of departments 10, 50, 20 in that order. job and department ID are to be displayed.

SELECT DISTINCT
        job_id,
        department_id
FROM employees
WHERE department_id LIKE '10'

UNION ALL

SELECT DISTINCT
        job_id,
        department_id
FROM employees
WHERE department_id LIKE '50'

UNION ALL

SELECT DISTINCT
        job_id,
        department_id
FROM employees
WHERE department_id LIKE '20';

--4.         Create a statement that lists the employeeIDs and JobIDs of those employees who currently have a job title

--that is the same as their job title when they were initially hired by the company

--(that is, they changed jobs but have now gone back to doing their original job).

SELECT
    employee_id,
    job_id
FROM employees

INTERSECT

SELECT
    employee_id,
    job_id
FROM job_history;

--5.         The HR department needs a SINGLE report with the following specifications:
--a.         Last name and department ID of all employees regardless of whether they belong to a department or not.
--b.         Department ID and department name of all departments regardless of whether they have employees in them or not.
--Write a compound query to accomplish this.

SELECT 
    last_name, 
    department_id,
    TO_CHAR('null')
FROM employees

UNION

SELECT 
    TO_CHAR('null'),
    department_id, 
    department_name
FROM departments;
