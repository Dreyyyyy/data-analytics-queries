# Data Analytics Queries
Repository containing some queries on a database about Data Science related works.

# Introduction
This project explores top-paying jobs, in-demand skills and where high demand meets high salary in data analytics. It's heavily inspired on [Luke Barousse Data Analytics video](https://www.youtube.com/watch?v=7mz73uXD9DA&t=). All the csv files can be found on [his free resource topic](https://www.lukebarousse.com/sql).

SQL queries to load all the date are here: [SQL load queries](/data/sql_load/).

# Background
This project was inspired by a drive to navigate the data science job market with greater precision. Aiming to identify the most in-demand and highest-paying skills, it provides a streamlined approach to help others efficiently find the best job opportunities in the field.

### Following that, those are the questions I wanted to answer with those SQL queries:
1. What are the top-paying data scientists jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for data scientists?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn about it?
# Tools That I Used
For this project, some data handling tools have been used, such as:

- **SQL**: Used for querying and managing data;
- **PostgreSQL**: A powerful open-source database management system utilized for storing, retrieving, and manipulating large datasets;
- **VSCode**: The integrated development environment (IDE) used for writing and executing SQL queries efficiently;
- **Git & GitHub**: Version control tools used to manage project changes and collaborate effectively with other team members.
# The Analysis
Each query for this project was aimed to learn about patterns listed on the background topic.

### 1. Top Paying Data Scientist Jobs
To identify the highest-paying roles, I've filtered data scientist positions bt average yearly salary and location, focusing just on remote jobs. This query highlights the high paying opportunities in the field.

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
LEFT JOIN 
    company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Scientist' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
#### Some insights about the query:
**1. Top Salaries and Roles**

The highest-paying roles are generally senior-level, often titled "Staff Data Scientist," "Head of Data Science," or "Director of Data Science."
Two positions at the top pay over $500,000 annually, with the Staff Data Scientist/Quant Researcher at Selby Jennings leading at $550,000.

**2. Common Titles and Seniority**

Most of these high-paying jobs are for senior and director-level roles. The job titles indicate both high responsibility and a deep level of expertise in data science and business analytics.
Titles like "Staff Data Scientist," "Director," "Head of Data Science," and "Principal Data Scientist" indicate a focus on leadership and strategic contributions rather than entry-level or even mid-level roles.

**3. Employer Diversity**

Companies vary from financial and investment firms (e.g., Selby Jennings, Algo Capital Group) to large tech and retail corporations like Walmart and Reddit.
This range highlights that high compensation is available across various industries, not limited to tech giants alone.

**4. Remote and Flexible Location Options**

Each position specifies "Anywhere" as the location, suggesting that remote work is a major perk at the high-paying level.
The flexibility for senior talent to work from anywhere aligns with recent trends in remote work, especially for roles that may not require physical presence.

**5. Time-Sensitive Demand**

Many of these roles were posted within the last few months (e.g., July to September 2023), signaling ongoing demand for highly skilled data scientists.
Quick changes in job openings might indicate either a high turnover in the data science field or an urgency to fill these high-level positions as companies continue to grow their data teams.

**6. Industry Insights**

Financial firms (Selby Jennings and Algo Capital) and large retailers (Walmart) offering top salaries suggest high-value insights derived from data science in these sectors.
Positions at Reddit and Walmart demonstrate the importance of data science for customer experience and engagement in digital and retail spaces.

**7. Career Growth and Compensation Structure**

The six-figure salaries even for roles lower on the list reflect how data science is viewed as a high-value field.
The high average salaries in these roles reflect not only the technical expertise required but also the business acumen necessary for making significant impacts on revenue and strategy.

