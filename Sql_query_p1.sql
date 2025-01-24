--SQL Retail Sale Analysis P1
create database Project_p2 

--Create Table
drop table if exists retail_sale;
create Table retail_sale
			( transactions_id int primary key,	
			  sale_date date,
			  sale_time	time,
			  customer_id int,
			  gender varchar(15),	
			  age int,
			  category varchar(50),
			  quantiy int,
			  price_per_unit float,	
			  cogs float,
			  total_sale float
			) 

select * from retail_sale

--Count The Row of this Table
Select count(*) from retail_sale

--
select * from retail_sale
where sale_time is Null


--- Data Cleaning
-- check the null values
select * from retail_sale
where 
	transactions_id is Null
	or
	sale_date is Null
	or
	sale_time is Null
	or
	customer_id is Null
	or 
	gender is Null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null;
	
-- Deleted the Row where Having Null Values
Delete from retail_sale
where 
	transactions_id is Null
	or
	sale_date is Null
	or
	sale_time is Null
	or
	customer_id is Null
	or 
	gender is Null
	or
	category is null
	or
	quantiy is null
	or
	cogs is null
	or
	total_sale is null;
	
-- Data Exploration

-- How many sales we have?
Select count(*) as total_sales from retail_sale

-- How many unique customer we have?
Select count(distinct customer_id) from retail_sale

-- How many unique category we have?
Select count(distinct category) from retail_sale

-- Types of category
Select distinct category from retail_sale

-- Data Analysis & Business Key Problem & Answer

-- Q.1  Write a SQL query to retrieve all columns for sales made on '2022-11-05
--Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category
--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

-- Q.1  Write a SQL query to retrieve all columns for sales made on '2022-11-05
Select * From retail_sale
Where sale_date = '2022-11-05'

--Q.2 Write a SQL query to retrieve all transactions where the category is 
--'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
Select * From retail_sale
Where category = 'Clothing'
	and
	to_char(sale_date,'yyyy-mm')='2022-11'
	and
	quantiy >=4;
	
--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
Select 
Category,
sum(total_sale) as net_sale,
count(*) as total_orders
from retail_sale
Group by 1

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
Select 
round(avg(age),2) as avg_age
from retail_sale
where category = 'Beauty'

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
select 
*
from retail_sale
where total_sale >'1000'

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
category,
gender, 
count(*) as total_trans
from retail_sale
group by 
category,
gender
order by 1

 --Q.7 Write a SQL query to calculate the average sale for each month.
 --Find out best selling month in each year
 
 select 
 Extract(YEAR from sale_date) as year,
 Extract(MONTH from sale_date) as month,
avg(total_sale)as avg_tot_sale
 from retail_sale
 Group by 1, 2
 order by 1,2


 select
 year, 
 month,
 avg_tot_sale
 from 
 (
 SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    ROUND(CAST(AVG(total_sale) as numeric), 2) AS avg_tot_sale,
	Rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
FROM retail_sale
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(MONTH FROM sale_date)
) as t1
where rank = 1
ORDER BY year, month, avg_tot_sale desc

--Q.8 Write a SQL query to find the top 5 customers based on the highest 
--total sales.

select customer_id,
sum(total_sale) as total_sale
 from
 retail_sale
 Group By 1
 order by 2 desc
 limit 5
 
 --Q.9 Write a SQL query to find the number of unique customers who 
 --purchased items from each category.
 
 select 
 category,
 count(distinct customer_id) as cnt_uniqe_cst
 from retail_sale
 Group by category
 
 --Q.10 Write a SQL query to create each shift and number of orders (Example 
  --Morning <12, Afternoon Between 12 & 17, Evening >17)
  
 select * from retail_sale
 
 with hourly_sale
 as
 (
 Select *, 
 case
 	when Extract(hour from sale_time) < 12 then 'Morning'
	when Extract(hour from sale_time) Between 12 and 17 then 'Afternoon'
	else 'Evevning'
End as shift
from retail_sale
)
Select 
shift,
Count(*) as total_orders
from hourly_sale
Group by shift
 
 Select Extract (Hour From Current_Time)
