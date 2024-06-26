/*
Goal:
    Get insights on top paying job opportunities 
Question:
    1. Identify the top 100 highest paying Data-Analyst roles that are available in Australia
    2. Focuses on job postings with specified salaries (remove nulls)
    3. Relate job postings to their respective companies
*/

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
