/*
				Assignment 6
                  Worth 10%
                Total Assignment is out of 100 marks  
				
                Complete all of the questions in this SQL file and submit the file for grading
                
                Open this file in SQL Workbench to complete all of the statements
                
                Make sure you run the CreateDB Script to create the sample database again so you have the correct data 
				
                You will need it to create the queries based on these tables
                
                There is a .jpg file which shows the tables in the database

*/


/*
 Question 1 (10 marks)
 
 a) Create two tables with the same numbers of columns and datatypes (mininum 3 columns in each table) (3 marks)
 
 b) Populate that table with data (3 marks)
 
 c) Create a SELECT statement for each table and UNION them together (4 marks)
 
*/
DROP DATABASE IF EXISTS Assignment6;
CREATE DATABASE Assignment6;
USE Assignment6;
-- creating two tables
CREATE TABLE nba_teams (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE nba_players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(50),
    position VARCHAR(50)
);


-- Populate first table with data
INSERT INTO nba_teams (team_id, team_name, city) VALUES (1, 'Los Angeles Lakers', 'Los Angeles');
INSERT INTO nba_teams (team_id, team_name, city) VALUES (2, 'Golden State Warriors', 'San Francisco');
INSERT INTO nba_teams (team_id, team_name, city) VALUES (3, 'Boston Celtics', 'Boston');

-- Populate second table with data
INSERT INTO nba_players (player_id, player_name, position) VALUES (1, 'LeBron James', 'Forward');
INSERT INTO nba_players (player_id, player_name, position) VALUES (2, 'Stephen Curry', 'Guard');
INSERT INTO nba_players (player_id, player_name, position) VALUES (3, 'Jayson Tatum', 'Forward');

-- SELECT STATEMENT WITH UNION
SELECT team_name, city FROM nba_teams
UNION
SELECT player_name, position FROM nba_players;



/*
 Question 2 (10 marks)
 
 Create a query that lists the department number, employee number, and salaries of all employees in department D11.  
 UNION the same information , but this time sum up all the salaries to create a one line summary entry for the D11 department (hint sum the salary).  Sort the list by Salary.
 
*/
-- Query to list department number, employee number, and salaries of all employees in department D11
SELECT department_number, employee_number, salary   -- Selecting department number, employee number, and salary
FROM employees                                      -- From the employees table
WHERE department_number = 'D11'                     -- Where the department number is 'D11'

UNION                                               -- Union operator combines the results of two queries

-- Query to sum up all salaries for department D11
SELECT 'D11' AS department_number,                 -- Selecting 'D11' as department number
       NULL AS employee_number,                     -- Setting employee number to NULL for summary entry
       SUM(salary) AS total_salary                 -- Summing up all salaries for department D11
FROM employees                                      -- From the employees table
WHERE department_number = 'D11'                     -- Where the department number is 'D11'
GROUP BY department_number                          -- Grouping the results by department number

ORDER BY salary;                                    -- Ordering the combined result set by salary



/*
 Question 3 (10 marks)
 
a )  Write a query that uses NATURAL JOIN TO connect the EMPLOYEE and EMPPROJACT table.   Include the Employee number , First and Last name, Salary, Salary increased by 3% and Project number      ( 3 marks )
 
b) Use INNER JOIN OR JOIN with the same query with USING statement   ( 3 marks )

 
c) Use INNER JOIN OR JOIN with the same query with joined columns (hint a = a )    ( 4 marks )
 
*/
-- a) query using NATURAL JOIN to connect EMPLOYEE and EMPPROJACT tables
SELECT e.employee_number, e.first_name, e.last_name, e.salary,
       e.salary * 1.03 AS increased_salary, p.project_number
FROM employee e                             -- Alias "e" for the employee table
NATURAL JOIN empprojact p;                  -- Using NATURAL JOIN to join the tables

-- b) query using INNER JOIN with USING statement to connect EMPLOYEE and EMPPROJACT tables
SELECT e.employee_number, e.first_name, e.last_name, e.salary,
       e.salary * 1.03 AS increased_salary, p.project_number
FROM employee e                             -- Alias "e" for the employee table
INNER JOIN empprojact p USING (employee_number); -- Using INNER JOIN with USING clause to join on common column

-- c) query using INNER JOIN with joined columns to connect EMPLOYEE and EMPPROJACT tables
SELECT e.employee_number, e.first_name, e.last_name, e.salary,
       e.salary * 1.03 AS increased_salary, p.project_number
FROM employee e                             -- Alias "e" for the employee table
INNER JOIN empprojact p ON e.employee_number = p.employee_number; -- Using INNER JOIN with explicit condition


/*
 Question 4 ( 25 marks )
 
  a) Create three tables.  Two of the tables will have PRIMARY KEYS (mininum 3 columns in each table) and the third table will have two columns that are the foreign keys to each of the PRIMARY KEYS (6 marks)
 
 b) Populate these table with data (5 marks)
 
 c) Create a SELECT statement using NATURAL JOINS to connect the three tables together (7 marks)
 
 d) Run the Reverse Engineer function in MySQL workbench on these tables and provide the .MWB file in your submission ( 7 marks )
 
*/
-- a)-- first table for NBA teams with a primary key
CREATE TABLE nba_teams2 (
    team_id INT PRIMARY KEY,
    team_name VARCHAR(50),
    city VARCHAR(50)
);

-- second table for NBA players with a primary key
CREATE TABLE nba_players2 (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(50),
    team_id INT,
    position VARCHAR(50),
    FOREIGN KEY (team_id) REFERENCES nba_teams(team_id)
);

