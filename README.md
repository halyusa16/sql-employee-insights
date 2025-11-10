# Employee Insights SQL Analysis

## Overview
This project aimed to dives into employee data to uncover actionable insights using SQL. It mimics real-world HR and business analysis tasks—from salary comparisons to workforce demographics and potential cost-cutting strategies. Used for querying exercise.

This project includes aggregations, joins, subqueries, CTEs, and window functions.


## Dataset

The dataset consists of three tables:

- **employee_demographics** – Employee ID, name, age, gender, birth date  
- **employee_salary** – Salary, occupation, department assignment  
- **parks_departments** – Department ID and names  


## SQL Skills Demonstrated

- Joins
- Aggregations (`AVG()`, `COUNT()`, `MAX()`, `MIN()`)
- Window Functions (`RANK() OVER`)
- Subqueries 
- Common Table Expressions (CTEs)
- `CASE` Statements
- Grouping, Filtering, Sorting
- Scenario-based business questions


## Key Takeaways

- Ability to analyze structured data from multiple dimensions (salary, department, age, etc.)
- Translate business questions into precise SQL queries
- Identify inconsistencies and prepare the data for decision support
- Showcase real-world analytical thinking using SQL

---
  
## Analysis Sections & Business Questions

### Department & Salary Analysis

- What is the average salary per department, and how does it compare to the overall average?
```sql
SELECT sal.dept_id, dept.department_name, 
	AVG(sal.salary) AS dept_avg_salary,
	(SELECT AVG(salary) 
    FROM employee_salary) AS overall_average
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id	
GROUP BY sal.dept_id
ORDER BY AVG(sal.salary) DESC;
```
| dept_id | department_name       | dept_avg_salary | overall_average |
|---------|------------------------|------------------|------------------|
| 6       | Finance                | 71000.00         | 58350.00         |
| 3       | Public Works           | 66800.00         | 58350.00         |
| 1       | Parks and Recreation   | 56428.57         | 58350.00         |
| 4       | Healthcare             | 52500.00         | 58350.00         |
| 5       | Library                | 45000.00         | 58350.00         |
- Which departments have the largest salary range?
```sql
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
```
| dept_id | department_name | highest_salary | lowest_salary | salary_range |
|---------|------------------|----------------|----------------|----------------|
| 3       | Public Works     | 95000          | 30000          | 65000          |
- Rank all employees by salary within their department.
```sql
SELECT dept.department_name, 
	sal.first_name, 
    sal.last_name, 
    sal.salary,
    RANK() OVER(PARTITION BY sal.dept_id ORDER BY sal.salary DESC) AS salary_rank
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
ORDER BY dept.department_name;
```
Sample output:
| department_name       | first_name | last_name     | salary | salary_rank |
|------------------------|-------------|----------------|--------|--------------|
| Finance                | Janet       | Doe            | 72000  | 1            |
| Finance                | Ben         | Wyatt          | 70000  | 2            |
| Parks and Recreation   | Leslie      | Knope          | 75000  | 1            |
| Parks and Recreation   | Ron         | Swanson        | 70000  | 2            |
| ...                   | ...         | ...            | ...    | ...          |
- Find occupations shared by multiple employees and compute average salary.
```sql
SELECT dept.department_name, 
	sal.occupation, 
    COUNT(sal.employee_id) AS employee_count, 
    ROUND(AVG(sal.salary), 2) AS occupation_salary_avg
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY dept.department_name, sal.occupation
HAVING COUNT(sal.employee_id) > 1;
```
| department_name       | occupation          | employee_count | occupation_salary_avg |
|------------------------|---------------------|------------------|------------------------|
| Parks and Recreation   | Office Manager      | 2                | 55000.00               |
- Top 3 highest-paid employees per department.
```sql
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
```
Sample output:
| department_name       | first_name | last_name     | salary | salary_rank |
|------------------------|-------------|----------------|--------|--------------|
| Public Works           | Michael     | Realman        | 95000  | 1            |
| Public Works           | Chris       | Traeger        | 90000  | 2            |
| Public Works           | Joe         | Fanelli        | 62000  | 3            |
- Salary band breakdown (Low / Medium / High) per department.
```sql
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
```
Sample output: 
| department_name       | salary_band | employee_count |
|------------------------|--------------|-----------------|
| Public Works           | High         | 2               |
| Public Works           | Medium       | 2               |
| Public Works           | Low          | 1               |
| Parks and Recreation   | High         | 1               |
| Parks and Recreation   | Medium       | 4               |
| Parks and Recreation   | Low          | 1               |
| ...                    | ...          | ...             |

---

### 🔹 Employee Demographics

