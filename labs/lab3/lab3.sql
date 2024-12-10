
-- Purpose: Lab 3 DBS301
-- ***********************

--Q1.Create an INSERT statement to do this.  Add yourself as an employee with a NULL salary, 
--   0.21 commission_pct, in department 90, and Manager 100.  You started TODAY.  

INSERT INTO 
        employees 
        (employee_id, 
         first_name, 
         last_name, 
         email, 
         phone_number, 
         hire_date, 
         job_id, 
         salary, 
         commission_pct, 
         manager_id, 
         department_id)
VALUES 
        (666, 
         'Yunus', 
         'Gumus', 
         'YGUMUS', 
         '437.238.1588', 
          SYSDATE, 
         'AD_VP', 
         NULL, 
         0.21, 
         100, 
         90);


--Q2.Create an Update statement to: Change the salary of the employees with a last name of Matos and Whalen to be 2500.

UPDATE employees
SET salary = 2500
WHERE last_name = (
        SELECT last_name
        FROM employees
        WHERE 
            upper(last_name) = upper('matos')) 
            OR last_name = (
                SELECT last_name
                FROM employees
                WHERE upper(last_name) = upper('whalen')
        );

--Q3.Make sure you run a commit statement after the first 2 steps to make those changes permanent.
    --You must use subqueries for these questions (must minimize the number of tables being used in the main query, some of these can be solved using advanced join statements, but that is not the point of this lab)
    
    COMMIT;
    
    
--Q4.Display the last names of all employees who are in the same department as the employee named Abel (DEPT 80).

SELECT last_name
FROM employees
WHERE department_id = (
        SELECT department_id
        FROM employees
        WHERE 
            last_name = (
                SELECT last_name
                FROM employees
                WHERE lower(last_name) = 'abel'        
        )

)
ORDER BY last_name;


--Q5.Display the last name of the lowest paid employee(s)

SELECT last_name AS lastName
FROM employees
WHERE salary IN (
        SELECT MIN(salary)
        FROM employees
        )
ORDER BY last_name;


--Q6.Display the city that the lowest paid employee(s) are located in.(YOU CAN DO IT WITH A JOIN BUT YOU DONT HAVE TO)
SELECT 
        l.city,
        e.first_name || '  ' || e.last_name AS employee_name,
       d.department_id AS dept_id
FROM locations l
JOIN departments d ON l.location_id = d.location_id
JOIN employees e ON e.department_id = d.department_id
WHERE l.location_id IN (
        SELECT location_id
        FROM departments
        WHERE department_id IN (
                SELECT department_id
                FROM employees
                WHERE NVL(salary,0) = (
                        SELECT MIN(NVL(salary,0) + NVL(salary * commission_pct,0))
                                FROM employees
                        )
                )
        )
ORDER BY e.first_name;


--Q7.Display the last name, department_id, and salary of the lowest paid employee(s) in each department.  
--   Sort by Department_ID. (HINT: careful with department 60) (use boolean operators MAYBE)

SELECT 
    last_name,
    department_id,
    salary
FROM employees 
WHERE (NVL(salary,0),NVL(department_id,0)) IN (
        SELECT 
        NVL(MIN(salary),0),
        NVL(department_id,0)
        FROM employees 
        GROUP BY department_id
        )
ORDER BY department_id;

--Q8.Display the last name of the lowest paid employee(s) in each city (you have to use a join it can be 50 lines without a join)

SELECT 
        last_name, 
        city
FROM employees
JOIN departments USING (department_id)
JOIN locations USING (location_id)
WHERE (location_id, NVL(salary,0)) IN (
        SELECT location_id, MIN(NVL(salary,0))
        FROM employees 
        JOIN departments USING (department_id)
        JOIN locations USING (location_id)
        WHERE city IN (
                SELECT city
                FROM locations
                WHERE location_id IN (
                        SELECT location_id
                        FROM departments
                        WHERE location_id IN (
                                SELECT location_id
                                FROM locations
                                )
                        )
                )   
GROUP BY location_id
)ORDER BY last_name;

--Q9.Display last name and salary for all employees who earn less than the lowest salary in any other department.  
--   Sort the output by top salaries first and then by last name.
--lowest salary people

SELECT 
        last_name AS LastName,
        salary AS Salary
FROM employees
WHERE salary < ANY (
        SELECT NVL(MIN(salary),0)
        FROM employees
        GROUP BY department_id
)
ORDER BY salary, last_name;

--Q10.Display last name, job title and salary for all employees whose salary matches any of the salaries from the IT Department. 
--    Do NOT use Join method.  Sort the output by salary ascending first and then by last_name

SELECT
        last_name AS LastName,
        job_id AS JobTitle,
        salary AS Salary
FROM employees
WHERE salary IN (
        SELECT salary
        FROM employees 
        WHERE department_id = 60)
AND department_id NOT LIKE 60-- i can delete after here but then it would show IT_PROG people too 
ORDER BY salary ASC, last_name;

