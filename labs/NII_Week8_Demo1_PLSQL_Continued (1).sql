-- -----------------------
-- DBS311 - Week 8 NII
-- PL/SQL Continued
-- Nov 1, 2022
-- Clint MacDonald
-- -----------------------

-- Quick of review of week 6
SET SERVEROUTPUT ON;

-- parameters with same name as the field
CREATE OR REPLACE PROCEDURE spInsertPeople2 (
    firstName VARCHAR2,
    lastName VARCHAR2,
    DOB date,
    isActive NUMERIC,
    favNum INT
) AS
BEGIN
    INSERT INTO xPeople p (
        p.firstName, p.lastName, p.dob, p.isactive, p.favNum)
    VALUES (firstName, lastName, DOB, isActive, favNum);
    DBMS_OUTPUT.PUT_LINE('Insert Successful!');
EXCEPTION
    WHEN OTHERS
        THEN
            DBMS_OUTPUT.PUT_LINE('An error occured!');
END spInsertPeople2;
-- execute it
BEGIN
    spInsertPeople2('Jim','Smith',sysdate,1,4);
END;

-- more on Parameters in SPs
CREATE OR REPLACE PROCEDURE spInsertPeople3 (
    firstName VARCHAR2,
    lastName VARCHAR2,
    DOB date,
    isActive IN NUMERIC,
    favNum IN INT,
    peepID OUT INT
) AS
BEGIN
    INSERT INTO xPeople p (
        p.firstName, p.lastName, p.dob, p.isactive, p.favNum)
    VALUES (firstName, lastName, DOB, isActive, favNum);
    
    SELECT pID INTO peepID
    FROM xPeople
    WHERE rownum = 1
    ORDER BY pID DESC;
    
    DBMS_OUTPUT.PUT_LINE('Insert Successful!');
EXCEPTION
    WHEN OTHERS
        THEN
            DBMS_OUTPUT.PUT_LINE('An error occured!');
END spInsertPeople3;
-- execute it
DECLARE 
    NewPeepID INT := 0;
BEGIN
    spInsertPeople3('Ruth','Marks',sysdate,1,4,NewPeepID);
    DBMS_OUTPUT.PUT_LINE('New PeepID: ' || NewPeepID);
END;

-- multiple output parameters
CREATE OR REPLACE PROCEDURE spInsertPeople4 (
    firstName VARCHAR2,
    lastName VARCHAR2,
    DOB date,
    isActive IN NUMERIC,
    favNum IN INT,
    peepID OUT INT,
    NumPeeps OUT INT
) AS
BEGIN
    INSERT INTO xPeople p (
        p.firstName, p.lastName, p.dob, p.isactive, p.favNum)
    VALUES (firstName, lastName, DOB, isActive, favNum);
    
    SELECT pID INTO peepID
    FROM xPeople
    WHERE rownum = 1
    ORDER BY pID DESC;
    
    SELECT COUNT(pID) INTO NumPeeps FROM xPeople;
    
    DBMS_OUTPUT.PUT_LINE('Insert Successful!');
EXCEPTION
    WHEN OTHERS
        THEN
            DBMS_OUTPUT.PUT_LINE('An error occured!');
END spInsertPeople4;

-- execute it
DECLARE
    NewPeepID INT := 0;
    NumPeeps INT := 0;
BEGIN
    spInsertPeople4('Sarah','Jones',sysdate,1,4,NewPeepID,NumPeeps);
    DBMS_OUTPUT.PUT_LINE('New PeepID: ' || NewPeepID);
    DBMS_OUTPUT.PUT_LINE('Number of Rows: ' || NumPeeps);
END;

-- IN OUT parameters
CREATE OR REPLACE PROCEDURE spNewSalary ( salary IN OUT FLOAT) AS
BEGIN
    salary := salary * 1.2;
END spNewSalary;
-- execute it
DECLARE
    mySalary FLOAT := ROUND(74500.43/12,2);
