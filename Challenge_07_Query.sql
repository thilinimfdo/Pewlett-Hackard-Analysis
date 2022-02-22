--CREATING TABLES AND IMPORTING DATA

CREATE TABLE departments(
	dept_no VARCHAR (4) NOT NULL UNIQUE,
	dept_name VARCHAR (40) NOT NULL UNIQUE,
	PRIMARY KEY (dept_no)
);

SELECT * FROM departments;


CREATE TABLE employees (
	emp_no INT NOT NULL UNIQUE,
	birth_date DATE NOT NULL,
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	gender VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY (emp_no)
);

SELECT * FROM Employees;


CREATE TABLE dept_managers(
	dept_no VARCHAR NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY (emp_no , dept_no)
);

SELECT * FROM dept_managers;


CREATE TABLE dept_employees(
	emp_no INT NOT NULL,
	dept_no VARCHAR NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);

SELECT * FROM dept_employees;


CREATE TABLE titles(
	emp_no INT NOT NULL,
	title VARCHAR  (50) NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);

SELECT * FROM titles;

CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, from_date)
);

SELECT * FROM salaries;


--DELIVERABLE 01 : RETIRING EMPLOYEES BY TITLE

--Creating Table: retirement_title (emplyees born 1952-01-01 :1955-12-31)
SELECT employees.emp_no,
		employees.first_name,
		employees.last_name,
		titles.title,
		titles.from_date,
		titles.to_date
INTO retirement_title
FROM employees
INNER JOIN titles
ON employees.emp_no = titles.emp_no
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY employees.emp_no;

SELECT * FROM retirement_title;


-- Remove duplicates in retirement_title table
select DISTINCT ON (emp_no) emp_no, 
		first_name, 
		last_name,
		title
INTO unique_titles
FROM retirement_title
WHERE to_date = ('9999-01-01');

SELECT * FROM unique_titles;


--Calculating number of retirements for each title
SELECT COUNT (emp_no), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY title;

SELECT * FROM retiring_titles;


--DELIVERABLE 02 : EMPLOYEES ELIGIBLE FOR THE MENTORSHIP PROGRAM

-- Create a Table : Mentorship Eligibility 
SELECT DISTINCT ON (employees.emp_no) employees.emp_no,
		employees.first_name,
		employees.last_name,
		employees.birth_date,
		dept_employees.from_date,
		dept_employees.to_date,
		titles.title
INTO mentorship_eligibility
FROM employees
INNER JOIN dept_employees
ON employees.emp_no = dept_employees.emp_no
INNER JOIN titles
ON employees.emp_no = titles.emp_no
WHERE (dept_employees.to_date = '9999-01-01')
AND (employees.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY employees.emp_no;

SELECT * FROM mentorship_eligibility;