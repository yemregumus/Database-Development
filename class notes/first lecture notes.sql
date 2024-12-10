

-- Example
-- List all employees

SELECT * FROM employees; -- commands are in uppercase table names will be lowercase

-- list all employees (lastname, firstname) sort by last name

SELECT
            employee_id,
            last_name || ', ' || first_name AS empName, -- this is a calculated(concanted) field so it has to have an alias so empName is an alias
            email,
            phone_number,
            job_id
FROM employees
ORDER BY last_name;

-- single quotes vs double quotes

SELECT
            employee_id,
            last_name || ', ' || first_name AS "empName", -- dont do this its not a good design
            email,
            phone_number,
            job_id
FROM employees
ORDER BY last_name;

-- distinct

SELECT DISTINCT job_id -- all columns has to be the same for it to eliminate them. if anyone of them is different it will list them too
FROM  employees
ORDER BY job_id;

-- to_char()
-- list all employees and shot their hire date (human readable)

SELECT 
        employee_id,
        first_name,
        last_name,
        hire_date -- dont do this.
FROM employees
ORDER BY hire_date; 

-- but for human readable we need to do this

SELECT 
        employee_id,
        first_name,
        last_name,
        TO_CHAR(hire_date, 'Month dd, yyyy') AS hireDate -- do this.
FROM employees
ORDER BY hire_date; 

--lets update 

UPDATE employees SET hire_date = hire_date + (365 * 20 + 4);

-- to_date()
--find all employees hired after May 6, 2011

SELECT 
        employee_id,
        first_name,
        last_name,
        TO_CHAR(hire_date, 'Month dd, yyyy') AS hireDate 
FROM employees
WHERE 
        hire_date > '11-05-10' -- dont do this!! wrong interpret
ORDER BY hire_date; 

-- do this instead

SELECT 
        employee_id,
        first_name,
        last_name,
        TO_CHAR(hire_date, 'Month dd, yyyy') AS hireDate 
FROM employees
WHERE 
        hire_date > TO_DATE('11-05-10', 'yy-mm-dd') -- correct statement for all timezone settings in all computers
ORDER BY hire_date; 

-- case sensitivity
-- find ALL employees whos last name starts with an 'M'

SELECT 
          employee_id,
          first_name,
          last_name,
          email
FROM employees
WHERE last_name = 'M%' -- %means anything after M or m but this is not going to work
ORDER BY 
         last_name,
         first_name;
         
-- do this instead

SELECT 
          employee_id,
          first_name,
          last_name,
          email
FROM employees
WHERE LOWER(last_name) LIKE 'm%' -- this is going to work
ORDER BY 
         last_name,
         first_name;
