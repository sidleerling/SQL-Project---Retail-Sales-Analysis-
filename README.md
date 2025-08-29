# SQL Project - Retail Sales Analysis

## Project Overview

This SQL project involves the analysis of a retail sales dataset to uncover actionable business insights. The dataset contains 2,001 records with key fields such as transaction date and time, customer demographics, product categories, quantities sold, cost of goods, and total revenue. The project is structured in three main phases: data cleaning, exploratory data analysis (EDA), and business insight generation. Data cleaning focused on removing null values, correcting data types, and identifying invalid records. EDA helped understand customer demographics, product distribution, and sales patterns. Using advanced SQL techniques such as subqueries, Common Table Expressions (CTEs), and window functions, the analysis provided insights into category performance, seasonal trends, customer behavior, and operational efficiency. These findings could then support strategic retail decisions around pricing, promotions, inventory, and customer engagement.

---

## Dataset Description

The dataset consists of 2001 rows and 11 columns including the following:

1. `transactions_id`: Unique identifier for each sale
2. `sale_date`: Date of transaction
3. `sale_time`: Time of transaction
4. `customer_id`: Unique identifier for each customer
5. `gender`: Gender of the customer
6. `age`: Age of the customer
7. `category`: Product category (Beauty, Clothing, Electronics)
8. `quantity`: Number of units sold
9. `price_per_unit`: Price per item
10. `cogs`: Cost of goods sold
11. `total_sale`: Total revenue from the transaction

---

## Table of Contents

