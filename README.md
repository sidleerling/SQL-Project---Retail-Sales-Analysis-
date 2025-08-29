# SQL Project - Retail Sales Analysis

## Project Overview

This project focuses on analyzing retail sales data using MySQL. The dataset includes information on transactions such as sales date, time, customer demographics, product categories, quantities, and revenue metrics. The objective of the project is to clean the data, perform Exploratory Data Analysis and derive business insights using basic to advanced SQL tools such as group by, having clause, case-when statements, Common Table Expressions (CTEs) which are then used to make data-driven decisions in a retail environment.

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
      ;
```
```sql
select * from retail_sales where age <= 0 or age > 105;
```
  
- Verified time format consistency using `sale_time`
```sql
---

## Data Exploration

Used SQL to understand the basic structure and characteristics of the data:

- Total number of records after cleaning: 1987
- Number of unique customers: 155
- Product categories: Beauty, Clothing, Electronics
- Customer age range: 18 to 64 years
- Gender distribution and average customer age
- Range of dates covered and the total period spanned in days and years

---

## Data Analysis and Business Insights

### Sales and Revenue Analysis

- **Daily Revenue**: Identified high-performing dates like `2022-11-05`
- **Category-wise Revenue**: Electronics generated the highest revenue; Beauty the least
- **Monthly Averages**: July (2022) and February (2023) had the highest average sales

### Customer Behavior

- **Average Age by Product Category**: Customers buying Beauty products are around 40 years old on average
- **Top 5 Customers**: Based on highest total sales
- **Gender-Based Preferences**: Both male and female customers prefer Beauty products

### Operational Analysis

- **Sales by Shift**: Evening shift had the highest number of transactions
- **Orders by Category**: Clothing had the highest number of orders despite lower revenue per unit
- **Unique Customers per Category**: To understand customer engagement across product types

---

## Files in This Repository

- `retail_sales_project.sql`: All SQL queries including data cleaning, exploration, and analysis
- `retail_sales_data.csv`: Original dataset