### 2. Top Paying Data Scientist Skills
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.
```sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
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
    LIMIT 10
)

SELECT 
    top_paying_jobs.*,
    skills_dim.skills
FROM top_paying_jobs
INNER JOIN 
    skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
#### Some insights about the query:

**1. Most Common Skills:**

The top skills listed across the job roles are:

- SQL and Python (4 occurrences each)
- Java (3 occurrences)
- Spark, AWS, TensorFlow, and PyTorch (2 occurrences each)
- These skills are foundational in data science roles, with SQL and Python being particularly prominent.

**2. Average Salary by Skill:**

The highest average salaries are associated with the following skills:

- SQL: $437,500
- Python: $381,250
- Tableau and Cassandra: $375,000 each
- Hadoop: $375,000
- Other valuable skills with average salaries above $300,000 include Spark, Java, Datarobot, Keras, and Azure.

These insights suggest that data science roles prioritizing SQL, Python, and big data-related skills like Hadoop and Spark offer some of the highest salaries in the field.

### 3. Top Demanded Data Scientist Skills
This query helped me to indentify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql
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
```
#### Some insights about the query:

**1. Python as the Leading Skill**
- **Demand Count**: 10,390
- Python is the most requested skill for data scientists due to its versatility, ease of use, and extensive libraries (e.g., Pandas, NumPy, Scikit-Learn, TensorFlow) that cover everything from data manipulation and analysis to machine learning and deep learning.
- Python’s position at the top suggests that most data science roles require strong coding abilities, enabling data scientists to handle the full data pipeline, from cleaning and analysis to model building and deployment.

**2. SQL for Data Manipulation and Querying**
- **Demand Count**: 7,488
- SQL is the second most demanded skill, highlighting the importance of database querying skills in data science.
- Data scientists often work with large datasets stored in relational databases, making SQL proficiency essential for extracting, filtering, and preparing data for analysis. Its demand reflects that SQL remains foundational for data roles.

**3. R for Specialized Statistical Analysis**
- **Demand Count**: 4,674
- R is ranked third, showing its importance for roles that focus on statistical analysis, data visualization, and fields like bioinformatics or social sciences.
- R’s specialized packages (e.g., ggplot2, dplyr, caret) for statistical computing and visualizations make it a go-to choice in specific areas of data science, often complementing Python skills.

**4. Cloud Computing with AWS**
- **Demand Count**: 2,593
- AWS is in demand as data science increasingly requires cloud computing for handling large datasets, deploying models, and integrating with data engineering workflows.
- Cloud skills in AWS are valuable for end-to-end data science pipelines, from data storage (e.g., Amazon S3) and processing (e.g., AWS Lambda, EC2) to model deployment (e.g., SageMaker). Knowing AWS helps data scientists work in scalable environments.

**5. Tableau for Data Visualization and Business Intelligence**
- **Demand Count**: 2,458
- Tableau is the most in-demand data visualization tool, emphasizing the need for data scientists to communicate insights effectively, especially for business-oriented roles.
- Tableau enables non-technical stakeholders to interact with data through dashboards, making it a popular choice for data scientists who need to present findings and support data-driven decision-making.

---

#### Key Takeaways

- **Technical Breadth**: Python, SQL, and R cover core technical skills, indicating data scientists need proficiency in both general-purpose and statistical programming languages.
- **Cloud and Visualization**: AWS and Tableau emphasize scalability and communication, reflecting a shift toward operationalizing models on cloud platforms and making insights accessible through business intelligence tools.
- **Balanced Skillset for Real-World Applications**: The demand for a mix of programming, statistical, cloud, and visualization skills highlights the need for a holistic approach to the data science lifecycle to drive value through data.

These top skills underscore that data scientists need a well-rounded blend of technical, practical deployment, and visualization skills to meet industry demands and provide actionable insights.