1. [Database and Table Setup](#database-and-table-setup)
2. [Data Cleaning](#data-cleaning)
3. [Data Exploration](#data-exploration)
4. [Data Analysis and Business Insights](#data-analysis-and-business-insights)

---

## Database and Table Setup

**1. Created a new database: `retail_sales`**

```sql
create database retail_sales;
use retail_sales;
```
**2. Defined the schema for the `retail_sales` table with appropriate data types**

```sql
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
```
**3. Imported the dataset records into the retail_sales table, looked at the first 10 records**

```sql
select * from retail_sales limit 10;
```
---

## Data Cleaning

**4. Checked for records with any 'NULL' values**

```sql
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
```
**5. Removed the NULL values from the table**

```sql
set sql_safe_updates = 0;
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
```
**6. Validated the uniqueness of `transactions_id` (primary key) by checking for any duplicate records**

```sql
select count(transactions_id) as duplicate_transactions 
from retail_sales group by transactions_id having count(transactions_id) > 1;
```
**7. Checked for invalid or inconsistent values in `quantity`, `price_per_unit`, `cogs`, `total_sale`,`age` columns**
```sql
select * from retail_sales
where quantity <= 0 or
      price_per_unit <= 0 or
      cogs <= 0 or
      total_sale <= 0;
```
```sql
select * from retail_sales where age <= 0 or age > 105;
```
  
**8. Verified time format consistency using `sale_time`**
```sql
select distinct sale_time from retail_sales limit 50;
```
---

## Data Exploration

Used SQL queries to understand the basic structure and characteristics of the data:

**9. Found the total number of records after cleaning**
```sql
select count(*) as no_of_sales from retail_sales;
```
- There were 1987 records remaining after cleaning the dataset
  
**10. Found out the number of unique customers**
```sql
select count(distinct customer_id) as no_of_customers from retail_sales;
```
- There were 155 unique customers in the table
  
**11. Learnt about the product categories within the dataset**
```sql
select count(distinct category) as no_of_categories from retail_sales;
```
```sql
select distinct category from retail_sales;
```
- There were 3 product categories: 'Beauty', 'Clothing' and 'Electronics'
  
**12. Found out about the gender demographics of customers and how many fell into each gender category along with their average ages.**
```sql
select gender, count(transactions_id) as no_of_customers, round(avg(age),2) as average_cust_age from retail_sales group by gender;
```
- There were 975 male customers, 1012 female customers and their average ages were around 41.

**13. Understood customer age demographics**
  
```sql
select max(age) as oldest_cust, min(age) as youngest_cust from retail_sales;
```
**14. Understood the range of dates covered in the data and the total period spanned between the first and last transaction in days and years**

```sql
select max(sale_date) as latest_sale_date, min(sale_date) as earliest_sale_date, 
datediff(max(sale_date), min(sale_date)) as no_of_days,
timestampdiff(year,min(sale_date),max(sale_date)) as no_of_years
from retail_sales;
```
---

## Data Analysis and Business Insights

### Sales and Revenue Analysis

**15. Found out the sales made on specific dates like '2022-11-05'**
```sql
select transactions_id, customer_id, category, total_sale, sale_date from retail_sales where sale_date = '2022-11-05';
```
**16. Calculated the total revenue each category generated on a specific date like '2022-11-05'**
```sql
select category, sum(total_sale) as total_revenue, sale_date from retail_sales where sale_date = '2022-11-05' group by category;
```
- From the results that were obtained, 'Clothes' category generated the highest revenue while 'Electronics' category generated the lowest

**17. Retrieved all transactions where the category is 'Beauty' between October and December 2022 to understand any seasonal impact on sales** 
```sql
select transactions_id, category, quantity, total_sale from retail_sales
where category = 'Beauty' and quantity >= 4 and sale_date between '2022-10-01' and '2022-12-01';
```
**18. Calculated the total revenue generated by selling 'Beauty' products during that period using a subquery**
```sql
select category, sum(total_sale) as total_revenue 
from (select transactions_id, category, quantity, total_sale from retail_sales
where category = 'Beauty' and quantity >= 4 and sale_date between '2022-10-01' and '2022-12-01') as beauty_sales 
group by category;
```

**19. Calculated the total revenue generated by each product category and the total number of orders?**
```sql
select category as product_category, sum(total_sale) as total_revenue, count(transactions_id) as total_orders
from retail_sales 
group by category order by sum(total_sale) desc;
```
- From the data, it was derived that the 'Electronics' category generated the highest revenue (311455), with 'Clothing' have the highest number of orders (698) whereas 'Beauty' generated the lowest revenue and had the least number of orders.

**20. Calculated the average price per unit for each category to better understand the revenue and order results**
```sql
select category, round(avg(price_per_unit),2) as avg_price_per_unit from retail_sales 
group by category order by round(avg(price_per_unit),2) desc;
```
- We can see that beauty products had the highest price per unit compared to the other categories which could explain why, from a financial perspective, they generated the lowest revenue and orders.
- It could be that the customers thought the price of the beauty products to be quite expensive and therefore looked for alternatives elsewhere.

**21. Understood customer age demographics who buy 'Beauty' products**
```sql
select category, round(avg(age),2) as average_age from retail_sales where category = 'Beauty' group by category;
```
- It was observed that the average age of the customers who bought beauty products were around 40
- The observation could be explained by the fact that as people get older, their skin starts having wrinkles, imperfections,
hairfall, discoloration of hair, so older customers would more likely buy items such as hair dyes to color their hair, 
creams to maintain their skin, hide the imperfections, oils and different gels to reduce hairfall etc.
- However, the retail store could try to entice customers with offers that provide more value compared to their competitors, make it affordable for those people so that they are more likely to buy beauty products from this store.

### Customer Behavior

**22. Understood which products do males and females buy the most**

```sql
with gender_wise_purchase as (
select gender, category, count(*) as no_of_orders, 
rank() over (partition by gender order by count(*)) as r1
from retail_sales group by category, gender)
select gender, category, no_of_orders from gender_wise_purchase where r1 = 1;
```
- It was observed that in this dataset, both males and females bought more 'beauty' products than any other category.
- It is understandable because beauty products are linked to self-care, confidence and personal expression
- Given that we know that there is a high demand for beauty product, it would be useful to lower to price per unit in order to lure potential customers, turn them into loyal customers in an attempt to generate more sales. Beauty products have a high potential of generating more revenue compared to other products.

**23. Retrieving the top 5 customers based on highest total purchase amount made**
```sql
select customer_id, sum(total_sale) as total_sales 
from retail_sales 
group by customer_id
order by sum(total_sale) desc
limit 5;
```
- From this data, we can understand which customers spent the most amount of money buying the products from the retail store and going forward, personalized emails could be sent to them, luring them with offers, discounts etc to ensure that they consistently purchase from this retail store itself or could recommend their inner circles thereby bringing in more customers.

### Operational Analysis

**24. Finding the average sales made in each month and filtering out the best selling month in each year**
```sql
with monthly_sales as (
     select year(sale_date) as sale_year, month(sale_date) as sale_month, round(avg(total_sale),2) as average_sale,
     rank() over (partition by year(sale_date) order by round(avg(total_sale),2) desc) as best_selling_month
     from retail_sales 
     group by year(sale_date), month(sale_date)
)
select sale_year, sale_month, average_sale from monthly_sales where best_selling_month = 1;
```
- It was observed that sales months July had the highest average sale in 2022 while February had the highest sales in 2023.
- High sales in July in 2022 could be explained by the "Mid Summer Clearance" sales run by retailers to clear our their seasonal inventory which could boost sales across all product categories. The sales could also be the result of weather-driven behavior as summer months often drive higher foot traffic in these retail stores especially, especially for beauty, lifestyle items
- High sales in February in 2023 could be explained by the demand for beauty and clothing products during Valentine's day or strategic promotions carried out by retail stores during February or if a store had inventory issues in January, it could have been fixed in February resulting in a rise in sales
  
**25. Finding the total number of orders made in each shift** 
```sql
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
```
- It was observed that the most number of items were sold in the Evening while the least number in the Afternoon
- This could be explained by the fact that during weekdays, people would have work the entire day and once they finish work, they might head to the retail stores of malls to buy products or on weekends, they would probably plan on going shopping in the evening, eat at a restaurant or watch a movie instead of the afternoon where it is often sunny and hot, especially during Summer.
---

## Files in This Repository

- `SQL Project 1 - Retail Sales Analysis.sql`: All SQL queries including data cleaning, exploration, and analysis
- `SQL - Retail Sales Analysis.csv`: Original dataset

