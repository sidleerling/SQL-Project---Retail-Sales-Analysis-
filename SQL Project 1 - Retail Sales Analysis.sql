-- SQL Project 1 - Retail Sales Analysis

-- Q1. Create a database and name iT retail_sales
create database retail_sales;
use retail_sales;

-- Q2. Create the retail_sales table

create table retail_sales (
      transactions_id int primary key,
	  sale_date	date null,
	  sale_time	time null, 
	  customer_id int null, 
      gender varchar (15) null,
      age int null,
      category varchar (25) null,
	  quantity	int null, 
      price_per_unit float null, 
      cogs float null,
      total_sale float null
);

-- Q3. Retrieve the first 10 records within the retail sales table 

select * from retail_sales limit 10;

-- Data Cleaning 

-- Q4. Identifying any NULL values within the table 

select * from retail_sales 
where transactions_id is null or 
      sale_date is null or
      sale_time is null or
      customer_id is null or 
      gender is null or 
      age is null or 
      category is null or 
      quantity is null or 
      price_per_unit is null or
      cogs is null or
      total_sale is null;

-- Q5. If there are NULL values, remove them from the table 

set sql_safe_updates = 0; -- this is to temporarily disable the safe update mode which prevents us from deleting too many records

delete from retail_sales 
where transactions_id is null or 
      sale_date is null or
      sale_time is null or
      customer_id is null or 
      gender is null or 
      age is null or 
      category is null or 
      quantity is null or 
      price_per_unit is null or
      cogs is null or
      total_sale is null;

select count(*) from retail_sales;

-- Q6. Check for duplicate values within the transactions_id column of the table

select count(transactions_id) as duplicate_transactions 
from retail_sales group by transactions_id having count(transactions_id) > 1;

/* There are no duplicate transactions. 
It was important to find them because transactions_id is a primary key and has to be unique to each rows */

-- Q7. Check for inconsistent or invalid values within quantity, price_per_unit, cogs and total_sale columns

select * from retail_sales
where quantity <= 0 or
      price_per_unit <= 0 or
      cogs <= 0 or
      total_sale <= 0;
      ;

-- Q8. Check if there are any inconsistencies in the age column

select * from retail_sales where age <= 0 or age > 105;

-- Q9. Check time format to ensure they follow the HH:MM:SS format

select distinct sale_time from retail_sales limit 50;

-- Data Exploration

-- Q10. How many number of sales do we have?

select count(*) as no_of_sales from retail_sales; -- we have 1987 sales made

-- Q11. How many unique customers do we have?

select count(distinct customer_id) as no_of_customers from retail_sales; -- we have 155 customers

-- Q12. How many categories do we have?

select count(distinct category) as no_of_categories from retail_sales; -- There are 3 categories 

-- Q13. What are the different categories that we have?

select distinct category from retail_sales; -- We have Beauty, Clothing and Electronics categories within the dataset.

-- Q14. How many customers fall into each gender category and what are their average ages?

select gender, count(transactions_id) as no_of_customers, round(avg(age),2) as average_cust_age from retail_sales group by gender;
-- There are 975 male customers and 1012 female customers and their average age is around 41 which is very similar to each other. 

-- Q15. What is the age of the oldest and the youngest customer? 

select max(age) as oldest_cust, min(age) as youngest_cust from retail_sales;
-- The oldest customer is 64 years old and the youngest is 18 years old

/* Q16. What is the range of dates covered in the sales data? 
Give the very first transaction, the latest transaction, the number of days between them, 
the number of years that have passed since the first transaction */

select max(sale_date) as latest_sale_date, min(sale_date) as earliest_sale_date, 
datediff(max(sale_date), min(sale_date)) as no_of_days,
timestampdiff(year,min(sale_date),max(sale_date)) as no_of_years
from retail_sales;

-- Data Analysis and Business Key Problems 

-- Q17. Retrieve all columns for sales made on '2022-11-05'. Display transactions_id, customer_id, category, total_sale, sale_date

select transactions_id, customer_id, category, total_sale, sale_date from retail_sales where sale_date = '2022-11-05';

-- Q18. Find the total revenue each category generated on the '2022-11-05'.

