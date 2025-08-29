# SQL Project - Retail Sales Analysis

## Project Overview

This project focuses on analyzing retail sales data using MySQL. The dataset includes information on transactions such as sales date, time, customer demographics, product categories, quantities, and revenue metrics. The objective of the project is to clean the data, perform Exploratory Data Analysis and derive business insights which are would then be used to make data-driven decisions in a retail environment.

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

- Created a new database: `retail_sales`

```sql
create database retail_sales;
use retail_sales;
```
- Defined the schema for the `retail_sales` table with appropriate data types

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
- Imported the dataset records into the retail_sales table, looked at the first 10 records

```sql
select * from retail_sales limit 10;
```

---

## Data Cleaning

Performed the following cleaning steps to ensure data quality and consistency:

- Checked for records with any 'NULL' values

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
- Removed the NULL values from the table

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
- Validated the uniqueness of `transactions_id` (primary key) by checking for any duplicate records

```sql
select count(transactions_id) as duplicate_transactions 
from retail_sales group by transactions_id having count(transactions_id) > 1;
```
- Checked for invalid or inconsistent values in `quantity`, `price_per_unit`, `cogs`, `total_sale','age' columns
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
  
- Verified time format consistency using `sale_time`
```sql
select distinct sale_time from retail_sales limit 50;
```
---

## Data Exploration

Used SQL queries to understand the basic structure and characteristics of the data:

- Found the total number of records after cleaning
```sql
select count(*) as no_of_sales from retail_sales;
```
- There were 1987 records remaining after cleaning the dataset
  
- Found out the number of unique customers
```sql
select count(distinct customer_id) as no_of_customers from retail_sales;
```
- There were 155 unique customers in the table
  
- Learnt about the product categories within the dataset
```sql
select count(distinct category) as no_of_categories from retail_sales;
```
```sql
select distinct category from retail_sales;
```
- There were 3 product categories: 'Beauty', 'Clothing' and 'Electronics'
  
- Found out about the gender demographics of customers and how many fell into each gender category along with their average ages.
```sql
select gender, count(transactions_id) as no_of_customers, round(avg(age),2) as average_cust_age from retail_sales group by gender;
```
- There were 975 male customers, 1012 female customers and their average ages were around 41.

- Understood customer age demographics
  
```sql
select max(age) as oldest_cust, min(age) as youngest_cust from retail_sales;
```
- Understood the range of dates covered in the data and the total period spanned between the first and last transaction in days and years

```sql
select max(sale_date) as latest_sale_date, min(sale_date) as earliest_sale_date, 
datediff(max(sale_date), min(sale_date)) as no_of_days,
timestampdiff(year,min(sale_date),max(sale_date)) as no_of_years
from retail_sales;
```
---

## Data Analysis and Business Insights

### Sales and Revenue Analysis

**Found out the sales made on specific dates like '2022-11-05'**
```sql
select transactions_id, customer_id, category, total_sale, sale_date from retail_sales where sale_date = '2022-11-05';
```
**Calculated the total revenue each category generated on a specific date like '2022-11-05'**
```sql
select category, sum(total_sale) as total_revenue, sale_date from retail_sales where sale_date = '2022-11-05' group by category;
```
- From the results that were obtained, 'Clothes' category generated the highest revenue while 'Electronics' category generated the lowest

**Retrieved all transactions where the category is 'Beauty' between October and December 2022 to understand any seasonal impact on sales** 
```sql
select transactions_id, category, quantity, total_sale from retail_sales
where category = 'Beauty' and quantity >= 4 and sale_date between '2022-10-01' and '2022-12-01';
```
**Calculated the total revenue generated by selling 'Beauty' products during that period using a subquery**
```sql
select category, sum(total_sale) as total_revenue 
from (select transactions_id, category, quantity, total_sale from retail_sales
where category = 'Beauty' and quantity >= 4 and sale_date between '2022-10-01' and '2022-12-01') as beauty_sales 
group by category;
```

**Calculated the total revenue generated by each product category and the total number of orders?**
```sql
select category as product_category, sum(total_sale) as total_revenue, count(transactions_id) as total_orders
from retail_sales 
group by category order by sum(total_sale) desc;
```
- From the data, it was derived that the 'Electronics' category generated the highest revenue (311455), with 'Clothing' have the highest number of orders (698) whereas 'Beauty' generated the lowest revenue and had the least number of orders.

**Calculated the average price per unit for each category to better understand the revenue and order results**
```sql
select category, round(avg(price_per_unit),2) as avg_price_per_unit from retail_sales 
group by category order by round(avg(price_per_unit),2) desc;
```
- We can see that beauty products had the highest price per unit compared to the other categories which could explain why, from a financial perspective, they generated the lowest revenue and orders.
- It could be that the customers thought the price of the beauty products to be quite expensive and therefore looked for alternatives elsewhere.

**Understood customer age demographics who buy 'Beauty' products**
```sql
select category, round(avg(age),2) as average_age from retail_sales where category = 'Beauty' group by category;
```
- It was observed that the average age of the customers who bought beauty products were around 40
- The observation could be explained by the fact that as people get older, their skin starts having wrinkles, imperfections,
hairfall, discoloration of hair, so older customers would more likely buy items such as hair dyes to color their hair, 
creams to maintain their skin, hide the imperfections, oils and different gels to reduce hairfall etc.
- However, the retail store could try to entice customers with offers that provide more value compared to their competitors, make it affordable for those people so that they are more likely to buy beauty products from this store.

### Customer Behavior

**Understood which products do males and females buy the most?**

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

**Retrieving the top 5 customers based on highest total purchase amount made
```sql
select customer_id, sum(total_sale) as total_sales 
from retail_sales 
group by customer_id
order by sum(total_sale) desc
limit 5;
```
- From this data, we can understand which customers spent the most amount of money buying the products from the retail store and going forward, personalized emails could be sent to them, luring them with offers, discounts etc to ensure that they consistently purchase from this retail store itself or could recommend their inner circles thereby bringing in more customers.

### Operational Analysis

**Finding the average sales made in each month and filtering out the best selling month in each year
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
  


---

## Files in This Repository

- `retail_sales_project.sql`: All SQL queries including data cleaning, exploration, and analysis
- `retail_sales_data.csv`: Original dataset

