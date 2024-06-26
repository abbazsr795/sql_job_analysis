/*
Goal:
    Find the most optimal skills for a Data Analyst role
Question:
    1. Identify skills that are both high in demand and have higher average salaries
    2. Concentrate on remote positions
*/

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