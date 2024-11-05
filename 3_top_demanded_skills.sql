/*
Question: What are the mos in-demand skills for data scientists?
- Join job postings inner join table similar to query 2;
- Identify the top 5 in-demand skills for a data scientist;
- Focus on all job postings;
- This will help highlight relevant roles that are in demand and get 
the top-paying opportunities for Data Scientists, offering insights on the area.
*/

SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;