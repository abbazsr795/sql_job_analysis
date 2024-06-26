/*
Goal:
    Find top 25 skills that pay the most in Data Analyst jobs
Question:
    1. Find the average salary of all skills in respect to their job postings
    2. Order them by the average salaries
    3. Relate the jobs to their respective skill requirements 
*/

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