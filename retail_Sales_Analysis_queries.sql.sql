-- Create database Sql_project_p1

CREATE DATABASE Sql_project_p1;

-- create table retail_sales

CREATE TABLE retail_sales 
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,
				customer_id	INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),
				quantity INT,
				price_per_unit FLOAT,	
				cogs FLOAT,
				total_sale FLOAT
			);

SELECT *
FROM retail_sales;

-- Determine the total number of records in the dataset.

SELECT COUNT(*)
FROM retail_sales;

-- Find out how many unique customers are in the dataset.

SELECT COUNT( DISTINCT (customer_id) )
FROM retail_sales;

-- Check for any null values in the dataset and delete records with missing data.
SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR category IS NULL
OR quantity IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- imputation of correct details or delete( in this case we are deleting)

DELETE FROM retail_sales
WHERE  sale_date IS NULL
	OR sale_time IS NULL
	OR customer_id IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantity IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;


-- Data Exploratory

-- How many sales we  have

SELECT COUNT(*) AS Total_sales
FROM retail_sales;


-- How many Distinct customers we have

SELECT COUNT (DISTINCT customer_id) AS total_distinct_customers
FROM retail_sales;

-- How many Distinct category we have

SELECT DISTINCT category AS Distinct_category
FROM retail_sales;

-- Data Analysis & Business key problems and answer

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05.
-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
-- Write a SQL query to calculate the total sales (total_sale) for each category.
-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Write a SQL query to find the top 5 customers based on the highest total sales.
-- Write a SQL query to find the number of unique customers who purchased items from each category.
-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).

-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05.

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than  or equals 4 in the month of Nov-2022.

SELECT *
FROM  retail_sales
WHERE  category = 'Clothing'
AND quantity >= 4
AND TO_CHAR (sale_date, 'YYYY-MM') = '2022-11';

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT 
	category,
	SUM (total_sale) AS Total_sale,
	COUNT (total_sale) AS total_sales_count
FROM retail_sales
GROUP BY 1;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT  ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT  *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(transactions_id)
FROM retail_sales
GROUP  BY 1, 2
ORDER BY 1;

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	year,
	month,
	avg_sales
FROM
		(
		SELECT 
			EXTRACT (YEAR FROM sale_date) AS year,
			EXTRACT (MONTH FROM sale_date) AS month,
			AVG(total_sale) AS avg_sales,
			RANK()OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
		FROM retail_sales
		GROUP BY 1, 2) AS T2
WHERE rank = 1;
-- ORDER  BY 1, 3 DESC;

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.

SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
	category,
	COUNT (DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP  BY 1;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
WITH hourly_sale
	AS
	(
	SELECT
		*,
		CASE
			WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
	)
	SELECT 
		shift,
		COUNT(*) AS total_orders
	FROM hourly_sale
	GROUP BY shift;

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
--  Using Sub queries

SELECT 
	shift,
	COUNT (*) AS Total_order
FROM
(
	SELECT
		*,
		CASE
			WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END AS shift
	FROM retail_sales
) AS T2
GROUP BY shift;

-- end of project