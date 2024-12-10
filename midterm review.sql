Midterm Review Sheet 
----------------------------
Style Guide
- MUST FOLLOW posted STYLE GUIDE
- Comment header OR ZERO
- file MUST execute 

Concepts
- the built-in "dual" table
- Aliases
- Calculated fields (include strings concat and numeric calculation)
- correct use of types in comparisions, calculations and ordering

ALL Parts of the SELECT statement (SELECT, FROM (JOIN), WHERE, ORDER BY, GROUP BY, HAVING)
ORDER OF EXECUTION

Logical Conditions 
-----------------------
AND/OR IN(), ANY(), ALL()
Using brackets for correct order of operations

Single Line Functions
-----------------------
NOTE: value often means field name
STRING FUNCTIONS
- to_char(value, format)
- upper, lower, initcap, 
- concat, substr, length, instr, 
- lpad, rpad, trim
- to_date(date string, format string)
- replace(value, string to replace, replacement string)

MATH FUNCTIONS
- round(value, # decimals), trunc(value, #decimals), mod(value)
- Ceil, Floor

DATE FUNCTIONS
- next_day(value, day name string), last_day, add_months, months_between, 
- round, trunc, sysdate
- to_date, Extract()

MISC FUNCTIONS
- NVL(value, replacement string), NVL2(value, if true, if false)

CALCULATED FIELDS
- using either single line functions, or mathematics to alter the field values
- MUST use an alias 

Aggregate Functions
-----------------------
- SUM
- COUNT
- AVG
- VARIANCE
- STDEV
- MIN
- MAX

Function Syntax
<function name>(<DISTINCT> <expression>)
------------------------------------------------------------------------
Example:
SELECT COUNT(DISTINCT department_id)
	FROM employees;
------------------------------------------------------------------------
Using NVL in Aggregate function

GROUP BY
Grouping by a single column
Grouping by multiple columns

Differentiating WHERE and HAVING

JOINS
-----------------------
INNER, LEFT OUTER, RIGHT OUTER, FULL OUTER JOINS
ON and USING statements

Nested Joins (more than 2 tables)

Joining the same table to itself or Joining to the same table more than once

Sub-Queries
-----------------------
Use of sub-queries in various parts of SELECT statement
- FROM
- WHERE
- SELECT

- Scalar, List and Tabular Queries

Nested sub-queries for multiple tables

SET OPERATORS
------------------------
UNION
UNION ALL
INTERSECT
MINUS

ORDER OF EXECUTION
------------------------------
FROM/JOINS
ON/USING
WHERE
GROUP BY 
HAVING
SELECT
ORDER BY