-- third table to connect NBA players with their teams using foreign keys
CREATE TABLE player_team_relationship (
    relationship_id INT PRIMARY KEY,
    player_id INT,
    team_id INT,
    FOREIGN KEY (player_id) REFERENCES nba_players(player_id),
    FOREIGN KEY (team_id) REFERENCES nba_teams(team_id)
);

-- Populating nba_teams table
INSERT INTO nba_teams2 (team_id, team_name, city) VALUES 
(1, 'Los Angeles Lakers', 'Los Angeles'),
(2, 'Golden State Warriors', 'San Francisco'),
(3, 'Boston Celtics', 'Boston');

-- Populating nba_players table
INSERT INTO nba_players2 (player_id, player_name, team_id, position) VALUES 
(1, 'LeBron James', 1, 'Forward'),
(2, 'Stephen Curry', 2, 'Guard'),
(3, 'Jayson Tatum', 3, 'Forward');

-- Populating player_team_relationship table
INSERT INTO player_team_relationship (relationship_id, player_id, team_id) VALUES 
(1, 1, 1),
(2, 2, 2),
(3, 3, 3);

SELECT *
FROM nba_players2
NATURAL JOIN player_team_relationship
NATURAL JOIN nba_teams2;



/*
 Question 5 (15 marks)
 
  Write a query that uses INNER JOIN TO connect the EMPLOYEE, EMPPROJACT, PROJACT and PROJECT tables.   Include the Project number , Department number, Project start and end date and AC STAFF  
WHERE They belong to department D11 , Salary is more than or equal to 65 percent of $15,000 AND Salary is less than or equal to 130 percent of $40,000 

   
*/
-- Selecting necessary columns from the tables to meet the query requirements
SELECT 
    p.project_number,           -- Project number from the PROJECT table
    p.department_number,        -- Department number from the PROJECT table
    pr.start_date,              -- Project start date from the PROJACT table
    pr.end_date,                -- Project end date from the PROJACT table
    pr.ac_staff                 -- AC STAFF from the PROJACT table
FROM 
    EMPLOYEE e                  -- Alias "e" for the EMPLOYEE table
INNER JOIN 
    EMPPROJACT ep              -- Alias "ep" for the EMPPROJACT table
ON 
    e.employee_number = ep.employee_number  -- Join condition based on employee number
INNER JOIN 
    PROJACT pr                 -- Alias "pr" for the PROJACT table
ON 
    ep.project_number = pr.project_number   -- Join condition based on project number
INNER JOIN 
    PROJECT p                  -- Alias "p" for the PROJECT table
ON 
    pr.project_number = p.project_number    -- Join condition based on project number
WHERE 
    p.department_number = 'D11'             -- Filtering records for department D11
    AND e.salary >= 0.65 * 15000            -- Ensuring salary is at least 65% of $15,000
    AND e.salary <= 1.30 * 40000;           -- Ensuring salary is at most 130% of $40,000

/*
 Question 6 (15 marks)
 
 Create a query that lists empno, projno, emptime, emendate.  Left join the project to the empprojact table using projno and left join the act table using actno and then right join employee table using empno. 
 Where projno is AD3113 and empno is 000270 and emptime is greater than 0.5
 
 
*/
-- Selecting necessary columns: empno, projno, emptime, emendate
SELECT 
    e.empno,           -- Employee number
    ep.projno,         -- Project number
    ep.emptime,        -- Employee time
    ep.emendate        -- Employee end date
FROM 
    employee e          -- Alias "e" for the employee table
RIGHT JOIN 
    empprojact ep       -- Alias "ep" for the empprojact table
ON 
    e.empno = ep.empno  -- Joining employee and empprojact tables on employee number
LEFT JOIN 
    project p           -- Alias "p" for the project table
ON 
    ep.projno = p.projno   -- Joining empprojact and project tables on project number
LEFT JOIN 
    act a               -- Alias "a" for the act table
ON 
    ep.actno = a.actno    -- Joining empprojact and act tables on activity number
WHERE 
    ep.projno = 'AD3113'   -- Filtering records where project number is 'AD3113'
    AND e.empno = '000270' -- Filtering records where employee number is '000270'
    AND ep.emptime > 0.5;  -- Filtering records where employee time is greater than 0.5


/*
 Question 7 (15 marks)
 
  Describe all of the relationships between the tables in the attached image file TableRelationships.jpg
  
  a) describe all the foreign key and primary keys, either by detailing them 1 by 1 or define the CREATE table statements for all the tables (10 marks)
  b) describe the relationship between each table ( 1..1 (exactly one match)  1..n (one or more matches)) (5 marks)
  
 
 -- a)
ContactType Table:
Primary Key: id

Person Table:
Primary Key: id

Contact Table:
Foreign Key: pid (references id in Person table)
Foreign Key: ctid (references id in ContactType table)

ProjectPerson Table:
Foreign Key: prid (references id in Project table)
Foreign Key: pid (references id in Person table)
Foreign Key: rid (references id in Role table)

Role Table:
Primary Key: id

Project Table:
Primary Key: id
 
b)relationships between each table:

ContactType - Contact: 1..n (one ContactType can have one or more Contacts)
Person - Contact: 1..n (one Person can have one or more Contacts)
Person - ProjectPerson: 1..n (one Person can be associated with one or more ProjectPersons)
Role - ProjectPerson: 1..n (one Role can be associated with one or more ProjectPersons)
Project - ProjectPerson: 1..n (one Project can have one or more ProjectPersons) 
 


 
 
 