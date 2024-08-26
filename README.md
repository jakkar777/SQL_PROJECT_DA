# Introduction
This project explores top-paying jobs and skills that pays the most
Queries: [project](/project/)
## Tools i used
- **SQL**: Allowing me to query the database
- **PostgreSQL**: The chosen DBMS
- **Visual Studio Code**
- **Git & Github**: Tool to share SQL scripts
## The analysis
### Each query answers completly different specific aspect of the data analyst job market. Here's example:
1. Top paying jobs - serves to order jobs by highest average yearly salary for remote jobs.
```sql
SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
```
| Job title                         |            Salary       |
|-----------------------------------|-------------------------|
|Data Analyst                       |             650000      | 
|Data Analyst                       |             650000.0    |
|Director of Analytics              |             336500.0    |
|Associate Director- Data Insights  |             255829.5    |   
|Data Analyst, Marketing            |             232423.0    |
|Data Analyst (Hybrid/Remote)       |             217000.0    | 
|Principal Data Analyst (Remote)    |             205000.0    |
|Director, Data Analyst - HYBRID    |             189309.0    |
|Principal Data Analyst, AV Performance Analysis | 189000.0   |
|ERM Data Analyst                   |              184000.0   |

2. Top paying jobs skills
```sql
WITH top_paying_jobs AS (

SELECT
    job_id,
    job_title,
    salary_year_avg,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC
```

|Skill|	Average Salary |
-------|----------------------|
|	databricks	|255,829.5|
|	azure	|255,829.5|
|	pyspark|255,829.5|
|pandas	|255,829.5|
|	aws	|255,829.5|
|	jupyter	|255,829.5|
|	tableau	|55,829.5|
|excel	|255,829.5|
|	powerpoint	|255,829.5|
|	power bi	|255,829.5|
3. In demand skills
```sql
SELECT
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Poland'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
| Skills    | Demand Count|
|-----------|-------------|
| SQL       | 7291        |
| Excel     | 4611        |
| Python    | 4330        |
| Tableau   | 3745        |
| Power Bi  | 2609        |
4. Top(paying) demanded skills - This specific one is analyzed for Poland job location:
- Cloud connected technologies such as BigQuery, Airflow, Hadoop are among the highest paid skills.
- Obviously data visualization tools such as Tableau
- Programming is also very important (espacially Python with Big Data frameworks)


|Umiejętność	|Średnie wynagrodzenie (USD)|
|-------|-------------|
|BigQuery	|111,175|
|Airflow	|111,175|
|Tableau	|109,006|
|Windows	|108,283|
|Spark	|102,500|
|Flow	|102,500|
|Git	|102,500|
|Hadoop	|102,500|
|Scikit-learn	|102,500|
|Looker	|99,979|
|Python	|96,073|
|SQL	|86,347|
|GCP	|80,492|
|PySpark	|77,757|
|Excel	|74,239|
|SAP	|60,109|
|PowerPoint	|60,109|
|GDPR	|43,200|
```sql
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
LIMIT 25
```
5. Most optimal skills (skills that are most often required and how much they earn). There is also version that analyses it for Poland inside of the file. The results are similiar to the previous ones.

| **Skill**  | **Demand** | **Average year salary** |
|------------------|---------------------|---------------------------------|
| Go               | 27                  | 115,320                         |
| Confluence       | 11                  | 114,210                         |
| Hadoop           | 22                  | 113,193                         |
| Snowflake        | 37                  | 112,948                         |
| Azure            | 34                  | 111,225                         |
| BigQuery         | 13                  | 109,654                         |
| AWS              | 32                  | 108,317                         |
| Java             | 17                  | 106,906                         |
| SSIS             | 12                  | 106,683                         |
| Jira             | 20                  | 104,918                         |
| Oracle           | 37                  | 104,534                         |
| Looker           | 49                  | 103,795                         |
| NoSQL            | 13                  | 101,414                         |
| Python           | 236                 | 101,397                         |
| R                | 148                 | 100,499                         |
| Redshift         | 16                  | 99,936                          |
| Qlik             | 13                  | 99,631                          |
| Tableau          | 230                 | 99,288                          |
| SSRS             | 14                  | 99,171                          |
| Spark            | 13                  | 99,077                          |
| C++              | 11                  | 98,958                          |
| SAS              | 63                  | 98,902                          |
| SQL Server       | 35                  | 97,786                          |
| JavaScript       | 20                  | 97,587                          |

```sql
WITH skills_demand AS (
    SELECT
        skills_job_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id,
        skills_dim.skills
), average_salary AS (
    SELECT
        skills_job_dim.skill_id,
        skills_dim.skills,
        ROUND(AVG(salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id,
        skills_dim.skills
)

SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE
    demand_count > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;
```

# What i learned
This was my first SQL project so:
* SQL queries, subqueries and CTEs
* Functions like COUNT() and AVG()
* A skill to analyze data using SQL only.

# Conclucions

This project taught me strong basics of SQL and provided valuable insights of data analyst (and data scientists) job market. The findings from the analysis will guide me to which skills i should learn and focus on. Even though that python is not looking the greatest i will focus on learning it more in the nearest future.