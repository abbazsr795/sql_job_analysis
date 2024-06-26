# Introduction
Understand the job market for Data Analyst roles, including the salary and skill requirements of each posting, to create an optimal roadmap for future data analysts.

SQL queries used [project_sql_folder](/project_sql/)
# Tools
- SQL: Used for querying databases
- PostgreSQL: The preferred database management system due to its popularity and strong community support

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. 

## 1. Top Paying Data ANalyst Jobs
To identify the highest-paying roles, I filtered data analyst positions by average yearly salary and location, focusing on remote jobs and the Australian based ones.

```sql
SELECT
    job_id,
    job_title,
    company_dim.name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date
FROM
    job_postings_fact
LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    (job_location = 'Anywhere' OR
    job_country = 'Australia')
    AND
    job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
ORDER BY 
    salary_year_avg DESC
LIMIT
    100
```
## 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        company_dim.name AS company_name,
        salary_year_avg
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON company_dim.company_id = job_postings_fact.company_id
    WHERE
        (job_location = 'Anywhere' OR
        job_country = 'Australia')
        AND
        job_title_short = 'Data Analyst'
        AND
        salary_year_avg IS NOT NULL
    ORDER BY 
        salary_year_avg DESC
    LIMIT
        100
)

SELECT
    top_paying_jobs.*,
    skills
FROM
    top_paying_jobs
INNER JOIN skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN  skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
ORDER BY
    top_paying_jobs.salary_year_avg DESC
```
## 3. In-Demand Skills for Data Analysts
This query helped identify the most frequently requested skills in job postings, highlighting areas with high demand.
```sql
SELECT
    skills_dim.skills AS skills,
    COUNT(job_postings_fact.job_id) AS postings
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skill_id
ORDER BY
    postings DESC
LIMIT
    5
```
## 4.Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.
```sql
SELECT
    skills_dim.skills AS skills,
    ROUND(AVG(job_postings_fact.salary_year_avg),0) AS average_skill_salary
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills_dim.skill_id
ORDER BY
    average_skill_salary DESC
LIMIT
    25
```
## 5. Most Optimal Skills to Learn
By combining insights from demand and salary data, this query aimed to identify skills that are both highly sought after and well-compensated, providing a strategic focus for skill development.
```sql
WITH top_demand_skills AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills AS skills,
        COUNT(job_postings_fact.job_id) AS postings
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
), top_paying_skills AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills AS skills,
        ROUND(AVG(job_postings_fact.salary_year_avg),0) AS average_skill_salary
    FROM
        job_postings_fact
    INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
    INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        salary_year_avg IS NOT NULL AND
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
)

SELECT
    top_demand_skills.skill_id,
    top_demand_skills.skills,
    postings,
    average_skill_salary
FROM
    top_demand_skills
INNER JOIN top_paying_skills ON top_paying_skills.skill_id = top_demand_skills.skill_id
WHERE
    postings > 20
ORDER BY
    top_paying_skills.average_skill_salary DESC,
    postings DESC
LIMIT
    25
```
