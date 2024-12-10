

-- Purpose: Lab 6 DBS301
-- ***********************

SET SERVEROUTPUT ON;

--Q1 ANSWER
--------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fncCalcFactorial(num IN INT) 
    RETURN INT
    AS
    f INT;

BEGIN
    f:=1;
        FOR i IN 1..num LOOP
          f:=f*i;
        END LOOP;
    RETURN f;
END fncCalcFactorial;

--Q1 EXECUTION
--------------------------------------------------------------------
DECLARE
num INT:=4;
num2 INT:=5;
num3 INT:=6;
res INT;

BEGIN    
  
        res:=fncCalcFactorial(num);
    DBMS_OUTPUT.PUT_LINE('Factorial of number ' || num || ' is: ' || res);
    
   
        res:=fncCalcFactorial(num2);
    DBMS_OUTPUT.PUT_LINE('Factorial of number ' || num2 || ' is: ' || res);
 
        res:=fncCalcFactorial(num3);
    DBMS_OUTPUT.PUT_LINE('Factorial of number ' || num3 || ' is: ' || res);
END;

--Q2 ANSWER
--------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE spCalcCurrentSalary (
    empID IN employees.employee_id%type) AS
    
    firstName employees.first_name%type;
    lastName employees.last_name%type;
    hireDate employees.hire_date%type;
    empSalary NUMBER;
    yearsWorked NUMBER;
    vacWeeks NUMBER;
    vYear NUMBER;
    sixWeek NUMBER;
    totalSalary NUMBER;
    nEmp NUMBER;
    empExp EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO nEmp
    FROM employees 
    WHERE employee_id = empID;
    
    IF nEmp > 0 THEN
    SELECT 
        first_name, 
        last_name, 
        hire_date, 
        salary,
        TRUNC(months_between(sysdate, hire_date) /12) 
    INTO firstName, lastName, hireDate, empSalary, yearsWorked
    FROM employees
    WHERE employee_id = empID;
    
    vYear := 0;
    totalSalary := empSalary ;
    vacWeeks := 0;
    sixWeek := 0;
    LOOP 
        IF vYear > yearsWorked THEN
            EXIT;
        ELSE
            IF yearsWorked < 0 THEN
            totalSalary := empSalary;
            EXIT;
                ELSE
                vYear := vYear +1;
                totalSalary := totalSalary + (totalSalary * 0.04);
                vacWeeks := vacWeeks + 2;
        IF vYear > 3 THEN
            sixWeek := sixWeek + 1;
         IF sixWeek > 6 THEN
            sixWeek := 6;
            END IF;
        END IF;
    END IF;
END IF;           
    END LOOP;
DBMS_OUTPUT.PUT_LINE( 'First Name       : ' || firstName );
DBMS_OUTPUT.PUT_LINE( 'Last Name        : ' || lastName );
DBMS_OUTPUT.PUT_LINE( 'Hire Date        : ' || to_char(hireDate,  'FMMon. DD, YYYY'));
DBMS_OUTPUT.PUT_LINE( 'Salary           : ' || trim(to_char(totalSalary, '$999,999,999,999' )));
DBMS_OUTPUT.PUT_LINE( 'Vacation Weeks   : ' || sixWeek  );
ELSE
-- -- raise exception for Employee_id not found
RAISE empExp ;
END IF;
-- handling exception part
EXCEPTION
  WHEN empExp THEN
     DBMS_OUTPUT.PUT_LINE('Employee_id not found!');
  WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE('Error!' );
END spCalcCurrentSalary;
               
--Q2 execution                       
BEGIN
spCalcCurrentSalary(178);
END;

--Q3 answer

CREATE OR REPLACE PROCEDURE spDepartmentsReport AS
deptID departments.department_id%type;
deptName departments.department_name%type;
city locations.city%type;
numEmp INT := 0;
CURSOR c IS
SELECT
        d.department_id, d.department_name, l.city, COUNT(e.employee_id) AS NumEmp 
FROM departments d
JOIN locations l ON l.location_id = d.location_id
LEFT OUTER JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name,  l.city;

BEGIN
DBMS_OUTPUT.PUT_LINE(LPAD('DeptID', 6) ||'  	 '|| RPAD('Department', 15) || RPAD('City', 20) ||LPAD('NumEmps', 10));
OPEN c;
    LOOP
    FETCH c INTO deptID, deptName,city,numEmp;
    EXIT WHEN c%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(
                LPAD(deptID, 6, ' ') || '       ' || RPAD(deptName, 15, ' ') || RPAD(city, 20, ' ') || LPAD(numEmp, 10, ' '));
        END LOOP;
    CLOSE c;
EXCEPTION
WHEN OTHERS
  THEN 
      DBMS_OUTPUT.PUT_LINE ('Error!');

END spDepartmentsReport ;

--Q3 execution
BEGIN
    spDepartmentsReport;
END;

--Q4 answer

--Part a

CREATE OR REPLACE FUNCTION spDetermineWinningTeam (game_id INT) 
RETURN INT IS 
scoreHome  INT;
scoreAway INT;
winnerTeamID INT;
homeT INT;
visitT INT;
played INT;
BEGIN
-- Get the scores of the home and away teams 
SELECT homescore, visitscore, hometeam, visitteam, isplayed INTO scoreHome, scoreAway, homeT, visitT, played
FROM games 
WHERE gameid = game_id;

-- Determine the winning team 
    IF (scoreHome > scoreAway) THEN
        winnerTeamID := homeT;
    ELSIF (scoreHome < scoreAway) THEN
        winnerTeamID := visitT;
    ELSIF(scoreHome = scoreAway) THEN
        winnerTeamID := 0;
    ELSIF (played < 1) THEN
        winnerTeamID := -1;
    END IF;
-- Return the winning teamID 
RETURN winnerTeamID;
END spDetermineWinningTeam;

--Part b

SELECT 
    TheTeamID AS Teams,
    COUNT(Wins) AS TotalWins
FROM(
SELECT
    gameid AS Game,
    hometeam AS TheTeamID,
    COUNT(*) AS Wins
    FROM games
    WHERE isPlayed = 1 AND spDetermineWinningTeam(gameid) = hometeam
    GROUP BY hometeam,gameid
    
    UNION ALL
    
    SELECT
    gameid AS Game,
    visitteam AS TheTeamID,
    COUNT(*) AS Wins
    FROM games
    WHERE isPlayed = 1 AND spDetermineWinningTeam(gameid) = visitteam
    GROUP BY visitteam,gameid
) 
WHERE spDetermineWinningTeam(Game) = TheTeamID
GROUP BY TheTeamID
ORDER BY 1;


