-- **********************************************
-- Name : Yunus Gumus
-- StudID: 150331197
-- Date   : Sept 11, 2022
-- Title    : NII Week 1 Lab 1
-- **********************************************

-- QUESTION 1

SELECT 
        last_name AS "LName", 
        job_id AS "Job Title", -- i added AS clause to create aliases and fixed the quotes
        hire_date AS "Job Start" -- hire date, it cant have a space inbetween and it should be all lowercase because it is a table name
FROM employees;

--QUESTION 2

SELECT
    employee_id,
    last_name,
    TO_CHAR(salary, '$99,999.99') AS SALARY
FROM employees
WHERE
    salary > 8000 AND salary < 11000 --use between instead
ORDER BY 
    salary, --forgot ordering desc
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
WHERE LOWER(city) LIKE LOWER('%&acountry%');--using trim would be nice since we dont know what user will enter

--QUESTION 6

SELECT TO_CHAR(current_date +1, 'FMMonth DD"th of year" YYYY') AS Tomorrow
FROM DUAL;

--QUESTION 7

SELECT
    last_name AS "Last Name",
    first_name AS "First Name",
    department_name AS "Department",
    salary AS "Salary",
    round(salary * 1.04) AS "Good Salary",
    (round(salary *1.04) - salary) * 12 AS "Annual Pay Increase"
FROM employees e
JOIN departments d ON d.department_id = e.department_id
WHERE e.department_id = 20 -- could do dept IN(20,50,60,)
OR e.department_id = 50
OR e.department_id = 60;

--QUESTION 8
--do not hardcode todays date

SELECT
    last_name AS "Last Name",
    to_char(hire_date, 'mm-dd-yyyy') AS "Hire Date",
floor(MONTHS_BETWEEN (current_date, hire_date) / 12) AS "Years Worked"
FROM employees
WHERE hire_date < to_date('01-01-2014', 'MM-DD-YYYY')
ORDER BY "Years Worked";

--QUESTION 9 

SELECT
    city AS "City Name",
    country_id AS "Country Code",
    NVL(state_province, 'Unknown Province') AS "Province Name"
FROM locations
WHERE city LIKE 'S_______%'; --should be length(city) >= 8; instead of underscores

--QUESTION 10

SELECT
    last_name AS "Last Name",
    hire_date AS "Hire Date",
    TO_CHAR(
        NEXT_DAY(
            ADD_MONTHS(hire_date, 12), 'thursday'
            ),  'Day,Month "the" Ddsp"th of the year" YYYY' ) AS "Salary Review Date"
FROM employees
WHERE hire_date > to_date('2017', 'YYYY') --use extract(year from hire_date) > 2017 instead
ORDER BY hire_date;


