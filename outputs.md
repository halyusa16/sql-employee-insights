## Nashville Employee Salary Analysis using SQL

### 📊 Department & Salary Analysis

#### 1. What is the average salary per department, and how does it compare to the overall average?
| dept_id | department_name       | dept_avg_salary | overall_average |
|---------|------------------------|------------------|------------------|
| 6       | Finance                | 71000.00         | 58350.00         |
| 3       | Public Works           | 66800.00         | 58350.00         |
| 1       | Parks and Recreation   | 56428.57         | 58350.00         |
| 4       | Healthcare             | 52500.00         | 58350.00         |
| 5       | Library                | 45000.00         | 58350.00         |

#### 2. Which department has the largest salary range?
| dept_id | department_name | highest_salary | lowest_salary | salary_range |
|---------|------------------|----------------|----------------|----------------|
| 3       | Public Works     | 95000          | 30000          | 65000          |

#### 3. Rank all employees by salary within their department
Sample output:
| department_name       | first_name | last_name     | salary | salary_rank |
|------------------------|-------------|----------------|--------|--------------|
| Finance                | Janet       | Doe            | 72000  | 1            |
| Finance                | Ben         | Wyatt          | 70000  | 2            |
| Parks and Recreation   | Leslie      | Knope          | 75000  | 1            |
| Parks and Recreation   | Ron         | Swanson        | 70000  | 2            |
| ...                   | ...         | ...            | ...    | ...          |

#### 4. Occupations shared by multiple employees & their average salary
| department_name       | occupation          | employee_count | occupation_salary_avg |
|------------------------|---------------------|------------------|------------------------|
| Parks and Recreation   | Office Manager      | 2                | 55000.00               |

#### 5. Top 3 highest-paid employees per department
Sample output:
| department_name       | first_name | last_name     | salary | salary_rank |
|------------------------|-------------|----------------|--------|--------------|
| Public Works           | Michael     | Realman        | 95000  | 1            |
| Public Works           | Chris       | Traeger        | 90000  | 2            |
| Public Works           | Joe         | Fanelli        | 62000  | 3            |

#### 6. Salary bands and employee counts per department
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

### 👥 Employee Demographics Insights

#### 1. Average age by department
| dept_id | department_name       | average_age |
|---------|------------------------|--------------|
| 1       | Parks and Recreation   | 42.17        |
| 3       | Public Works           | 41.00        |
| 6       | Finance                | 33.00        |
| 5       | Library                | 33.00        |
| 4       | Healthcare             | 32.00        |

#### 2. Gender distribution per department
| department_name       | gender | gender_distribution |
|------------------------|--------|------------------------|
| Parks and Recreation   | Female | 3                      |
| Parks and Recreation   | Male   | 3                      |
| Public Works           | Male   | 5                      |
| Healthcare             | Female | 2                      |
| ...                    | ...    | ...                    |

#### 3. Youngest and oldest employee per department
| department_name       | oldest_employee | youngest_employee |
|------------------------|------------------|--------------------|
| Parks and Recreation   | 61               | 29                 |
| Public Works           | 50               | 31                 |
| Finance                | 38               | 28                 |

#### 4. Employees within 5 years of retirement (age >= 60)
| first_name | last_name | age | department_name       |
|-------------|------------|-----|------------------------|
| Jerry       | Gergich    | 61  | Parks and Recreation   |

---

### ⚠️ Missing or Inconsistent Data

#### 1. Employees with missing dept_id
| employee_id | first_name | last_name    | occupation                  | dept_id |
|-------------|-------------|---------------|------------------------------|----------|
| 10          | Andy        | Dwyer         | Shoe Shiner and Musician     | NULL     |
| 15          | Tahani      | Al-Jamil      | Public Relations Officer     | NULL     |
| 18          | Mona-Lisa   | Saperstein    | Marketing Executive          | NULL     |

#### 2. Duplicate employee names with different IDs
*Data not shown (placeholder for logic result)*

---

### 🧮 Subqueries & CTE Logic

#### 1. Employees earning above department average salary
Sample output:
| employee_id | first_name | last_name     | department_name       | salary | dept_avg_salary |
|--------------|-------------|----------------|------------------------|--------|------------------|
| 1            | Leslie      | Knope          | Parks and Recreation   | 75000  | 56428.57         |
| 7            | Ann         | Perkins        | Healthcare             | 55000  | 52500.00         |
| 17           | Janet       | Doe            | Finance                | 72000  | 71000.00         |

#### 2. Department-level summary using CTE
| department_name       | employee_count | avg_salary | highest_salary | lowest_salary |
|------------------------|------------------|------------|----------------|----------------|
| Parks and Recreation   | 7                | 56428.57   | 75000          | 25000          |
| Public Works           | 5                | 66800.00   | 95000          | 30000          |
| Finance                | 2                | 71000.00   | 72000          | 70000          |

---

### 💼 Scenario-Based Analysis

#### 1. Top 3 departments by total payroll
| dept_id | department_name       | total_payroll |
|---------|------------------------|----------------|
| 1       | Parks and Recreation   | 395000         |
| 3       | Public Works           | 334000         |
| 6       | Finance                | 142000         |

#### 2. New average salary per department after 5% raise
| dept_id | department_name       | new_average_salary |
|---------|------------------------|----------------------|
| 1       | Parks and Recreation   | 59250.00             |
| 3       | Public Works           | 70140.00             |
| 6       | Finance                | 74550.00             |

#### 3. Employees below department average salary (flagged for review)
Sample output:
| employee_id | first_name | last_name     | department_name       | salary | dept_avg_salary |
|--------------|-------------|----------------|------------------------|--------|------------------|
| 3            | Tom         | Haverford      | Parks and Recreation   | 50000  | 56428.57         |
| 4            | April       | Ludgate        | Parks and Recreation   | 25000  | 56428.57         |
| 11           | Mark        | Brendanawicz   | Public Works           | 57000  | 66800.00         |

#### 4. Promotion candidate list (salary > avg & age < 35)
Sample output:
| employee_id | first_name | last_name     | age | department_name       | salary | dept_avg_salary |
|--------------|-------------|----------------|-----|------------------------|--------|------------------|
| 17           | Janet       | Doe            | 28  | Finance                | 72000  | 71000.00         |


