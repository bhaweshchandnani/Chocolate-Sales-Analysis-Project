# Chocolate-Sales-Analysis-Project
Chocolate sales analysis using Pandas, MySQL and Power BI to understand sales, profit, discounts, products and country-wise performance.

## Overview
I used Python for basic data checking and preparation, SQL for analysis, and Power BI to create the dashboard and understand the business insights.

## Tools Used

* Python
* Pandas
* MySQL
* Power BI
* DAX

## 1. Python / Pandas

Before working in SQL, I used Pandas to understand and prepare the data.

Things I checked:

* head() – to see the first few rows
* shape – to check number of rows and columns
* info() – to check columns and data types
* isnull() – to check missing values
* duplicated() – to check duplicate data
* nunique() – to check unique values
* Converted date columns using pd.to_datetime()  
* Used  .dt.year   and   .dt.month   to get year and month from dates

After checking and preparing the data, I moved it to MySQL for further analysis.

## 2. SQL

I used MySQL to answer different business questions from the data.

### SQL topics I used

* SELECT
* WHERE
* GROUP BY
* ORDER BY
* Aggregate functions
* JOINs
* CASE
* CTEs
* Window functions
* RANK()  
* ROW_NUMBER()  
* LAG()  
* Running totals

## Some Questions I Analysed

* What is the total revenue, total profit and total quantity sold?
* What is the monthly sales trend?
* What is the running monthly revenue?
* How does revenue grow month over month?
* Which products generate the highest revenue?
* Which products have the highest quantity sold?
* What percentage of total revenue comes from the top 10 products?
* What are the top 3 products in each category?
* Which brand generates the highest revenue?
* Which category generates the highest revenue?
* What is the revenue contribution percentage of each category?
* Who are the top 5 customers by revenue?
* How does revenue vary across customer age groups?
* Which stores generate the highest revenue and profit?
* Which stores are most profitable within each country?
* Which product generates the highest revenue in each country?



## 3. Power BI

I used Power BI to create an interactive dashboard from the data analyzed in SQL.

### Page 1 – Overview

* Total Revenue
* Total Profit
* Total Quantity
* Total Customers
* Total Stores
* Monthly trend
* Revenue by Product
* Revenue by Category
* Revenue by Brand
* Filters

### Page 2 – Product Analysis

* Product performance
* Brand analysis
* Category analysis
* Cocoa percentage analysis
* KPIs
* Filters

### Page 3 – Market Analysis

* Revenue by Country
* Revenue by Store Type
* Discount analysis
* KPIs
* Filters

### Page 4 – Findings & Recommendations

This page contains the main findings from my analysis and the recommendations based on them.

## Key Findings

### 1. Discount and Sales

* Higher discount is associated with higher quantity sold.
* Revenue, profit and profit margin also increase with higher discounts.

### 2. Product Revenue

* Top 10 products contribute around 10% of total revenue.
* This means revenue is not mainly dependent on a few products.

### 3. Country Performance

* Revenue is different across countries.
* Profit margin is almost similar across countries, around 40%.

## Recommendations

* Use discounts on selected products and maintain enough stock during offers.
* Rotate offers across different products instead of focusing only on top-selling products.
* Promote products with lower sales where there is growth potential.
* Focus advertising and customer acquisition on lower-revenue countries.
* Use limited first-time offers and check whether they actually improve sales.

## Project Outcome
Analyzed chocolate sales data using Python, SQL and Power BI to understand sales, profit, products, customers, stores and countries.
Created an interactive dashboard and identified key business findings related to discounts, product revenue and country performance.

## Skills Demonstrated
* Pandas
* MySQL
* Power BI
* Data Analysis
* Business Insights