- Average age by department.
```sql
SELECT sal.dept_id, 
	dept.department_name, 
    ROUND(AVG(dem.age), 2) AS average_age
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY sal.dept_id
ORDER BY average_age DESC;
```
| dept_id | department_name       | average_age |
|---------|------------------------|--------------|
| 1       | Parks and Recreation   | 42.17        |
| 3       | Public Works           | 41.00        |
| 6       | Finance                | 33.00        |
| 5       | Library                | 33.00        |
| 4       | Healthcare             | 32.00        |
- Gender distribution by department.
```sql
SELECT dept.department_name,
    dem.gender,
	COUNT(dem.employee_id) AS gender_distribution
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY dem.gender, sal.dept_id
ORDER BY dept.department_name ASC;
```
Sample output: 
| department_name       | gender | gender_distribution |
|------------------------|--------|------------------------|
| Parks and Recreation   | Female | 3                      |
| Parks and Recreation   | Male   | 3                      |
| Public Works           | Male   | 5                      |
| Healthcare             | Female | 2                      |
| ...                    | ...    | ...                    |
- Youngest and oldest employees in each department.
```sql
SELECT dept.department_name, 
	MAX(dem.age) AS oldest_employee, 
    MIN(dem.age) AS youngest_employee
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY dept.department_name
ORDER BY dept.department_name ASC;
```
| department_name       | oldest_employee | youngest_employee |
|------------------------|------------------|--------------------|
| Parks and Recreation   | 61               | 29                 |
| Public Works           | 50               | 31                 |
| Finance                | 38               | 28                 |
- Employees within 5 years of retirement.
```sql
SELECT dem.first_name, dem.last_name, dem.age, dept.department_name
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
JOIN parks_departments dept ON sal.dept_id = dept.department_id
WHERE dem.age >= 60
ORDER BY dept.department_name ASC;
```
| first_name | last_name | age | department_name       |
|-------------|------------|-----|------------------------|
| Jerry       | Gergich    | 61  | Parks and Recreation   |

---

### 🔹 Scenario-Based Insights

- Assume the organization wants to cut costs. Which 3 departments have the highest total payroll?
```sql
SELECT 	sal.dept_id, 
	dept.department_name, 
	SUM(salary) AS total_payroll
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY sal.dept_id
ORDER BY total_payroll DESC 
LIMIT 3;
```
| dept_id | department_name       | total_payroll |
|---------|------------------------|----------------|
| 1       | Parks and Recreation   | 395000         |
| 3       | Public Works           | 334000         |
| 6       | Finance                | 142000         |
- What’s the projected average salary after a 5% raise?
```sql
SELECT sal.dept_id, 
	dept.department_name,
    ROUND(AVG(sal.salary * 1.05), 2) AS new_average_salary
FROM employee_salary sal
JOIN parks_departments dept ON sal.dept_id = dept.department_id
GROUP BY sal.dept_id;
```
| dept_id | department_name       | new_average_salary |
|---------|------------------------|----------------------|
| 1       | Parks and Recreation   | 59250.00             |
| 3       | Public Works           | 70140.00             |
| 6       | Finance                | 74550.00             |
- Employees earning below department average (for salary review).
```sql
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
```
| employee_id | first_name | last_name     | department_name       | salary | dept_avg_salary |
|--------------|-------------|----------------|------------------------|--------|------------------|
| 3            | Tom         | Haverford      | Parks and Recreation   | 50000  | 56428.57         |
| 4            | April       | Ludgate        | Parks and Recreation   | 25000  | 56428.57         |
| 11           | Mark        | Brendanawicz   | Public Works           | 57000  | 66800.00         |
-  Potential promotion candidates (high performers under 35).
```sql
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
```
| employee_id | first_name | last_name     | age | department_name       | salary | dept_avg_salary |
|--------------|-------------|----------------|-----|------------------------|--------|------------------|
| 17           | Janet       | Doe            | 28  | Finance                | 72000  | 71000.00         |

--- 

### 🔹 More Subqueries & CTEs

- Employees earning more than their department’s average.
```sql
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
```
| employee_id | first_name | last_name     | department_name       | salary | dept_avg_salary |
|--------------|-------------|----------------|------------------------|--------|------------------|
| 1            | Leslie      | Knope          | Parks and Recreation   | 75000  | 56428.57         |
| 7            | Ann         | Perkins        | Healthcare             | 55000  | 52500.00         |
| 17           | Janet       | Doe            | Finance                | 72000  | 71000.00         |
- Department-level summaries using CTEs.
```sql
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
```
Sample output:
| department_name       | employee_count | avg_salary | highest_salary | lowest_salary |
|------------------------|------------------|------------|----------------|----------------|
| Parks and Recreation   | 7                | 56428.57   | 75000          | 25000          |
| Public Works           | 5                | 66800.00   | 95000          | 30000          |
| Finance                | 2                | 71000.00   | 72000          | 70000          |

---

### 🔹 Data Quality & Inconsistencies

- Employees with missing department info.
```sql
SELECT employee_id, first_name, last_name, occupation, dept_id
FROM employee_salary
WHERE dept_id IS NULL;
```
*Data not shown (placeholder for logic result)*

- Duplicate employee names with different IDs.
```sql
SELECT employee_id, first_name, last_name
FROM employee_demographics
WHERE (first_name, last_name) IN (
	SELECT first_name, last_name 
    FROM employee_demographics
    GROUP BY first_name, last_name 
    HAVING COUNT(DISTINCT employee_id) > 1
);
``` 
| employee_id | first_name | last_name    | occupation                  | dept_id |
|-------------|-------------|---------------|------------------------------|----------|
| 10          | Andy        | Dwyer         | Shoe Shiner and Musician     | NULL     |
| 15          | Tahani      | Al-Jamil      | Public Relations Officer     | NULL     |
| 18          | Mona-Lisa   | Saperstein    | Marketing Executive          | NULL     |

## Tools Used

- SQL (MySQL Workbench)
- GitHub for version control and documentation

---
