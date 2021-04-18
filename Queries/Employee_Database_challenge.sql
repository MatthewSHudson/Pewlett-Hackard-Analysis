-- Retrieve data and join to create the retirement_titles table
SELECT e.emp_no, e.first_name, e.last_name, ti.title, ti.from_date, ti.to_date
INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS ti 
ON e.emp_no = ti.emp_no
WHERE e.birth_date BETWEEN '1952-01-01' AND '1955-12-31'
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title
INTO uniques_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Get the number of soon-to-retire employees by title of their role
SELECT COUNT (title),
title
INTO retiring_titles
FROM uniques_titles 
GROUP BY title
ORDER BY 1 DESC;

-- Create the table that contains candidates for the mentorship program
SELECT DISTINCT ON (e.emp_no) e.emp_no, 
		e.first_name, 
		e.last_name, 
		e.birth_date, 
		de.from_date,
		de.to_date,
		ti.title
INTO mentorship_eligibility
FROM employees AS e
INNER JOIN dept_emp AS de
	ON (e.emp_no = de.emp_no)
INNER JOIN titles AS ti
	ON (e.emp_no = ti.emp_no)
WHERE (de.to_date = '9999-01-01')
	AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY (e.emp_no);

-- Check to see how many Managers are eligible to mentor (0)
SELECT COUNT(*) FROM mentorship_eligibility
WHERE title = 'Manager';

-- Get the number of employees who are retiring and are current employees
SELECT COUNT(*) FROM uniques_titles_with_date
WHERE to_date = '9999-01-01';

-- Make a table to display the number of eligible mentors per role
-- DROP TABLE mentorship_titles;
SELECT  COUNT(title) AS mentors,
		title
-- INTO mentorship_titles
FROM mentorship_eligibility
GROUP BY title
ORDER BY 1 DESC;

-- Make a copy of the uniques_tables but with a to_date column
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title,
to_date
-- INTO uniques_titles_with_date
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Create a table of current employees who will retire by role
-- DROP TABLE current_titles;
SELECT  COUNT(title) AS retirees,
		title 
-- INTO current_titles
FROM uniques_titles_with_date
WHERE to_date = '9999-01-01'
GROUP BY title
ORDER BY 1 DESC;

-- Create a table that displays the mentee:mentor ratio per role
SELECT  (ct.retirees::float) / mt.mentors AS mentees_per_mentor, 
		ct.title
FROM current_titles AS ct
LEFT JOIN mentorship_titles AS mt
ON (ct.title = mt.title)
ORDER BY 1 DESC;

