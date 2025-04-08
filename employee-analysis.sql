-- Department & Salary Analysis
-- What is the average salary per department, and how does it compare to the overall average?
SELECT sal.dept_id, dept.department_name, 
	AVG(sal.salary) AS dept_avg_salary,
	(SELECT AVG(salary) 
    FROM employee_salary) AS overall_average
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id	
GROUP BY sal.dept_id
ORDER BY AVG(sal.salary) DESC;

-- Which departments have the largest salary ranges (max - min)?
SELECT sal.dept_id, 
	dept.department_name, 
	MAX(sal.salary) AS highest_salary, 
    MIN(sal.salary) AS lowest_salary, 
    (MAX(sal.salary) - MIN(sal.salary)) AS salary_range
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id		
GROUP BY sal.dept_id
ORDER BY salary_range DESC 
LIMIT 1;

-- Rank all employees by salary within their department.
SELECT dept.department_name, 
	sal.first_name, 
    sal.last_name, 
    sal.salary,
    RANK() OVER(PARTITION BY sal.dept_id ORDER BY sal.salary DESC) AS salary_rank
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
ORDER BY dept.department_name;

-- Find occupations where more than 1 employee shares the same role, and compute average salary per role.
SELECT dept.department_name, 
	sal.occupation, 
    COUNT(sal.employee_id) AS employee_count, 
    ROUND(AVG(sal.salary), 2) AS occupation_salary_avg
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY dept.department_name, sal.occupation
HAVING COUNT(sal.employee_id) > 1;

-- Find the top 3 highest-paid employees per department.
WITH ranked_salaries AS(
SELECT dept.department_name, 
	sal.first_name, 
    sal.last_name, 
    sal.salary,
    RANK() OVER(PARTITION BY sal.dept_id ORDER BY sal.salary DESC) AS salary_rank
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
)
SELECT department_name, first_name, last_name, salary, salary_rank 
FROM ranked_salaries
WHERE salary_rank <= 3
ORDER BY department_name, salary_rank;

-- Create a "salary band" (e.g., Low < 50K, Medium 50–70K, High > 70K) and count how many employees fall into each band per department.
SELECT dept.department_name,
	CASE 
		WHEN sal.salary < 50000 THEN "Low"
		WHEN sal.salary > 70000 THEN "High"
		ELSE "Medium" 
	END AS "salary_band",
    COUNT(*) AS employee_count
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY dept.department_name, salary_band
ORDER BY dept.department_name;

-- Employee Demographics Insights
-- What is the average age by department?
SELECT sal.dept_id, 
	dept.department_name, 
    ROUND(AVG(dem.age), 2) AS average_age
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY sal.dept_id
ORDER BY average_age DESC;

-- What is the gender distribution per department?
SELECT dept.department_name,
    dem.gender,
	COUNT(dem.employee_id) AS gender_distribution
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY dem.gender, sal.dept_id
ORDER BY dept.department_name ASC;

-- Find the youngest and oldest employee age in each department.
SELECT dept.department_name, 
	MAX(dem.age) AS oldest_employee, 
    MIN(dem.age) AS youngest_employee
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY dept.department_name
ORDER BY dept.department_name ASC;

-- List employees within 5 years of retirement age (e.g., age >= 60), sorted by department.
SELECT dem.first_name, dem.last_name, dem.age, dept.department_name
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
WHERE dem.age >= 60
ORDER BY dept.department_name ASC;


-- Missing or Inconsistent Data
-- List all employees with missing dept_id. Suggest a way to detect which department they likely belong to based on similar occupations.
SELECT employee_id, first_name, last_name, occupation, dept_id
FROM employee_salary
WHERE dept_id IS NULL;

-- Are there any employees with duplicate names but different IDs?
SELECT employee_id, first_name, last_name
FROM employee_demographics
WHERE (first_name, last_name) IN (
	SELECT first_name, last_name 
    FROM employee_demographics
    GROUP BY first_name, last_name 
    HAVING COUNT(DISTINCT employee_id) > 1
);


-- Subqueries & CTE Logic
-- Which employees earn more than their department’s average salary?
SELECT sal.employee_id,
	sal.first_name, 
    sal.last_name,
    dept.department_name,
    sal.salary,
    (SELECT ROUND(AVG(salary), 2) FROM employee_salary s WHERE s.dept_id = sal.dept_id) AS dept_avg_salary
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
WHERE sal.salary > (
	SELECT AVG(salary)
    FROM employee_salary s2
    WHERE s2.dept_id = sal.dept_id
    );

-- Use a CTE to create a department-level summary: total employees, average salary, and max salary.
WITH dept_summary AS (
	SELECT dept.department_name,
		COUNT(sal.employee_id) AS employee_count, 
		ROUND(AVG(sal.salary), 2) AS avg_salary, 
        MAX(sal.salary) AS highest_salary, 
        MIN(sal.salary) AS lowest_salary
	FROM employee_salary sal
	JOIN parks_departments dept ON sal.dept_id = dept.department_id
    GROUP BY dept.department_name
    ORDER BY dept.department_name
    )
SELECT * 
FROM dept_summary;


-- Scenario-Based Analysis
-- Assume the organization wants to cut costs. Which 3 departments have the highest total payroll?
SELECT 	sal.dept_id, 
	dept.department_name, 
	SUM(salary) AS total_payroll
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY sal.dept_id
ORDER BY total_payroll DESC 
LIMIT 3;

-- Assume everyone gets a 5% raise next year. What will the new average salary be per department?
SELECT sal.dept_id, 
	dept.department_name,
    ROUND(AVG(sal.salary * 1.05), 2) AS new_average_salary
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY sal.dept_id;

-- If employees making below the department average are flagged for salary review, who should be reviewed?
SELECT sal.employee_id,
	sal.first_name, 
    sal.last_name,
    dept.department_name,
    sal.salary,
    (SELECT ROUND(AVG(salary), 2) FROM employee_salary s WHERE s.dept_id = sal.dept_id) AS dept_avg_salary
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
WHERE sal.salary < (
	SELECT AVG(salary)
    FROM employee_salary s2
    WHERE s2.dept_id = sal.dept_id
    );

-- Build a "promotion candidate list": employees earning above average and under 35 years old.
SELECT sal.employee_id,
	sal.first_name, 
    sal.last_name,
    dem.age,
    dept.department_name,
    sal.salary,
    (SELECT ROUND(AVG(salary), 2) FROM employee_salary s WHERE s.dept_id = sal.dept_id) AS dept_avg_salary
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
WHERE sal.salary > (
	SELECT AVG(salary)
    FROM employee_salary s2
    WHERE s2.dept_id = sal.dept_id
    )
    AND dem.age < 35;


