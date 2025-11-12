--Part 2: Creating Basic Views
--Exercise 2.1: Simple View Creation
CREATE VIEW employee_details AS
    SELECT e.emp_name,
           e.salary,
           d.dept_name,
           d.location
        FROM employees e
        INNER JOIN departments d
            ON d.dept_id = e.dept_id;

SELECT * FROM employee_details;
--Answer: 4 rows; because he has a null dept_id

--Exercise 2.2: View with Aggregation
CREATE VIEW dept_statistics AS
    SELECT d.dept_name,
           count(e.emp_id) AS employee_count,
           avg(e.salary) AS avg_sal,
           min(salary) AS min_sal,
           max(e.salary) AS max_sal
        FROM departments d
        INNER JOIN employees e ON e.dept_id = d.dept_id
        GROUP BY d.dept_id;

SELECT * FROM dept_statistics
ORDER BY employee_count DESC;

--Exercise 2.3: View with Multiple Joins
CREATE VIEW project_overview AS
    SELECT p.project_name,
           p.budget,
           d.dept_name,
           d.location,
           count(e.emp_id) AS team_size
        FROM projects p
        JOIN departments d USING (dept_id)
        LEFT JOIN employees e USING (dept_id)
        GROUP BY p.project_name, p.budget, d.dept_name, d.location;

SELECT * FROM project_overview;

--Exercise 2.4: View with Filtering
CREATE VIEW high_earners AS
    SELECT e.emp_name, e.salary, d.dept_name
        FROM employees e
        INNER JOIN departments d USING (dept_id)
        WHERE e.salary > 50000;

--Part 3: Modifying and Managing Views
--Exercise 3.1: Replace a View
CREATE OR REPLACE VIEW employee_details AS
    SELECT e.emp_name,
           e.salary,
           d.dept_name,
           d.location,
           CASE
               WHEN e.salary > 60000 THEN 'High'
               WHEN e.salary > 50000 THEN 'Medium'
               ELSE 'Standard'
            END
        FROM employees e
        INNER JOIN departments d
            ON d.dept_id = e.dept_id;

--Exercise 3.2: Rename a View
ALTER VIEW high_earners RENAME TO top_performers;

--Exercise 3.3: Drop a View
CREATE TEMPORARY VIEW temp_view AS
    SELECT *
        FROM employees e
        WHERE e.salary < 50000;

DROP VIEW temp_view;



--Part 4: Updatable Views
--Exercise 4.1: Create an Updatable View

/*
The view definition must not contain WITH, DISTINCT, GROUP BY, HAVING, LIMIT, or OFFSET clauses at the top level.
The view definition must not contain set operations (UNION, INTERSECT or EXCEPT) at the top level.
The view's select list must not contain any aggregates, window functions or set-returning functions.
 */
CREATE VIEW employee_salaries AS
    SELECT e.emp_id,
           e.emp_name,
           e.dept_id,
           e.salary
        FROM employees e;

--Exercise 4.2: Update Through a View
UPDATE employee_salaries
    SET salary = 52000
    WHERE emp_name = 'John Smith';

SELECT * FROM employees WHERE emp_name = 'John Smith';

--Exercise 4.3: Insert Through a View
INSERT INTO employee_salaries (emp_id, emp_name, dept_id, salary)
    VALUES (6,  'Alice Johnson', 102, 58000);

SELECT * FROM employees;

--Exercise 4.4: View with CHECK OPTION
CREATE VIEW it_employees AS
    SELECT *
        FROM employees
        WHERE dept_id = 101
        WITH LOCAL CHECK OPTION;

INSERT INTO it_employees (emp_id, emp_name, dept_id, salary)
    VALUES (7, 'Bob Wilson', 103, 60000);
--Нельзя вставить нового сотрудник без dept_id = 101 ли изменить dept_id

--Part 5: Materialized Views
--Exercise 5.1: Create a Materialized View
CREATE MATERIALIZED VIEW dept_summary_mv AS
    SELECT d.dept_id,
           d.dept_name,
           COUNT(e.emp_id),
           COALESCE(SUM(e.salary), 0),
           COUNT(p.dept_id),
           COALESCE(SUM(budget), 0)
        FROM departments d
        INNER JOIN projects p USING (dept_id)
        INNER JOIN employees e USING (dept_id)
        GROUP BY d.dept_id, d.dept_name;

--Exercise 5.2: Refresh Materialized View
INSERT INTO employees (emp_id, emp_name, dept_id, salary)
VALUES (8, 'Charlie Brown', 101, 54000);

--
CREATE UNIQUE INDEX idx_dept_summary_mv_dept_id
    ON dept_summary_mv (dept_id);

--Exercise 5.4: Materialized View with NO DATA
CREATE MATERIALIZED VIEW project_stats_mv AS
SELECT
    p.project_name,
    p.budget,
    d.dept_name,
    COUNT(e.emp_id) AS assigned_employees
FROM projects p
JOIN departments d ON p.dept_id = d.dept_id
LEFT JOIN employees e ON e.dept_id = d.dept_id
GROUP BY p.project_name, p.budget, d.dept_name
WITH NO DATA;


--Part 6: Database Roles
--Exercise 6.1: Create Basic Roles
CREATE ROLE analyst;
CREATE ROLE data_viewer LOGIN PASSWORD 'viewer123';
CREATE ROLE report_user PASSWORD 'report456';


--Exercise 6.2: Role with Specific Attributes
CREATE ROLE db_creator LOGIN PASSWORD 'creator789' CREATEDB;
CREATE ROLE user_manager LOGIN PASSWORD 'manager101' CREATEROLE;
CREATE ROLE admin_user LOGIN PASSWORD 'admin999' SUPERUSER;

--Exercise 6.3: Grant Privileges to Roles
GRANT SELECT ON employees, departments, projects TO analyst;
GRANT ALL PRIVILEGES ON employee_details TO data_viewer;
GRANT SELECT, INSERT ON employees TO report_user;

--Exercise 6.4: Create Group Roles

CREATE ROLE hr_team NOLOGIN;
CREATE ROLE finance_team NOLOGIN;
CREATE ROLE it_team NOLOGIN;

CREATE ROLE hr_user1 LOGIN PASSWORD 'hr001';
CREATE ROLE hr_user2 LOGIN PASSWORD 'hr002';
CREATE ROLE finance_user1 LOGIN PASSWORD 'fin001';

GRANT hr_team TO hr_user1, hr_user2;
GRANT finance_team TO finance_user1;

GRANT SELECT, UPDATE ON employees TO hr_team;
GRANT SELECT ON dept_statistics TO finance_team;

--Exercise 6.5: Revoke Privileges
REVOKE UPDATE ON employees FROM hr_team;

REVOKE hr_team FROM hr_user2;

REVOKE ALL PRIVILEGES ON employee_details FROM data_viewer;

--Exercise 6.6: Modify Role Attributes
ALTER ROLE analyst LOGIN PASSWORD 'analyst123';

ALTER ROLE user_manager SUPERUSER;

ALTER ROLE analyst PASSWORD NULL;

ALTER ROLE data_viewer CONNECTION LIMIT 5;