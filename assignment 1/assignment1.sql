-- **********************************************
-- Name : Yunus Gumus
-- StudID: 0
-- Date   : October 23, 2022
-- Title    : NII Group 1 Assignment 1
-- **********************************************

--1.	Display the employee number, full employee name, job and hire date of all employees hired in May or November of any year, 
--with the most recently hired employees displayed first. 
--•	Also, exclude people hired in 2015 and 2016.  
--•	Full name should be in the form “Lastname, Firstname”  with an alias called “FullName”.
--•	Hire date should point to the last day in May or November of that year (NOT to the exact day) and be in the form of 
--[May 31<st,nd,rd,th> of 2016] with the heading Start Date. Do NOT use LIKE operator. 
--•	<st,nd,rd,th> means days that end in a 1, should have “st”, days that end in a 2 should have “nd”, 
--days that end in a 3 should have “rd” and all others should have “th”
--•	You should display ONE row per output line by limiting the width of the Full Name to 25 characters. 
--The output lines should look like this line (4 columns):
--174	Abel, Ellen	SA_REP	[May 31st of 2016]

SELECT 
        employee_id,
        SUBSTR(last_name | | ', ' || first_name, 0, 25) AS FullName,
        job_id,
        TO_CHAR(LAST_DAY(HIRE_DATE), '"["FMMonth ddth" of" YYYY"]"') AS HireDate
FROM employees
WHERE
        TO_CHAR(HIRE_DATE, 'YYYY') NOT IN ('2015', '2016') 
AND
        TO_CHAR(HIRE_DATE, 'MON') IN ('MAY', 'NOV');

/*2.	List the employee number, full name, job and the modified salary for all employees whose monthly earning (without this increase)
is outside the range $6,500 – $11,500 and who are employed as Vice Presidents or Managers (President is not counted here).  
•	You should use Wild Card characters for this. 
•	VP’s will get 25% and managers 18% salary increase.  
•	Sort the output by the top salaries (before this increase) firstly.
•	Heading will be like Employees with increased Pay
•	The output lines should look like this sample line (note: 1 column):
Emp# 124 named Kevin Mourgos who is ST_MAN will have a new salary of $6960*/

SELECT 
        'Emp#' | | ' ' | | 
        employee_id | | ' ' | | 
        'named' | | ' ' | | first_name | | ' ' | | last_name | | ' ' | | 
        'who is ' | | ' ' | | job_id | | ' ' | | 
        'will have a new salary of $' | | 
        CASE
                WHEN upper(job_id) LIKE '%MAN' THEN (salary * 1.18)
                WHEN upper(job_id) LIKE '%VP' THEN (salary * 1.25)
        END 
        AS EmployeesWithIncreasedPay
FROM employees
WHERE 
         (UPPER(job_id) LIKE '%MAN' OR  UPPER(job_id) LIKE '%VP')
AND (NVL(salary,0) + NVL(salary * commission_pct,0)) NOT BETWEEN 6500 AND 11500
ORDER BY salary DESC;



/*3.	Display the employee last name, salary, job title and manager# of all employees not earning a commission OR if they work in the 
SALES department, but only  if their total monthly salary with $1000 included bonus and  commission (if  earned) is  greater  than  $15,000.  
•	Let’s assume that all employees receive this bonus.
•	If an employee does not have a manager, then display the word NONE 
•	instead. This column should have an alias Manager#.
•	Display the Total annual salary as well in the form of $135,600.00 with the 
•	heading Total Income. Sort the result so that best paid employees are shown first.
•	The output lines should look like this sample line (5 columns):
De Haan	17000	AD_VP	100	$216,000.00*/

SELECT 
        last_name as LastName,
        NVL(salary, 0) AS MonthlySalary,
        job_id AS JobTitle,
       NVL(to_char(manager_id), 'NONE')  AS Manager#,
       TO_CHAR(SUM((NVL(commission_pct,0) * salary + salary) * 12 + 1000), '$999,999.99') AS TotalIncome
FROM employees
WHERE (commission_pct IS NULL OR department_id = 80) 
AND (salary * (1 + NVL(commission_pct, 0)) + 1000 > 15000)
GROUP BY last_name, job_id,salary,manager_id
ORDER BY TotalIncome DESC;

/*4.	Display Department_id, Job_id and the Lowest salary for this combination under the alias Lowest Dept/Job Pay, 
but only if that Lowest Pay falls in the range $6500 - $16800. Exclude people who work as some kind of Representative job from this query
and departments IT and SALES as well.
•	Sort the output according to the Department_id and then by Job_id.
•	You MUST NOT use the Subquery method.*/

SELECT 
        department_id AS Dept#,
        job_id AS JobID, 
        MIN(salary) AS "Lowest Dept/Job Pay"
FROM employees e
JOIN departments d USING(department_id)
WHERE salary BETWEEN 6500 AND 16800 AND
                UPPER(d.department_name) NOT IN ('IT', 'SALES') AND
                UPPER(e.job_id) NOT LIKE '%_REP%'
GROUP BY department_id, job_id
ORDER BY department_id, job_id;


/*5.	Display last_name, salary and job for all employees who earn more than all lowest paid employees per department outside the US locations.
•	Exclude President and Vice Presidents from this query.
•	Sort the output by job title ascending.
•	You need to use a Subquery and Joining.*/

