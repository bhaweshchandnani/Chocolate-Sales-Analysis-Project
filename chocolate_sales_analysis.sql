CREATE DATABASE choco_sales;
USE choco_sales;

SELECT * FROM sales;
SELECT * FROM products;
SELECT COUNT(DISTINCT product_name) from products;
DESCRIBE sales;
DESCRIBE customers;
DESCRIBE products;
DESCRIBE stores;

ALTER TABLE customers
MODIFY loyalty_member INT;

SELECT
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM sales;

SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity
FROM sales;

SELECT
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue,
    MIN(cost) AS min_cost,
    MAX(cost) AS max_cost,
    MIN(profit) AS min_profit,
    MAX(profit) AS max_profit
FROM sales;

SELECT DISTINCT category
FROM products;

SELECT DISTINCT brand
FROM products;

SELECT DISTINCT country
FROM stores;

SELECT DISTINCT gender
FROM customers;

SELECT DISTINCT store_type
FROM stores;


#..........................................................................SALES PERFORMANCE OVERVIEW


#..................................total revenue..........................

SELECT SUM(revenue) as total_revenue FROM sales;


#..................................total profit..........................

SELECT SUM(profit) as total_profit FROM sales;


#..................................total quantity sold..........................

SELECT SUM(quantity) as total_quantity FROM sales;


#.................................................................TIME BASED PERFORMANCE


#...........................................monthly sales trend................


SELECT
	order_year, order_month, order_monthname,
	SUM(revenue) as revenue
FROM sales
GROUP BY order_year, order_month, order_monthname
ORDER BY order_year;


#...........................................running monthly revenue.................
WITH total as (
	SELECT order_year, order_month,
	order_monthname, SUM(revenue) as rev
	FROM sales
	GROUP BY order_year, order_month, order_monthname
)
SELECT order_year, order_month, order_monthname, rev,
	SUM(rev) OVER(ORDER BY order_year, order_month) as run_total FROM total
	ORDER BY order_year, order_month;
    
    
#..........................................month over month revenue growth................


WITH monthly_rev as (
	SELECT order_year, order_month,
	order_monthname, SUM(revenue) as rev
	FROM sales
	GROUP BY order_year, order_month, order_monthname
),
pvs_month as (
	SELECT order_year, order_month, order_monthname, rev,
    LAG(rev) OVER( ORDER BY order_year, order_month) as pvs_growth
	FROM monthly_rev)

SELECT order_year, order_month, order_monthname, rev,
	ROUND(((rev - pvs_growth)/pvs_growth)*100,2)  AS growth_pct
	FROM pvs_month
	ORDER BY order_year, order_month;
    

#............................................................PRODUCT PERFORMANCE


#.............................................................highest revenue products

SELECT p.product_id, p.product_name, SUM(s.revenue) as revenue
FROM sales s
INNER JOIN products p
ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY revenue DESC
LIMIT 5;


#......................................................highest quantity sold products

SELECT p.product_id, p.product_name, SUM(s.quantity) AS total_qty
FROM sales s
INNER JOIN 
products p
ON p.product_id  = s.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_qty DESC
LIMIT 5;

#.......................................top 10 products rev contribution................

WITH ranks AS (
SELECT
	p.product_id, p.product_name, SUM(s.revenue) AS revenue,
    RANK() OVER (ORDER BY SUM(s.revenue) DESC) as rev_rank
	FROM sales s
	INNER JOIN products p
	ON p.product_id = s.product_id
	GROUP BY p.product_name, p.product_id
)
SELECT SUM(revenue) as top10_revenue,
	(SELECT SUM(revenue) FROM sales ) AS total_rev,
    ROUND((SUM(revenue)/(SELECT SUM(revenue) FROM sales)) *100, 2) AS contr_pct
    FROM ranks
WHERE rev_rank <= 10;


#......................................................Top 3 products in each category.........

WITH rank_table as (
	SELECT p.category, p.product_name, SUM(s.revenue) as rev,
	ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(s.revenue) DESC) AS category_rank
	from sales s
	inner join products p
	on p.product_id = s.product_id
	GROUP BY p.product_id, p.product_name, p.category
)
SELECT * FROM rank_table
WHERE category_rank <= 3;

#...........................................................................BRAND & CATEGORY ANALYSIS


#.............................................................highest revenue brand

SELECT p.brand, SUM(s.revenue) as revenue, SUM(s.profit) AS profit
FROM sales s
INNER JOIN products p
ON p.product_id = s.product_id
GROUP BY p.brand
ORDER BY revenue DESC;

#.............................................................highest revenue category

SELECT p.category, SUM(s.revenue) as revenue, SUM(s.profit) AS profit, AVG(s.profit_margin) as pm
FROM sales s
INNER JOIN products p
ON p.product_id = s.product_id
GROUP BY p.category
ORDER BY revenue DESC;


#......................................revenue pct contribtion by category

WITH cat_rev AS (
	SELECT p.category, SUM(s.revenue) as rev
    FROM sales s
    INNER JOIN products p
    ON p.product_id = s.product_id
    GROUP BY p.category
)
    
    SELECT category, rev, ROUND((rev/(SUM(rev) OVER ())) * 100,2) as pct
    FROM cat_rev
    ORDER BY pct;


#.........................................................................CUSTOMER ANALYSIS


#.....................................top 5 customers by revenue...............

SELECT c.customer_id, SUM(s.revenue) as revenue
FROM sales s
INNER JOIN customers c
ON c.customer_id = s.customer_id
GROUP BY c.customer_id
ORDER BY revenue DESC
LIMIT 5;

#.....................................revenue by customer age group.................
 

SELECT
	CASE
		WHEN age BETWEEN 18 AND 25 THEN 'EARLY'
        WHEN age BETWEEN 26 AND 35 THEN 'YOUNG'
        WHEN age BETWEEN 36 AND 45 THEN 'MID'
        WHEN age BETWEEN 46 AND 55 THEN 'SENIOR'
        ELSE 'AGED'
	END AS age_group, SUM(s.revenue) AS rev
FROM customers c INNER JOIN sales s
ON s.customer_id = c.customer_id
GROUP BY age_group
ORDER BY rev DESC;


#..............................................................STORE WISE PERFORMANCE

#.......................................store wise revenue and profit.................

SELECT
	st.store_id, st.store_name,
	SUM(s.revenue) as revenue, SUM(s.profit) AS profit
FROM sales s
INNER JOIN stores st
ON s.store_id = st.store_id
GROUP BY st.store_id, st.store_name
ORDER BY profit DESC
LIMIT 5;


#............................................................stores by profit within countries

WITH cty_store AS (
SELECT st.store_id, st.country, st.store_name, SUM(s.profit) AS total_profit,
ROW_NUMBER() OVER ( PARTITION BY st.country ORDER BY SUM(s.profit) DESC) as store_rank
FROM sales s
INNER JOIN 
stores st
ON s.store_id = st.store_id
GROUP BY st.store_id, st.country, st.store_name
)
SELECT * FROM cty_store;


#.............................................................................REGIONAL PRODUCT ANALYSIS

#....................................highest revenue product by country..................

WITH best_prod AS (
	SELECT st.country, p.product_name, SUM(s.revenue) as revenue,
    RANK() OVER (PARTITION BY st.country ORDER BY SUM(s.revenue) DESC) as rev_rank
    FROM products p
    INNER JOIN sales s
    ON s.product_id = p.product_id
    INNER JOIN stores st
    ON st.store_id = s.store_id
    GROUP BY p.product_id, p.product_name, st.country
)
SELECT * FROM best_prod
WHERE rev_rank = 1
ORDER BY revenue DESC;

