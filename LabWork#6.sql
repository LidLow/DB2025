/*
 A joined table is a table derived from two other tables according to the rules of the particular join
type. JOINs allow you to combine data from multiple tables based on related columns.

Types of JOINs
1. CROSS JOIN: Produces a Cartesian product of two tables (all possible combinations)
2. INNER JOIN: Returns only matching rows from both tables
3. LEFT JOIN (LEFT OUTER JOIN): Returns all rows from the left table and matching rows from the right table
4. RIGHT JOIN (RIGHT OUTER JOIN): Returns all rows from the right table and matching rows from the left table
5. FULL JOIN (FULL OUTER JOIN): Returns all rows from both tables, with NULLs where there's no match

Syntax Variations
• ON clause: Specifies the join condition
• USING clause: Simplified syntax when join columns have the same name
• NATURAL JOIN: Automatically joins on all columns with the same names
 */



--Part 1: Database Setup
--      Step 1.1: Create Sample Tables
CREATE TABLE employees (
    emp_id          INT PRIMARY KEY,
    emp_name        VARCHAR(50),
    dept_id         INT,
    salary          DECIMAL(10, 2)
);

CREATE TABLE departments (
    dept_id         INT PRIMARY KEY,
    dept_name       VARCHAR(50),
    location        VARCHAR(50)
);

CREATE TABLE projects (
    project_id      INT PRIMARY KEY,
    project_name    VARCHAR(50),
    dept_id         INT,
    budget          DECIMAL(10, 2)
);



--      Step 1.2: Insert Sample Data
INSERT INTO employees (emp_id, emp_name, dept_id, salary)
    VALUES
        (1, 'John Smith', 101, 50000),
        (2, 'Jane Doe', 102, 60000),
        (3, 'Mike Johnson', 101, 55000),
        (4, 'Sarah Williams', 103, 65000),
        (5, 'Tom Brown', NULL, 45000);

INSERT INTO departments (dept_id, dept_name, location)
    VALUES
        (101, 'IT', 'Building A'),
        (102, 'HR', 'Building B'),
        (103, 'Finance', 'Building C'),
        (104, 'Marketing', 'Building D');

INSERT INTO projects (project_id, project_name, dept_id, budget)
    VALUES
        (1, 'Website Redesign', 101, 100000),
        (2, 'Employee Training', 102, 50000),
        (3, 'Budget Analysis', 103, 75000),
        (4, 'Cloud Migration', 101, 150000),
        (5, 'AI Research', NULL, 200000);



-- Part 2: CROSS JOIN Exercises
--       2.1: Basic CROSS JOIN
SELECT e.emp_name, d.dept_name
    FROM employees e
    CROSS JOIN departments d; --40

--      2.2: Alternative CROSS JOIN Syntax
SELECT emp_name, dept_name
    FROM employees, departments;

SELECT emp_name, dept_name
    FROM employees
    INNER JOIN departments ON TRUE;

--      2.3: Practical CROSS JOIN
SELECT *
    FROM employees
    CROSS JOIN departments;



-- Part 3: INNER JOIN Exercises
--       3.1: Basic INNER JOIN with ON
SELECT emp_name, dept_name, location
    FROM employees
    INNER JOIN departments ON employees.dept_id = departments.dept_id;

--      Exercise 3.2: INNER JOIN with USING
SELECT emp_name, dept_name, location
    FROM employees
    INNER JOIN departments USING (dept_id);

--      Exercise 3.3: NATURAL INNER JOIN
SELECT emp_name, dept_name, location
    FROM employees
    NATURAL INNER JOIN departments;

--      Exercise 3.4: Multi-table INNER JOIN
SELECT emp.emp_name, dept.dept_name, proj.project_name
    FROM employees emp
    INNER JOIN departments dept
        ON emp.dept_id = dept.dept_id
    INNER JOIN projects proj
        ON dept.dept_id = proj.dept_id;



--Part 4: LEFT JOIN Exercises
--      Exercise 4.1: Basic LEFT JOIN
SELECT e.emp_name,
       e.dept_id AS emp_dept,
       d.dept_id AS dept_dept,
       d.dept_name
    FROM employees e
    LEFT JOIN departments d
        ON e.dept_id = d.dept_id;

--      Exercise 4.2: LEFT JOIN with USING
SELECT e.emp_name,
       e.dept_id AS emp_dept,
       d.dept_id AS dept_dept,
       d.dept_name
    FROM employees e
    LEFT JOIN departments d USING(dept_id);

--      Exercise 4.3: Find Unmatched Records
SELECT e.emp_name, e.dept_id
    FROM employees e
    LEFT JOIN departments d USING (dept_id)
    WHERE dept_id IS NULL;

--      Exercise 4.4: LEFT JOIN with Aggregation


--Part 5: RIGHT JOIN Exercises
--Exercise 5.1: Basic RIGHT JOIN
SELECT e.emp_name, d.dept_name
    FROM employees e
    RIGHT JOIN departments d ON e.dept_id = d.dept_id;

--Exercise 5.2: Convert to LEFT JOIN
SELECT e.emp_name, d.dept_name
    FROM employees e
    LEFT JOIN departments d ON e.dept_id = d.dept_id;

--Exercise 5.3: Find Departments Without Employees
SELECT d.dept_name, d.location
    FROM employees e
    RIGHT JOIN departments d ON e.dept_id = d.dept_id
    WHERE e.emp_id IS NULL;

--Part 6: FULL JOIN Exercises
--      Exercise 6.1: Basic FULL JOIN
SELECT e.emp_name,
       e.dept_id AS emp_dept,
       d.dept_id AS dept_dept,
       d.dept_name
    FROM employees e
    FULL JOIN departments d ON e.dept_id = d.dept_id;

--      Exercise 6.2: FULL JOIN with Projects
SELECT d.dept_name, p.project_name, p.budget
FROM departments d
FULL JOIN projects p ON d.dept_id = p.dept_id;

--
SELECT CASE
        WHEN e.emp_id IS NULL THEN 'Department without employees'
        WHEN d.dept_id IS NULL THEN 'Employee without department'
        ELSE 'Matched'
       END AS record_status,
        e.emp_name,
        d.dept_name
    FROM employees e
    FULL JOIN departments d ON e.dept_id = d.dept_id
    WHERE e.emp_id IS NULL OR d.dept_id IS NULL;

--Part 7: ON vs WHERE Clause
--
SELECT e.emp_name, d.dept_name, e.salary
    FROM employees e
    LEFT JOIN departments d ON e.dept_id = d.dept_id AND d.location = 'Building A';

--      Exercise 7.2: Filtering in WHERE Clause (Outer Join)
SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.location = 'Building A';