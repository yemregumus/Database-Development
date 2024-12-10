-- ***********************************
-- DBS311 Week 5 - Lecture Demo
-- Clint MacDonald
-- Oct 4, 2022
-- Set Operators
-- ***********************************

/*
SETS and SEQUENCES

Let A = { 1,2,5,8,9 }
Let B = { 2,4,6,8,10 }

A U B = { 1,2,4,5,6,8,9,10 }
A ? B = { 2,8 }
A - B = { 1,5,9 }

in SQL we have the equivalent

UNION
UNION ALL
INTERSECT 
MINUS  (SUBTRACT in SQL Server)

*/

-- example
-- List all employees who's first name starts with 'S'
SELECT * FROM employees
WHERE UPPER(first_name) LIKE 'S%';
-- List all employees who's last name starts with 'H'
SELECT * FROM employees
WHERE UPPER(last_name) LIKE 'H%';
-- what if I want to show BOTH
SELECT * FROM employees
WHERE 
    UPPER(first_name) LIKE 'S%'
    OR UPPER(last_name) LIKE 'H%';
-- NOTE: Shelley only appears once
-- NOTE: pay attention to the ORDER in which the results are displayed
SELECT * FROM employees
WHERE 
    UPPER(first_name) LIKE 'T%'
    OR UPPER(last_name) LIKE 'H%';
-- Sorted in the same manor as they are in the database table itself.

-- we can use set operators
SELECT * FROM employees
WHERE UPPER(first_name) LIKE 'S%'
UNION
SELECT * FROM employees
WHERE UPPER(last_name) LIKE 'H%';
-- Note: Duplicates are removed
-- Note: The data is SORTED by PK

-- if we did NOT want duplicates removed.....
SELECT * FROM employees
WHERE UPPER(first_name) LIKE 'S%'
UNION ALL
SELECT * FROM employees
WHERE UPPER(last_name) LIKE 'H%';
-- UNION ALL does NOT eliminate duplicates and DOES NOT sort

-- let's understand sorting better
/*
Let A = { 1,7,3,9,8 }
Let B = { 4,2,6,8,1,5 }
A U B = { 1,7,3,9,8,4,2,6,8,1,5 } -> equivalent of UNION ALL
      = { 1,1,2,3,4,5,6,7,8,8,9 } -> Sorts first - by PK 
      = { 1,2,3,4,5,6,7,8,9 }     -> Eliminate duplicates


-- REAL WORLD EXAMPLE
  -- We are holding an event at Seneca and we want to invite everyone from the community
  -- do not send multiple invites to the same person
  
SELECT * FROM students
SELECT * FROM faculty
SELECT * FROM employees

-- some people belong to more than one of those groups
SELECT * FROM students
UNION
SELECT * FROM faculty
UNION
SELECT * FROM employees;
-- still does not work because of the * - some fields will be different in the 3 tables
SELECT studentID AS pID FROM students
UNION
SELECT facultyID FROM faculty
UNION
SELECT employeeID FROM employees;

-- LIST all people whom are in more than one category

SELECT 
    pID, 
    COUNT(pID)
FROM (
    SELECT studentID AS pID FROM students
    UNION ALL
    SELECT facultyID FROM faculty
    UNION ALL
    SELECT employeeID FROM employees
    )
GROUP BY pID
HAVING COUNT(pID) > 1;
*/
-- new example
-- back to the previous example
-- show those whom meet BOTH criteria only.

SELECT * FROM employees
WHERE UPPER(first_name) LIKE 'S%'
INTERSECT
SELECT * FROM employees
WHERE UPPER(last_name) LIKE 'H%';
-- is equivalent to
SELECT * FROM employees
WHERE 
    UPPER(first_name) LIKE 'S%'
    AND UPPER(last_name) LIKE 'H%';

/* 
back to faculty example
List people in ALL three categories

SELECT pID FROM  (
    SELECT studentID AS pID FROM students
    INTERSECT
    SELECT facultyID FROM faculty
    INTERSECT
    SELECT employeeID FROM employees
    );

-- multiple columns

SELECT pID, firstName, lastName FROM  (
    SELECT studentID AS pID, firstName, lName AS lastName AS pID FROM students
    INTERSECT
    SELECT facultyID, firstName, NULL FROM faculty
    INTERSECT
    SELECT employeeID, NULL, lastName FROM employees
    );
    
*/

-- MINUS
-- show all employees whose first name starts with 'S'
--   but their last name does NOT start with 'H'
SELECT * FROM employees
WHERE 
    UPPER(first_name) LIKE 'S%'
    AND NOT UPPER(last_name) LIKE 'H%';

-- using SET operators
SELECT * FROM employees
WHERE UPPER(first_name) LIKE 'S%'
MINUS
SELECT * FROM employees
WHERE UPPER(last_name) LIKE 'H%';
-- this allows you to remove records from the first set,
-- that match a second criteria


-- example
-- show those that match one criteria OR the other, but not both
SELECT * FROM employees
WHERE 
    UPPER(first_name) LIKE 'S%'
    OR UPPER(last_name) LIKE 'H%'
    AND
    NOT (
    UPPER(first_name) LIKE 'S%'
    AND UPPER(last_name) LIKE 'H%');
    -- even this still does not work
    
-- easier using set operators

    SELECT * FROM employees
    WHERE UPPER(first_name) LIKE 'S%'
    UNION
    SELECT * FROM employees
    WHERE UPPER(last_name) LIKE 'H%'
    
    MINUS
    (
    SELECT * FROM employees
    WHERE UPPER(first_name) LIKE 'S%'
    INTERSECT
    SELECT * FROM employees
    WHERE UPPER(last_name) LIKE 'H%'
    );
    
-- what about sorting

SELECT * FROM employees
WHERE UPPER(first_name) LIKE 'S%'
UNION ALL
SELECT * FROM employees
WHERE UPPER(last_name) LIKE 'H%'
ORDER BY last_name;
-- causes an error
SELECT first_name, last_name FROM employees
WHERE UPPER(first_name) LIKE 'S%'
UNION ALL
SELECT first_name, last_name FROM employees
WHERE UPPER(last_name) LIKE 'H%'

ORDER BY last_name;
-- ordering is NOT allowed in SET operators
-- so this order by is not in the SET operator, it is AFTER the set operator
SELECT * FROM
    (
    SELECT first_name, last_name FROM employees
    WHERE UPPER(first_name) LIKE 'S%'
    UNION ALL
    SELECT first_name, last_name FROM employees
    WHERE UPPER(last_name) LIKE 'H%'
    )
ORDER BY last_name;


-- set operators and aggregate functions

-- example
-- Question:  ????? List all players with duplicate names...  meaning they might be
--            duplicate player entries...

SELECT
    lastname,
    firstname,
    COUNT(playerID) AS numPlayers
FROM players
GROUP BY 
    last_name, 
    first_name
HAVING COUNT(playerID) > 1
ORDER BY numPlayers DESC;

-- with set operators you can do more
SELECT
    lastname,
    firstname,
    COUNT(playerID) AS numPlayers
FROM (
    SELECT * FROM players
    WHERE UPPER(lastname) LIKE 'S%'
    UNION ALL
    SELECT * FROM players
    WHERE UPPER(firstName) LIKE 'A%'
    )
GROUP BY 
    lastname, 
    firstname
HAVING COUNT(playerID) > 1
ORDER BY numPlayers;

-- Michael, micheal, Mikail, michale

