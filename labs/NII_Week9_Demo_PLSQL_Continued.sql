-- ---------------------------------
-- DBS311 - Week 9
-- Clint MacDonald
-- Nov. 8, 2022
-- PL/SQL Continued - Cursers and UDFs
-- ---------------------------------

SET SERVEROUTPUT ON;

-- CURSORS
    -- Implicit and Explicit
    -- IMPLICIT
        -- already shown
        -- SQL%ROWCOUNT is an example
            -- returns the # of rows effected by the previous SQL statement
        -- SQL%FOUND -- boolean, if last statement effected at least one row
        -- SQL%NOTFOUND -- boolean, opposite of FOUND
        -- plus more......

    -- EXPLICIT CURSORS
        -- analogy would be an array of javascript objects
        -- ability to iterate through multiple rows of data

-- example
-- output all employees with the letter M in their job title
DECLARE
    lName employees.last_name%TYPE;
    fName employees.first_name%TYPE;
    jTitle employees.job_id%TYPE;
    CURSOR c IS
        SELECT last_name, first_name, job_id
        FROM employees
        WHERE UPPER(job_id) LIKE '%M%'
        ORDER BY last_name, first_name;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('-',40,'-'));
    OPEN c; -- opens and executes the cursor
        LOOP
            FETCH c INTO lName, fName, jTitle; -- grab the next row
            EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(
                RPAD(fName, 15, ' ') 
                || RPAD(lName, 15, ' ')
                || jTitle);
        END LOOP;
    CLOSE c;
    DBMS_OUTPUT.PUT_LINE(RPAD('-',40,'-'));
END;

-- parameters
-- the cursor itself can receive parameters

-- example: return all players with the given initials
DECLARE
    player players%ROWTYPE;
    CURSOR pc ( fLetter CHAR, lLetter CHAR ) IS
        SELECT * FROM players
        WHERE UPPER(firstname) LIKE UPPER(fLetter) || '%'
            AND UPPER(lastname) LIKE UPPER(lLetter) || '%'
        ORDER BY lastname, firstname;
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('-',40,'-'));
    OPEN pc('C','M');
    LOOP
        FETCH pc INTO player;
        EXIT WHEN pc%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(
                RPAD(player.firstname, 15, ' ') 
                || RPAD(player.lastname, 15, ' ')
                || player.regNumber);
    END LOOP;
    CLOSE pc;
    DBMS_OUTPUT.PUT_LINE(RPAD('-',40,'-'));
END;

-- cursors with FOR loops
DECLARE 
    CURSOR pc ( fLetter CHAR, lLetter CHAR ) IS
        SELECT * FROM players
        WHERE UPPER(firstname) LIKE UPPER(fLetter) || '%'
            AND UPPER(lastname) LIKE UPPER(lLetter) || '%'
        ORDER BY lastname, firstname; 
BEGIN
    DBMS_OUTPUT.PUT_LINE(RPAD('-',40,'-'));
    FOR someVarName IN pc('C','M') LOOP
        DBMS_OUTPUT.PUT_LINE(
                RPAD(someVarName.firstname, 15, ' ') 
                || RPAD(someVarName.lastname, 15, ' ')
                || someVarName.regNumber);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(RPAD('-',40,'-'));
END;

-- -------------------------------
-- UDFs - User Defined Functions
-- -------------------------------
CREATE OR REPLACE FUNCTION fncFindHigherNumber(
    num1 INT, num2 INT ) RETURN INT IS
BEGIN
    IF num2 > num1 THEN
        RETURN num2;
    ELSE
        RETURN num1;
    END IF;
END fncFindHigherNumber;

-- use the function
BEGIN
    DBMS_OUTPUT.PUT_LINE ( fncFindHigherNumber(12, 45) );
    DBMS_OUTPUT.PUT_LINE ( fncFindHigherNumber(36, 15) );
    DBMS_OUTPUT.PUT_LINE ( fncFindHigherNumber(10, 10) );
    DBMS_OUTPUT.PUT_LINE ( fncFindHigherNumber(09, 10) );
END;

-- function using SQL
SELECT
    gameID,
    homescore,
    visitscore,
    fncFindHigherNumber(homescore, visitscore) AS higherScore
FROM games
ORDER BY gameID;

-- new example
-- UDFs with SQL
CREATE OR REPLACE FUNCTION fncMostGoalsInAGame
    RETURN NUMBER IS
    
    maxG NUMBER := 0;
BEGIN
    SELECT MAX(numGoals) INTO maxG
    FROM goalscorers;
    
    RETURN maxG;
END fncMostGoalsInAGame;

-- use it
BEGIN
    DBMS_OUTPUT.PUT_LINE('The most goals scored was: ' 
        || fncMostGoalsInAGame() );
END;
-- use in SQL
SELECT 
    p.playerID, firstname, lastname, numGoals,
    fncMostGoalsInAGame() - numGoals AS goalDiff
FROM goalscorers gs
    JOIN players p ON gs.playerID = p.playerID
ORDER BY numGoals DESC;

-- replacing the query from first example of Week 4 demo file
SELECT
    firstname, lastname, regNumber
FROM players
WHERE playerID IN (
    SELECT playerID FROM goalScorers
    WHERE numGoals = fncMostGoalsInAGame()
    );

-- using function to do repetitive tasks

-- string concatenate names
CREATE OR REPLACE FUNCTION fncConcateNames(
    name1 VARCHAR, name2 VARCHAR)
    RETURN VARCHAR IS
    
    -- retVal VARCHAR(100) := '';
BEGIN
    -- SELECT name1 || ' ' || name2 INTO retVal FROM dual;
    -- RETURN retVal;
    
    RETURN INITCAP(name1) || ' ' || INITCAP(name2);
END fncConcateNames;

BEGIN
    DBMS_OUTPUT.PUT_LINE('My name is: ' 
        || fncConcateNames('Clint','MacDonald'));
END;

-- sql example
SELECT 
    firstname, lastname, fncConcateNames(firstname, lastname) AS fn
FROM players
ORDER BY lastname, firstname;

-- --------------
-- functions with SQL Data
-- --------------
CREATE OR REPLACE FUNCTION fncGetPlayerData(pID INT)
    RETURN players%ROWTYPE IS
    
    pData players%ROWTYPE;
BEGIN
    SELECT * INTO pData
    FROM players
    WHERE playerID = pID;

    RETURN pData;
END fncGetPlayerData;

-- use this
DECLARE 
    playData players%ROWTYPE;
BEGIN
    playData := fncGetPlayerData(1332);
    DBMS_OUTPUT.PUT_LINE(
        'Player: ' || playData.firstname
            || ' ' || playData.lastName 
            || ' - ' || playData.regNumber);
    DBMS_OUTPUT.PUT_LINE(
        'Player: ' 
            || fncConcateNames(playData.firstname, playData.lastName) 
            || ' - ' || playData.regNumber);
END;









