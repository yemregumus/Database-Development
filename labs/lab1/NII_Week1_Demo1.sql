-- **********************************************
-- Name: Clint MacDonald
-- StudID: 100999999
-- Date: Sept 6, 2022
-- Title: NII Week 1 Demo 1
-- **********************************************

-- Example
-- List all employees
SELECT * FROM employees;

-- list all employees (lastname, firstname) contact list sort by last name
SELECT
    employee_id,
    last_name || ', ' || first_name AS empName,
    email,
    phone_number,
    job_id
FROM employees
ORDER BY last_name;

-- single quotes vs double quotes
SELECT
    employee_id,
    last_name || ', ' || first_name AS "empName",
    email,
    phone_number,
    job_id
FROM employees
ORDER BY last_name;

-- distinct
SELECT DISTINCT job_id
FROM employees
ORDER BY job_id;

SELECT DISTINCT 
    job_id,
    manager_id
FROM employees
ORDER BY job_id;

-- to_char()
-- list all employees and show their hire date (human readable)
SELECT 
    employee_id,
    first_name,
    last_name,
    hire_date
FROM employees
ORDER BY hire_date;
-- but for human readable we need to 
SELECT 
    employee_id,
    first_name,
    last_name,
    TO_CHAR(hire_date, 'Month  dd, yyyy') AS hireDate
FROM employees
ORDER BY hire_date;

UPDATE employees SET hire_date = hire_date + (365*20 + 4);

-- to_date()
-- find all employees hired after May 6, 2011
SELECT 
    employee_id,
    first_name,
    last_name,
    TO_CHAR(hire_date, 'Month  dd, yyyy') AS hireDate
FROM employees
WHERE
    hire_date > TO_DATE('11-05-10', 'yy-mm-dd')
ORDER BY hire_date;

-- Case sensitivity
-- find all employees whose last name starts with 'M'
SELECT
    employee_id,
    first_name,
    last_name,
    email
FROM employees
WHERE UPPER(last_name) LIKE 'M%'
ORDER BY 
    last_name,
    first_name;

-- contains an "s"
SELECT
    employee_id,
    first_name,
    last_name,
    email
FROM employees
WHERE LOWER(last_name) LIKE '%s%'
ORDER BY 
    last_name,
    first_name;
    
    
-- last_name LIKE '%s%' OR last_name LIKE '%S%'

--% percent means anything in between 

--when we use & in front of a word we define a variable.


--three things to always check
--is it international? it means date time-zone etc
--is it case sensitive, oracle is default case sensitive
--does it not assume anything -- NO ASSUMPTION!!!

--question 8 answer should be exact!
--to be precise, there is only one function to be precise, look for months between function to calculate answer

-- **********************************************
-- Name: Yunus Gumus
-- StudID: 150331197
-- Date: Sept 8, 2022
-- Title: NII Week 1 Lab 1
-- **********************************************

-- QUESTION 1

SELECT last_name AS "LName", job_id AS "Job Title", -- i added AS clause to create aliases and fixed the quotes
       hire_date AS "Job Start" -- hire date, it cant have a space inbetween and it should be all lowercase because it is a table name
FROM employees;

--QUESTION 2

SELECT
    employee_id,
    last_name,
    TO_CHAR(salary, '$99,999.99') AS SALARY
FROM employees
WHERE
    salary > 8000 AND salary < 11000
ORDER BY 
    salary,
    last_name;
    
--QUESTION 3

SELECT
    employee_id,
    last_name,
    salary
FROM employees
WHERE
    salary > 8000 AND salary < 11000
ORDER BY 
    salary,
    last_name;
    
--QUESTION 4

SELECT
    job_id,
    first_name || ' ' || last_name AS "Full Name"
FROM employees
WHERE LOWER(first_name) LIKE '%e%';

--QUESTION 5

SELECT
    street_address,
    postal_code,
    city,
    state_province,
    country_id
FROM locations
WHERE LOWER(city) LIKE LOWER('%&acountry%');

--QUESTION 6

SELECT TO_DATE(current_date) 
FROM dual





--QUESTION 7

--QUESTION 8
--do not hardcode todays date


--QUESTION 9 

--QUESTION 10