select category, sum(total_sale) as total_revenue, sale_date from retail_sales where sale_date = '2022-11-05' group by category;
-- From the results, we can see that on the '2022-11-05', the sales of clothes generated the highest revenue while Electronics generated the lowest

/* Q19. Retrieve all transactions where the category is 'Beauty'
between October and December 2022. Display transactions_id, category, quantity, total_sale */

select transactions_id, category, quantity, total_sale from retail_sales
where category = 'Beauty' and quantity >= 4 and sale_date between '2022-10-01' and '2022-12-01';

-- Q20. Calculate the total revenue generated during that period using a subquery

select category, sum(total_sale) as total_revenue from (select transactions_id, category, quantity, total_sale from retail_sales
where category = 'Beauty' and quantity >= 4 and sale_date between '2022-10-01' and '2022-12-01') as beauty_sales group by category;

/* Q21. What is the total revenue generated by each category of products and the total number orders? 
Display product_category, total_revenue, total_orders and show the category with the highest revenue first */

select category as product_category, sum(total_sale) as total_revenue, count(transactions_id) as total_orders
from retail_sales 
group by category order by sum(total_sale) desc;
/* From looking at this data, we can see that the Electronics category generated the highest revenue,
Clothing having the most number of orders while Beauty category had the lowest revenue generated as well as total_orders made. */

/* Q22. What was the average price per unit for each product category? 
Display Category and price per unit and round to 2 decimal places. Sort average price from highest to lowest */

select category, round(avg(price_per_unit),2) as avg_price_per_unit from retail_sales 
group by category order by round(avg(price_per_unit),2) desc;
/* We can see that Beauty products have the highest price per unit compared to the other categories which could explain why, from a financial 
point of view, they generated the lowest revenue and total number of orders. 
It could be possible that the customers thought the price to be quite expensive and were looking for cheaper alternatives elsewhere */

-- Q23. What is the average age of customers who bought beauty products?

select category, round(avg(age),2) as average_age from retail_sales where category = 'Beauty' group by category;
-- We can see that the average age of customers who bought beauty products was around 40
/* It could be explained by the fact that as people get older, their skin starts having wrinkles, imperfections
they have hairfall, discoloration of their hair so older customers would more likely buy items such as hair dyes to color their hair, 
creams to maintain their skin, hide the imperfections, oils and different gels to reduce hairfall etc. */

-- Q24. What products do male v/s female customers buy more?

with gender_wise_purchase as (
select gender, category, count(*) as no_of_orders, 
rank() over (partition by gender order by count(*)) as r1
from retail_sales group by category, gender)
select gender, category, no_of_orders from gender_wise_purchase where r1 = 1;

-- We can see from the result above that both male and female purchase more beauty products than other categories

-- Q25. Find the average sales made in each month and list the best selling month in each year

with monthly_sales as (
     select year(sale_date) as sale_year, month(sale_date) as sale_month, round(avg(total_sale),2) as average_sale,
     rank() over (partition by year(sale_date) order by round(avg(total_sale),2) desc) as best_selling_month
     from retail_sales 
     group by year(sale_date), month(sale_date)
)
select sale_year, sale_month, average_sale from monthly_sales where best_selling_month = 1;
/* From the result, we can see that sales month 7 which is July has the highest average sale in 2022 
and month 2 which is February has the highest in 2023 */

-- Q26. Find the top 5 customers based on highest total sales 

select customer_id, sum(total_sale) as total_sales 
from retail_sales 
group by customer_id
order by sum(total_sale) desc
limit 5;

-- Q27. Find number of unique customers who purchased items from each category.

select category, count(distinct customer_id) as unique_customers from retail_sales group by category;

/* Q28. Write an SQL query to create a shift and count number of orders (For eg: Morning <= 12, Afternoon between 12 and 17, Evening > 17) 
in each shift */

with hourly_sales as (
select transactions_id, hour(sale_time) as sales_hour,
     case 
         when hour(sale_time) < 12 then 'Morning'
         when hour(sale_time) between 12 and 17 then 'Afternoon'
     else 'Evening'
     end as shift
from retail_sales)
select shift, count(transactions_id) as no_of_orders
from hourly_sales group by shift;

-- We can see that the most number of items were sold in the Evening while the least number in the Afternoon.

