/*
Technologies with the highest demand on the market
*/
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg is NOT NULL
    AND job_location = 'Poland'
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 35

/*
Results are expected =
- High demand for Big data & ML Skills
- Knowledge in development tools
- Cloud and data engineering
*/