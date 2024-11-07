/*
Quesion: What are the most optimal skills to learn (aka high demand and high-paying skills)?
- Idenfity skills in high demand and associated with high abverage salary for Data Scientist role;
- Concentrate on remote positions with specified salaries;
- This will help highlight relevant roles that are in demand and get 
the top-paying opportunities for Data Scientists, offering insights on the area.
*/

WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,  -- Select skill_id from skills_dim
        skills_dim.skills,     -- Select skill name
        COUNT(skills_job_dim.job_id) AS demand_count  -- Count of job postings requiring each skill
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id  -- Join to link job postings with skills
    INNER JOIN 
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id         -- Join to get skill names
    WHERE
        job_title_short = 'Data Scientist' AND  -- Filter for Data Scientist jobs
        salary_year_avg IS NOT NULL AND         -- Filter for jobs with a specified average salary
        job_work_from_home = True               -- Filter for work-from-home jobs
    GROUP BY
        skills_dim.skill_id                     -- Corrected alias here
), 
average_salary AS (
    SELECT 
        skills_job_dim.skill_id,                -- Select skill_id for salary aggregation
        ROUND(AVG(salary_year_avg), 2) AS avg_salary  -- Calculate average salary for each skill
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id  -- Join to link jobs and skills
    INNER JOIN 
        skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id         -- Join to get skill names (though not needed for selection here)
    WHERE
        job_title_short = 'Data Scientist' AND  -- Same filter as above for consistency
        salary_year_avg IS NOT NULL AND
        job_work_from_home = True
    GROUP BY
        skills_job_dim.skill_id                 -- Group by skill_id for salary averaging
)

SELECT
    skills_demand.skill_id,                    -- Select skill_id from skills_demand
    skills_demand.skills,                      -- Select skill name
    demand_count,                              -- Select demand count from skills_demand CTE
    avg_salary                                 -- Select average salary from average_salary CTE
FROM
    skills_demand
INNER JOIN 
    average_salary ON skills_demand.skill_id = average_salary.skill_id  -- Join CTEs on skill_id
WHERE
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25

-- rewriting the same query but more concisely
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
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
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25