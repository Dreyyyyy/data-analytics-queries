/*
Question: What are the top skills based on salary and remote work?
- Look at the average salary associated with each skill;
- Focuses on roles with specified salaries (remove null values);
- This will help highlight relevant roles that are in demand and get 
the top-paying opportunities for Data Scientists, offering insights on the area.
*/

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 2) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;

/*
Key Takeaways
 * Emerging Technologies and Data Privacy: Skills like GDPR and blockchain development (Solidity) highlight a high demand for knowledge in emerging tech and compliance.
 * Performance-Oriented Languages: Languages like Rust, Go, and Elixir stand out due to their performance in systems programming and scalability.
 * Data Science and Analytics: There’s a substantial demand for skills in analytics platforms, data visualization tools, and big data processing, underlining the value of data-driven decision-making.
 * Cloud and Infrastructure: DevOps and cloud-related tools (Airflow, Redis) are crucial for managing complex applications and workflows at scale.
 * In general, companies are investing heavily in professionals who can manage specialized data tasks, comply with privacy regulations, and streamline cloud-native and data-driven operations.
*/