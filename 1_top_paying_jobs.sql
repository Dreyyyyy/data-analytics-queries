/*
Question: What are the top-paying data analyst jobs?
- Identify the top 10 highest-paying Data Scientist roles that are available remotely;
- Focuses on job postings with specified salaries (remove null values);
- This will help highlight relevant roles that are in demand and get 
the top-paying opportunities for Data Scientists, offering insights on the area.
*/

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
LEFT JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Scientist' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/*
Some insights about the query:
1. Top Salaries and Roles
The highest-paying roles are generally senior-level, often titled "Staff Data Scientist," "Head of Data Science," or "Director of Data Science."
Two positions at the top pay over $500,000 annually, with the Staff Data Scientist/Quant Researcher at Selby Jennings leading at $550,000.
2. Common Titles and Seniority
Most of these high-paying jobs are for senior and director-level roles. The job titles indicate both high responsibility and a deep level of expertise in data science and business analytics.
Titles like "Staff Data Scientist," "Director," "Head of Data Science," and "Principal Data Scientist" indicate a focus on leadership and strategic contributions rather than entry-level or even mid-level roles.
3. Employer Diversity
Companies vary from financial and investment firms (e.g., Selby Jennings, Algo Capital Group) to large tech and retail corporations like Walmart and Reddit.
This range highlights that high compensation is available across various industries, not limited to tech giants alone.
4. Remote and Flexible Location Options
Each position specifies "Anywhere" as the location, suggesting that remote work is a major perk at the high-paying level.
The flexibility for senior talent to work from anywhere aligns with recent trends in remote work, especially for roles that may not require physical presence.
5. Time-Sensitive Demand
Many of these roles were posted within the last few months (e.g., July to September 2023), signaling ongoing demand for highly skilled data scientists.
Quick changes in job openings might indicate either a high turnover in the data science field or an urgency to fill these high-level positions as companies continue to grow their data teams.
6. Industry Insights
Financial firms (Selby Jennings and Algo Capital) and large retailers (Walmart) offering top salaries suggest high-value insights derived from data science in these sectors.
Positions at Reddit and Walmart demonstrate the importance of data science for customer experience and engagement in digital and retail spaces.
7. Career Growth and Compensation Structure
The six-figure salaries even for roles lower on the list reflect how data science is viewed as a high-value field.
The high average salaries in these roles reflect not only the technical expertise required but also the business acumen necessary for making significant impacts on revenue and strategy.
*/