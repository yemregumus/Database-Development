
-- Purpose: Lab 5 DBS301

-- ***********************

SET SERVEROUTPUT ON;
--1.	Write a store procedure that gets an integer number and prints = The number is even. 
--If a number is divisible by 2. Otherwise, it prints=The number is odd.

--Q1 answer

CREATE OR REPLACE PROCEDURE spEvenOdd ( num IN INT ) AS
BEGIN
    IF MOD(num, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The number ' || num || ' is even.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('The number ' || num || ' is odd.');
    END IF;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('An Error has occured!');
END spEvenOdd;
--------------------------------------------------------------------------------------
-- TRY Q1
BEGIN
        spEvenOdd(9);
        spEvenOdd(36);
END;
--------------------------------------------------------------------------------------
/*2.	Create a stored procedure named find_employee. This procedure gets an employee number and prints the following employee information:
First name 
Last name 
Email
Phone 	
Hire date 
Job title

The procedure gets a value as the employee ID of type NUMBER.
See the following example for employee ID 107: 

First name: Summer
Last name: Payn
Email: summer.payne@example.com
Phone: 515.123.8181
Hire date: 07-JUN-16
Job title: Public Accountant

The procedure display a proper error message if any error accours.*/

CREATE OR REPLACE PROCEDURE spFind_Employee ( empID IN number ) AS

firstName varchar(50);
lastName varchar(50);
email varchar(50);
phone varchar(50);
hireDate date;
jobTitle varchar(255);

BEGIN
            SELECT first_name, last_name, email, phone_number, hire_date, job_id
                    INTO firstName, lastName,email,phone,hireDate, jobTitle        
            FROM employees
            WHERE employee_id LIKE empID;
            
            DBMS_OUTPUT.PUT_LINE('-------------------');
            DBMS_OUTPUT.PUT_LINE('First Name    : ' || firstName);
            DBMS_OUTPUT.PUT_LINE('Last Name     : ' || lastName);
            DBMS_OUTPUT.PUT_LINE('Email         : ' || email);
            DBMS_OUTPUT.PUT_LINE('Phone         : ' || phone);
            DBMS_OUTPUT.PUT_LINE('Hire Date     : ' || TO_CHAR(hireDate, 'dd-mon-yy'));
            DBMS_OUTPUT.PUT_LINE('Job Title     : ' || jobTitle);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Returned too many rows.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No data found.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('An Unknown Error Occured!');
END spFind_Employee;


BEGIN
        spFind_Employee(103);
END;

/*3.	In a unionized company, the collective bargaining agreement often contains a requirement for staff to 
receive a given percentage salary increase an on annual basis.  These salary increases are different for different departments. 
For example, the company must give all employees who work in the marketing department an annual 2.5% raise.  

Write a procedure named update_salary_by_dept to update the salaries of all employees in a given department 
and the given percentage increase to be added to the current salary if the salary is greater than 0. 
The procedure shows the number of updated rows if the update is successful.
The procedure gets two input parameters and sends one back out again with the number of rows updated.  
-	When defining the first parameter, set the data type to the same data type as the associated field using the %type attribute.
-	Make sure your solution handles any possible errors with appropriate responses.
Additionally, write the code to execute the procedure.
*/
CREATE OR REPLACE PROCEDURE spUpdate_Salary_By_Dept (
                salaryInc IN employees.salary%type, 
                departmentID IN employees.department_id%type) AS
BEGIN
            UPDATE employees
            SET salary = salary * (1 + salaryInc / 100)
            WHERE department_id LIKE departmentID;
            
        IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE ('Records not found, records not updated.');
        ELSE DBMS_OUTPUT.PUT_LINE (SQL%ROWCOUNT || ' records updated.');
        END IF;
EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unexpected error occured!');

END spUpdate_Salary_By_Dept;

--Executing it

BEGIN
        spUpdate_Salary_By_Dept(2.5, 60);
END;

/*4.	In an attempt to equalize salaries over time, every year, the company increase the monthly salary of all employees 
who make less than the average salary by 1% (salary *1.01).  

Write a stored procedure named spUpdateSalary_UnderAvg. 
This procedure will not have any parameters. You need to find the average salary of all employees and store it into a variable of the same type. 
- If the average salary is less than or equal to $9000, update the employee`s salary by 2% if the salary of the employee is less than the calculated average. 
- If the average salary is greater than $9000, update employees’ salary by 1% if the salary of the employee is less than the calculated average. 

The query displays an error message if any error occurs. Otherwise, it displays the number of updated rows.
*/
CREATE OR REPLACE PROCEDURE spUpdateSalary_UnderAvg AS

AvgSalary employees.salary%type;

BEGIN
            SELECT AVG(salary) INTO AvgSalary FROM employees;
            
            IF AvgSalary <= 9000.0 
            THEN 
                    UPDATE employees 
                    SET salary  = salary * 1.02 
                    WHERE salary < avgSalary;
            ELSE
                    UPDATE employees 
                    SET salary  = salary * 1.01 
                    WHERE salary < avgSalary;
            END IF;
            
        IF SQL%ROWCOUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE (SQL%ROWCOUNT || ' records updated.');
        ELSE 
            DBMS_OUTPUT.PUT_LINE ('No records updated.');
        END IF;
        
EXCEPTION
	WHEN 
        TOO_MANY_ROWS 
    THEN 
        DBMS_OUTPUT.PUT_LINE('Too many rows');
        
	WHEN 
        NO_DATA_FOUND 
    THEN 
        DBMS_OUTPUT.PUT_LINE('No data found');
    
    WHEN OTHERS 
    THEN 
        DBMS_OUTPUT.PUT_LINE('Unexpected error occured!');
END spUpdateSalary_UnderAvg;

-- execution
BEGIN
        spUpdateSalary_UnderAvg();
END;

/*5.	The company needs a report that shows three categories of employees based their salaries. 
The company needs to know if the salary is low, fair, or high. Let’s assume that
?	If the salary is less than 
o	(avg salary – min salary) / 2
The salary is low.
?	If the salary is greater than 
o	(max salary – avg salary) / 2
The salary is high.
?	If the salary is between 
o	(avg salary - min salary) / 2
o	and
o	(max salary - avg salary) / 2
o	the end values included
The salary is fair.
Write a procedure named spSalaryReport to show the number of employees in each price category:
The following is a sample output of the procedure if no error occurs:
Low: 4
Fair: 12
High: 6  
The values in the above examples are just random values and may not match the real numbers in your result.
Make sure you choose a proper data type for each variable. You may need to define more variables based on your solution.
*/
CREATE OR REPLACE PROCEDURE spSalaryReport AS

maxSal NUMBER;
minSal NUMBER;
avgSal NUMBER;
cntLow INT := 0;
cntFair INT := 0;
cntHigh INT := 0;

BEGIN
        SELECT max(salary), min(salary), avg(salary) 
        INTO maxSal, minSal, avgSal
        FROM employees;
            
        SELECT COUNT(employee_id) INTO cntLow
        FROM employees --(avg salary – min salary) / 2
        WHERE salary < (avgSal - minSal) / 2;
        
        SELECT COUNT(employee_id) INTO cntHigh
        FROM employees --(max salary – avg salary) / 2
        WHERE salary > (maxSal - avgSal) / 2;
        
        SELECT COUNT(employee_id) INTO cntFair
        FROM employees --(avg salary - min salary) / 2 and (max salary - avg salary) / 2
        WHERE salary BETWEEN (avgSal - minSal) / 2 AND (maxSal - avgSal) / 2;
        
        DBMS_OUTPUT.PUT_LINE ('Low  : ' || cntLow);
        DBMS_OUTPUT.PUT_LINE ('Fair : ' || cntFair);
        DBMS_OUTPUT.PUT_LINE ('High : ' || cntHigh);  
EXCEPTION
        WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE('Returned too many rows.');
        WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No data found.');
        WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Unexpected error occured!');
 
END spSalaryReport;

-- execution
BEGIN
        spSalaryReport();
END;