SELECT
        last_name AS LastName,
        salary AS Salary,
        job_id AS JobTitle
FROM employees 
WHERE salary > ANY (
                        SELECT salary
                        FROM employees 
                        WHERE (NVL(salary,0),NVL(department_id,0)) IN (
                                    SELECT
                                    NVL(MIN(salary),0),
                                    NVL(department_id,0)
                                    FROM employees e
                                    JOIN departments d USING(department_id)
                                    WHERE location_id NOT IN (1400, 1500, 1600, 1700) 
                                    GROUP BY department_id
                                    ) 
                        ) 
AND job_id NOT LIKE '%PRES%' AND job_id NOT LIKE '%VP%'
ORDER BY job_id;

---------------------------------------------------
SELECT
    last_name,
    TO_CHAR(salary, '$999,999.00') AS Salary,
    job_id
FROM employees
WHERE (salary) > ANY (
    SELECT
        MIN(salary) AS minSalary
    FROM employees e
        LEFT OUTER JOIN departments d ON e.department_id = d.department_id
        LEFT OUTER JOIN locations l ON d.location_id = l.location_id
    WHERE UPPER(l.country_id) NOT LIKE 'US'
    GROUP BY e.department_id
) AND UPPER(job_id) NOT LIKE '%VP%' AND UPPER(job_id) NOT LIKE '%PRES%'
ORDER BY job_id;



/*6.	Who are the employees (show last_name, salary and job) who work either in IT or MARKETING department 
and earn more than the worst paid person in the ACCOUNTING department. 
•	Sort the output by the last name alphabetically.
•	You need to use ONLY the Subquery method (NO joins allowed).*/

SELECT 
            last_name AS LastName,
            salary AS Salary,
            job_id AS JobTitle
FROM employees
WHERE salary > ALL (
                        SELECT MIN(salary)
                        FROM employees
                        WHERE upper(job_id) LIKE '%AC_%')
AND (upper(job_id) LIKE 'IT%' OR upper(job_id) LIKE 'MK%')
ORDER BY last_name ASC;
            
/*7.	Display alphabetically the full name, job, salary (formatted as a currency amount incl. thousand separator, but no decimals) 
and department number for each employee who earns less than the best paid unionized employee (i.e. not the president nor any manager nor any VP), 
and who work in either SALES or MARKETING department.  
•	Full name should be displayed as Firstname Lastname and should have the heading Employee. 
•	Salary should be left-padded with the = symbol till the width of 15 characters. It should have an alias Salary.
•	You should display ONE row per output line by limiting the width of the 	Employee to 24 characters.
•	The output lines should look like this sample line (4 columns):
Jonathon Taylor	SA_REP	=======  $8,600	80*/
		 
SELECT 
        SUBSTR(first_name| | ' ' || last_name , 0, 24) AS Employee,
        job_id,
        LPAD(to_char(salary, '$99,999'), 15, '=') AS Salary,
        LPAD(department_id, 3) AS DeptID
FROM employees
WHERE upper(job_id) LIKE 'SA%' OR upper(job_id) LIKE 'MK%' AND salary < (
            SELECT MAX(salary)
            FROM employees
            WHERE upper(job_id) NOT LIKE '%PRES' AND upper(job_id) NOT LIKE '%VP' AND upper(job_id) NOT LIKE '%MAN')
ORDER BY Employee ASC;       
         
/*8.	“Tricky One”
Display department name, city and number of different jobs in each department. If city is null, you should print Not Assigned Yet.
•	This column should have alias City.
•	Column that shows # of different jobs in a department should have the heading # of Jobs
•	You should display ONE row per output line by limiting the width of the City to 22 characters.
•	You need to show complete situation from the EMPLOYEE point of view, 
meaning include also employees who work for NO department (but do NOT display empty departments) ??
and from the CITY point of view meaning you need to display all cities without departments as well.??*/

SELECT 
        department_name AS departmentName,
        SUBSTR(NVL(city, 'Not Assigned Yet'), 0,25) AS City,
        NVL(COUNT(DISTINCT job_id), 0) "#OfJobs"
FROM employees e
INNER JOIN departments USING(department_id)
INNER JOIN locations USING(location_id)
GROUP BY department_name, city

UNION

SELECT
        to_char(NULL) AS departmentName,
        to_char(NULL) AS City,
        NVL(COUNT(job_id), 0) "#OfJobs"
FROM employees e
WHERE department_id IS NULL

UNION 

SELECT
        to_char(NULL) AS departmentName,
        city,
        0 AS "#OfJobs"
FROM locations
WHERE location_id NOT IN (
            SELECT location_id 
            FROM departments
            );
        

SELECT
    department_name,
    SUBSTR(NVL(city, 'Not Assigned Yet'), 0, 22) AS City,
    NVL(COUNT(DISTINCT job_id), 0) AS "#OfJobs"
FROM employees e
    LEFT OUTER JOIN departments d ON e.department_id = d.department_id
    LEFT OUTER JOIN locations l ON d.location_id = l.location_id
GROUP BY department_name, city
UNION
SELECT
    NULL,
    city,
    NVL(NULL, 0)
FROM locations
WHERE location_id NOT IN (
    SELECT location_id
    FROM departments
);




