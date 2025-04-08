# 🧮 Employee Insights SQL Analysis

## 📌 Overview
This project aimed to dives into employee data to uncover actionable insights using SQL. It mimics real-world HR and business analysis tasks—from salary comparisons to workforce demographics and potential cost-cutting strategies.

This project includes aggregations, joins, subqueries, CTEs, and window functions.


## 🗃️ Dataset

The dataset consists of three tables:

- **employee_demographics** – Employee ID, name, age, gender, birth date  
- **employee_salary** – Salary, occupation, department assignment  
- **parks_departments** – Department ID and names  


## 🛠️ SQL Skills Demonstrated

- Joins
- Aggregations (`AVG()`, `COUNT()`, `MAX()`, `MIN()`)
- Window Functions (`RANK() OVER`)
- Subqueries 
- Common Table Expressions (CTEs)
- `CASE` Statements
- Grouping, Filtering, Sorting
- Scenario-based business questions


## 📈 Key Takeaways

- Ability to analyze structured data from multiple dimensions (salary, department, age, etc.)
- Translate business questions into precise SQL queries
- Identify inconsistencies and prepare the data for decision support
- Showcase real-world analytical thinking using SQL

---
  
## 📊 Analysis Sections & Business Questions

### 🔹 Department & Salary Analysis

- What is the average salary per department, and how does it compare to the overall average?
- Which departments have the largest salary range?
- Rank all employees by salary within their department.
- Find occupations shared by multiple employees and compute average salary.
- Top 3 highest-paid employees per department.
- Salary band breakdown (Low / Medium / High) per department.

### 🔹 Employee Demographics

- Average age by department.
- Gender distribution by department.
- Youngest and oldest employees in each department.
- Employees within 5 years of retirement.

### 🔹 Scenario-Based Insights

- Which departments have the highest total payroll?
- What’s the projected average salary after a 5% raise?
- Employees earning below department average (for salary review).
- Potential promotion candidates (high performers under 35).

### 🔹 More Subqueries & CTEs

- Employees earning more than their department’s average.
- Department-level summaries using CTEs.

### 🔹 Data Quality & Inconsistencies

- Employees with missing department info.
- Duplicate employee names with different IDs.
  

## 💻 Tools Used

- SQL (MySQL Workbench)
- GitHub for version control and documentation