### 4. Top Demanded Data Scientist Skills by Salary Rate
This query was used to look at the average salary associated with each skill and focuses on roles with specified salaries, excluding null values.
```sql
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
```
#### Some insights about the query:
**Key Takeaways**
 * Emerging Technologies and Data Privacy: Skills like GDPR and blockchain development (Solidity) highlight a high demand for knowledge in emerging tech and compliance.
 * Performance-Oriented Languages: Languages like Rust, Go, and Elixir stand out due to their performance in systems programming and scalability.
 * Data Science and Analytics: There’s a substantial demand for skills in analytics platforms, data visualization tools, and big data processing, underlining the value of data-driven decision-making.
 * Cloud and Infrastructure: DevOps and cloud-related tools (Airflow, Redis) are crucial for managing complex applications and workflows at scale.
 * In general, companies are investing heavily in professionals who can manage specialized data tasks, comply with privacy regulations, and streamline cloud-native and data-driven operations.

### 5. Top Optimal Skills to Learn (Based on paying-rate)
This query helped by identifying skills in high demand and associated with high average salary for Data Scientist role, concentrating on remote positions with specified salaries.
```sql
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
```
#### Some insights about the query:
#### Key Takeaways
**1. Niche and Legacy Tools Pay High**: Skills like C, Go, and Qlik, though in lower demand, offer high average salaries due to their specialized nature and limited talent pools.

**2. Cloud Skills are Essential**: BigQuery, AWS, GCP, and Snowflake highlight the shift towards cloud infrastructure for data storage, processing, and machine learning, with higher salaries for those proficient in these platforms.

**3. Machine Learning Frameworks are Highly Valued**: PyTorch and TensorFlow’s demand and salary indicate that deep learning skills are key in data science.

**4. General and Accessible Skills Show Lower Average Salaries**: Although in high demand, Python and SQL tend to have lower average salaries compared to more specialized tools. Their accessibility might contribute to a larger talent pool and, thus, lower average salaries.

This data suggests that data scientists with niche or advanced skills in cloud computing, workflow management, and machine learning can expect higher-than-average salaries, whereas more accessible and general skills maintain steady demand with more moderate salaries.

# What I Learned

With this project, there are several key aspects that I've gained valuable insights into:

- **Complex Query Crafting**:  
  I learned how to write and optimize complex queries to extract meaningful insights from large datasets. This included mastering advanced SQL techniques like joins, subqueries, and window functions, which enabled me to gather precise data and support detailed analysis.

- **Data Aggregation**:  
  I developed a strong understanding of how to effectively aggregate data using various grouping, filtering, and summarization techniques. This allowed me to condense large volumes of data into manageable and insightful summaries, which are crucial for data-driven decision-making.

- **Analytical Wizardry**:  
  By leveraging a combination of data visualization, statistical analysis, and storytelling, I enhanced my ability to translate data findings into compelling narratives. This skill was critical in transforming raw data into actionable insights that can drive business strategies and outcomes.

These insights have not only expanded my technical skill set but also strengthened my approach to problem-solving in data science projects.

# Conclusions
This are the five takeaways of the queries:

**1. Top Salaries and Roles:**

The highest-paying roles are generally senior-level, often titled "Staff Data Scientist," "Head of Data Science," or "Director of Data Science."
Two positions at the top pay over $500,000 annually, with the Staff Data Scientist/Quant Researcher at Selby Jennings leading at $550,000.

**2. Top Paying Data Scientist Skills**

The query suggest that data science roles prioritizing SQL, Python, and big data-related skills like Hadoop and Spark offer some of the highest salaries in the field.

**3. Top Demanded Skills as a Data Scientist**

The top skills underscore that data scientists need a well-rounded blend of technical, practical deployment, and visualization skills to meet industry demands and provide actionable insights.

**4. Top Demanded Data Scientist Skills by Salary Rate**

In general, companies are investing heavily in professionals who can manage specialized data tasks, comply with privacy regulations, and streamline cloud-native and data-driven operations.

**5. Top Optimal Skills to Learn (Based on paying-rate)**

This query suggests that data scientists with niche or advanced skills in cloud computing, workflow management, and machine learning can expect higher-than-average salaries, whereas more accessible and general skills maintain steady demand with more moderate salaries.