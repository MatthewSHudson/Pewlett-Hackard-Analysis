SELECT first_name, last_name FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

--Number of employees retiring 
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

--Create reitrement_info table from the query
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Drop the retirement_info table
DROP TABLE retirement_info;

--Recreate the retirement_info table but include the emp_no
SELECT emp_no,first_name,last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

--Create a table that has all the departments and their managers info listed
SELECT d.dept_name, d_m.emp_no, d_m.from_date, d_m.to_date
FROM departments as d
INNER JOIN dept_manager as d_m ON d.dept_no = d_m.dept_no;

--Join the retirement_info and dept_emp tables to filter out employees who have already left
SELECT r.emp_no, r.first_name, r.last_name, d.to_date
FROM retirement_info AS r
LEFT JOIN dept_emp AS d ON r.emp_no = d.emp_no;

--Join the retirement and dept_emp tables again but this time filter the result to current employees
SELECT r.emp_no, r.first_name, r.last_name, d.to_date
INTO current_emp
FROM retirement_info AS r
LEFT JOIN dept_emp AS d ON r.emp_no = d.emp_no
WHERE (d.to_date = '9999-01-01');

--Join the current_emp and dept_emp tables to get the number of employees in each department
SELECT COUNT(ce.emp_no), de.dept_no
INTO department_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

DROP TABLE emp_info
--Create an expanded current_emp table that includes gender, salary, and most recent date of employment
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries AS s
ON e.emp_no = s.emp_no
INNER JOIN dept_emp AS de
ON e.emp_no = de.emp_no
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

-- list of managers per department
SELECT  dm.dept_no,
		d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO managers_info
FROM dept_manager AS dm
	INNER JOIN departments AS d
		ON dm.dept_no = d.dept_no
	INNER JOIN current_emp as ce
		ON dm.emp_no = ce.emp_no;

-- extend the current employee table to include the department name
SELECT  ce.emp_no,
		ce.first_name,
		ce.last_name,
		d.dept_name
INTO dept_info
FROM current_emp AS ce
	INNER JOIN dept_emp AS de
		ON ce.emp_no = de.emp_no
	INNER JOIN departments AS d
		ON de.dept_no = d.dept_no;
		
SELECT * FROM dept_info 
WHERE (dept_name IN ('Sales','Development'));