BEGIN
    DBMS_OUTPUT.PUT_LINE('The OLD salary: $' || mySalary);
    spNewSalary(mySalary);
    DBMS_OUTPUT.PUT_LINE('The NEW salary: $' || mySalary);
END;

-- --------------------------
-- CONDITIONAL STATEMENTS
-- and explicit cursors
-- --------------------------

-- SP to delete people and return the results of the deletion
CREATE OR REPLACE PROCEDURE spDelPeep( peepID xPeople.pid%type ) AS
-- %type gets the data type of the left side
BEGIN
    DELETE FROM xPeople WHERE pID = peepID;
    
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('pID ' || peepID || ' did not exist');
    ELSIF SQL%ROWCOUNT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('pID ' || peepID || ' deleted successfully');
    ELSE
        DBMS_OUTPUT.PUT_LINE('MULTIPLE ROWS DELETED - WARNING');
    END IF;
    
EXCEPTION
    WHEN OTHERS
        THEN
            DBMS_OUTPUT.PUT_LINE('An error occured!');
END spDelPeep;

-- execute it:
BEGIN
    spDelPeep(200);
END;
BEGIN
    spDelPeep(26);
END;

-- -------------------------------
-- LOOPS
--      BASIC Loops
--      WHILE Loop
--      FOR Loop
--      Cursor FOR Loop
-- -------------------------------

-- example of BASIC LOOP
-- putput the powers of two (binary bits and bytes)

DECLARE 
    curNum INT := 0;
    maxNum INT := 31;
BEGIN
    DBMS_OUTPUT.PUT_LINE('---------------------');
    LOOP
        DBMS_OUTPUT.PUT_LINE('Power: ' || curNum || ' - ' || POWER(2,curNum));
        curNum := curNum + 1;
        -- IF curNum > maxNum THEN
        --    EXIT;
        -- END IF;
        EXIT WHEN curNum > maxNum;
    END LOOP; -- exit strategy MUST be present
    DBMS_OUTPUT.PUT_LINE('---------------------');
END;

-- NESTED LOOPING
DECLARE 
    r NUMBER := 0;
    c NUMBER := 0;
    max# NUMBER := &Num;
    rowString VARCHAR2(255) := '';
BEGIN
    DBMS_OUTPUT.PUT_LINE('---------------------');
    LOOP -- ROWS
        rowString := LPAD(r, 3, ' ') || ' - ';
        LOOP -- COLUMNS
            rowString := rowString || LPAD(r*c, 4, ' ');
            c:=c+1;
            EXIT WHEN c > max#; -- exit strategy
        END LOOP;
        c:=0;
        r:=r+1;
        DBMS_OUTPUT.PUT_LINE(rowString);
        EXIT WHEN r > max#; -- exit strategy
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('---------------------');
END;

-- CONTINUE and CONTINUE WHEN
DECLARE
    Counter INT := 0;
    eNum INT := 10;
BEGIN
    DBMS_OUTPUT.PUT_LINE('----------------------');
    LOOP
        Counter := Counter + 1;
        CONTINUE WHEN Counter = 3;
        DBMS_OUTPUT.PUT_LINE('- '  || Counter || ' - ');
        EXIT WHEN Counter >= eNum;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('----------------------');
END;

-- FOR LOOP
BEGIN
    FOR i IN 0..10 LOOP  -- inclusive
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
-- in reverse

BEGIN
    FOR i IN REVERSE 0..10 LOOP  -- inclusive
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;
    
-- WHILE LOOP
DECLARE
    i INT := 0;
    max# INT := 10;
BEGIN
    WHILE i <= Max# LOOP
       DBMS_OUTPUT.PUT_LINE('- ' || i || ' -');
       i := i + 1; 
    END LOOP;
END;
    
-- EXIT WHEN and CONTINUE WHEN also work in FOR and WHILE loops
    
    
