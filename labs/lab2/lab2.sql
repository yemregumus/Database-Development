
-- Purpose: Lab 3 DBS301
-- ***********************

-- Question 1 Display the difference between the Average pay and Lowest pay in the company.  
-- Name this result Real Amount.  Format the output as currency with 2 decimal places.

-- Q1 SOLUTION --

SELECT
   TO_CHAR(AVG(nvl(salary,0) + nvl(salary,0) * nvl(commission_pct, 0)) - MIN(nvl(salary,0) + nvl(salary,0) * nvl(commission_pct, 0)), '$99,999.99') AS "Real Amount"
FROM employees;

-- Question 2 Display the department number and Highest, Lowest and Average pay per each department.
--Name these results High, Low and Avg.  Sort the output so that the department with highest average salary is shown first.  
--Format the output as currency where appropriate

-- Q2 SOLUTION --

SELECT
    d.department_id,
    TO_CHAR(MAX(nvl(salary,0) + nvl(salary,0) * nvl(commission_pct, 0)), '$99,999.99') AS "Highest",
    TO_CHAR(MIN(nvl(salary,0) + nvl(salary,0) * nvl(commission_pct, 0)), '$99,999.99') AS "Lowest",
    TO_CHAR(AVG(nvl(salary,0) + nvl(salary,0) * nvl(commission_pct, 0)), '$99,999.99') AS "Average"
FROM departments d
LEFT OUTER JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_id
ORDER BY round(AVG(nvl(salary,0) + nvl(salary,0) * nvl(commission_pct, 0)),2) DESC;

-- QUESTION 3
-- Display how many people work the same job in the same department. Name these results Dept#, Job and How Many.
-- Include only jobs that involve more than one person.  Sort the output so that jobs with the most people involved are shown first.

-- Q3 SOLUTION --

SELECT 
    department_id AS "Dept#",
    job_id AS "JOB",
    COUNT(employee_id) AS "How Many"
FROM employees
GROUP BY 
    department_id,
    job_id
HAVING COUNT(employee_id) > 1 
ORDER BY round(COUNT(employee_id)) DESC;



-- QUESTION 4
-- For each job title display the job title and total amount paid each month for this type of the job.
-- Exclude titles AD_PRES and AD_VP and also include only jobs that require more than $11,000.  
-- Sort the output so that top paid jobs are shown first.

-- Q4 SOLUTION --
SELECT
    job_id AS "Job Description",
    TO_CHAR(SUM(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct, 0)), '$99,999.99') AS "Total Amount"
FROM employees
WHERE
    job_id NOT IN('AD_PRES', 'AD_VP')
GROUP BY job_id
HAVING SUM(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct, 0)) > 11000
ORDER BY SUM(NVL(salary,0) + NVL(salary,0) * NVL(commission_pct, 0)) DESC;


-- QUESTION 5
-- For each manager number display how many persons he / she supervises.
-- Exclude managers with numbers 100, 101 and 102 and also include only those managers that supervise more than 2 persons.  
-- Sort the output so that manager numbers with the most supervised persons are shown first.

-- Q5 SOLUTION --
SELECT DISTINCT
    e.employee_id AS "ManagerID",
    COUNT(m.manager_id) AS "How Many Supervised"
FROM
    employees e
JOIN employees m ON e.employee_id = m.manager_id
WHERE e.employee_id NOT IN(100,101,102)
GROUP BY e.employee_id
HAVING COUNT(m.manager_id) > 2
ORDER BY round(COUNT(m.manager_id), 2) DESC;

-- QUESTION 6
-- For each department show the latest and earliest hire date, BUT exclude departments 10 and 20
-- exclude those departments where the last person was hired in this decade. (it is okay to hard code dates in this question only)
-- Sort the output so that the most recent, meaning latest hire dates, are shown first.

-- Q6 SOLUTION --
SELECT
    department_id AS "Department Code",
    TO_CHAR(MIN(hire_date), 'DD-MM-YYYY') AS "Earliest Hire Date",
    TO_CHAR(MAX(hire_date), 'DD-MM-YYYY') AS "Latest Hire Date"    
FROM employees
WHERE NVL(department_id, 0) NOT IN(10,20)
GROUP BY department_id
HAVING MAX(hire_date) < TO_DATE('2021-01-01', 'YYYY-DD-MM')
ORDER BY MAX(hire_date) DESC;
