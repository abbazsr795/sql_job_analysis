/*
Goal:
    Get insights on the top 5 in demand skills for Data Analysts across all job opportunities 
Question:
    1. Identify the most in demand skillsfor Data-Analyst roles
    2. Relate the jobs to their respective skill requirements 
*/

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