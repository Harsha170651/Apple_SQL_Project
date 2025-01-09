# My Experience with the Apple Retail Sales SQL Project 
 ![Uploading Apple_Changsha_RetailTeamMembers_09012021_big.jpg.slideshow-xlarge_2x.jpg…]() Retail Sales SQL Project - Analyzing Millions of Sales Rows


## Project Overview

I successfully completed the Apple Retail Sales SQL Project, where I analyzed over 1 million rows of Apple retail sales data. This experience allowed me to showcase and refine my expertise in SQL by addressing real-world business challenges using advanced querying techniques.

## Entity Relationship Diagram (ERD)

![Screenshot 2025-01-08 at 10 52 20 AM 2](https://github.com/user-attachments/assets/0bbdc496-8cf7-4d25-baa5-677f2dc8e2b6)

## Database Schema

The project uses five main tables:

1. **stores**: Contains information about Apple retail stores.
   - `store_id`: Unique identifier for each store.
   - `store_name`: Name of the store.
   - `city`: City where the store is located.
   - `country`: Country of the store.

2. **category**: Holds product category information.
   - `category_id`: Unique identifier for each product category.
   - `category_name`: Name of the category.

3. **products**: Details about Apple products.
   - `product_id`: Unique identifier for each product.
   - `product_name`: Name of the product.
   - `category_id`: References the category table.
   - `launch_date`: Date when the product was launched.
   - `price`: Price of the product.

4. **sales**: Stores sales transactions.
   - `sale_id`: Unique identifier for each sale.
   - `sale_date`: Date of the sale.
   - `store_id`: References the store table.
   - `product_id`: References the product table.
   - `quantity`: Number of units sold.

5. **warranty**: Contains information about warranty claims.
   - `claim_id`: Unique identifier for each warranty claim.
   - `claim_date`: Date the claim was made.
   - `sale_id`: References the sales table.
   - `repair_status`: Status of the warranty claim (e.g., Paid Repaired, Warranty Void).

## SQL Questions with Answers:

1. Find the number of stores in each country.
   ``` sql
   SELECT 
    country, COUNT(store_id) AS Total_stores
FROM  stores
GROUP BY country
ORDER BY Total_stores desc;
```

2. Calculate the total number of units sold by each store.
``` sql
SELECT 
    sa.store_id,
    st.store_name,
    SUM(sa.quantity) AS total_unit_sold
FROM
    sales AS sa
        JOIN
    stores AS st ON st.store_id = sa.store_id
GROUP BY sa.store_id , st.store_name
ORDER BY SUM(sa.quantity) DESC;
```
3.  Identify how many sales occurred in December 2023
  ``` sql
SELECT 
    COUNT(sale_id) AS total_sales
FROM
    sales
WHERE
    YEAR(sale_date) = '2023'
        AND MONTH(sale_date) = '12';
```
4. Determine how many stores have never had a warranty claim filed.
  ``` sql
SELECT 
    COUNT(*) AS total_stores
FROM
    stores
WHERE
    store_id NOT IN (SELECT DISTINCT
            store_id
        FROM
            sales AS s
                RIGHT JOIN
            warranty AS w ON w.sale_id = s.sale_id)
```
5. Calculate the percentage of warranty claims marked as "Warranty Void".
  ``` sql
SELECT 
    ROUND(COUNT(claim_id)/ (select count(*) from warranty) *  100, 1) AS warranty_void_percentage
FROM
    warranty
WHERE
    repair_status = 'warranty void'
```
6. Identify which store had the highest total units sold in the last year.
``` sql
SELECT 
    sa.store_id, st.store_name, SUM(sa.quantity) AS total_sales
FROM
    sales AS sa
        JOIN
    stores AS st ON st.store_id = sa.store_id
WHERE
    sale_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY sa.store_id , st.store_name
ORDER BY SUM(sa.quantity) DESC
LIMIT 1;
```
7. Count the number of unique products sold in the last year.
 ``` sql
SELECT DISTINCT
    COUNT(s.product_id) AS total_product, p.product_name
FROM
    sales AS s
        JOIN
    products AS p ON p.product_id = s.product_id
WHERE
    sale_date >= CURDATE() - INTERVAL 1 YEAR
GROUP BY product_name
ORDER BY COUNT(s.product_id) DESC
lIMIT 1;
```
8. Find the average price of products in each category.
  ``` sql
SELECT 
    c.category_id,
    c.category_name,
    round(AVG(p.price),1) AS Avg_price
FROM 
    products AS p
JOIN 
    category AS c
ON 
    c.category_id = p.category_id
GROUP BY 
    c.category_id, c.category_name
ORDER BY 
    avg_price DESC;
```
9. How many warranty claims were filed in 2020?
  ``` sql
SELECT 
    COUNT(claim_id) AS warranty_claims
FROM
    warranty
WHERE
    YEAR(claim_date) = 2020;
```
10. For each store, identify the best-selling day based on highest quantity sold.
   ``` sql
SELECT 
    s.store_id,
    s.store_name,
    DATE_FORMAT(sa.sale_date, '%Y-%m-%d') AS best_selling_day,
    sa.quantity AS highest_qty_sold
FROM 
    sales AS sa
JOIN 
    stores AS s
ON 
    sa.store_id = s.store_id
WHERE 
    (sa.store_id, sa.quantity) IN (
        SELECT 
            store_id, 
            MAX(quantity) AS max_qty
        FROM 
            sales
        GROUP BY 
            store_id
    )
ORDER BY 
    s.store_id;
```
11. Identify the least selling product in each country for each year based on total units sold.
  ``` sql
WITH product_rank
AS
(
SELECT 
	st.country,
	p.product_name,
	SUM(s.quantity) as total_qty_sold,
	RANK() OVER(PARTITION BY st.country ORDER BY SUM(s.quantity)) as Rank_num
FROM sales as s
JOIN 
stores as st
ON s.store_id = st.store_id
JOIN
products as p
ON s.product_id = p.product_id
GROUP BY st.country,p.product_name
)
SELECT 
* 
FROM product_rank
WHERE Rank_num = 1
```
12. Calculate how many warranty claims were filed within 180 days of a product sale.
  ``` sql
SELECT 
    COUNT(*) AS total_claims
FROM
    warranty AS w
        LEFT JOIN
    sales AS s ON s.sale_id = w.sale_id
WHERE
    w.claim_date - sale_date <= 180;
```
13. Determine how many warranty claims were filed for products launched in the last two years.
  ``` sql
SELECT 
    p.product_name,
    COUNT(w.claim_id) AS no_claim,
    COUNT(s.sale_id) AS no_sales
FROM
    warranty AS w
        RIGHT JOIN
    sales AS s ON s.sale_id = w.sale_id
        JOIN
    products AS p ON p.product_id = s.product_id
WHERE
    p.launch_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
GROUP BY p.product_name
HAVING COUNT(w.claim_id) > 0;
```
14. List the months in the last three years where sales exceeded 5,000 units in the USA.
  ``` sql
SELECT 
    DATE_FORMAT(s.sale_date, '%m-%Y') AS month,
    SUM(s.quantity) AS total_unit_sold
FROM
    sales AS s
        JOIN
    stores AS st ON s.store_id = st.store_id
WHERE
    st.country = 'USA'
        AND s.sale_date >= DATE_SUB(CURDATE(), INTERVAL 3 YEAR)
GROUP BY month
HAVING SUM(s.quantity) > 5000;
```
15. Identify the product category with the most warranty claims filed in the last two years
  ``` sql
SELECT 
    c.category_name, COUNT(w.claim_id) AS total_claims
FROM
    warranty AS w
        LEFT JOIN
    sales AS s ON w.sale_id = s.sale_id
        JOIN
    products AS p ON p.product_id = s.product_id
        JOIN
    category AS c ON c.category_id = p.category_id
WHERE
    w.claim_date >= DATE_SUB(CURDATE(), INTERVAL 2 YEAR)
GROUP BY c.category_name;
```
16. Determine the percentage chance of receiving warranty claims after each purchase for each country.
   ``` sql
SELECT 
    country,
    total_unit_sold,
    total_claim,
    COALESCE((total_claim * 100.0) / total_unit_sold,
            0) AS risk
FROM
    (SELECT 
        st.country,
            SUM(s.quantity) AS total_unit_sold,
            COUNT(w.claim_id) AS total_claim
    FROM
        sales AS s
    JOIN stores AS st ON s.store_id = st.store_id
    LEFT JOIN warranty AS w ON w.sale_id = s.sale_id
    GROUP BY st.country) AS t1
ORDER BY risk DESC;
```
17. Analyze the year-by-year growth ratio for each store.
``` sql
WITH yearly_sales AS (
    SELECT 
        s.store_id,
        st.store_name,
        YEAR(s.sale_date) AS year,
        SUM(s.quantity * p.price) AS total_sale
    FROM sales AS s
    JOIN products AS p
        ON s.product_id = p.product_id
    JOIN stores AS st
        ON st.store_id = s.store_id
    GROUP BY s.store_id, st.store_name, year
    ORDER BY st.store_name, year
),
growth_ratio AS (
    SELECT 
        store_name,
        year,
        LAG(total_sale) OVER (PARTITION BY store_name ORDER BY year) AS last_year_sale,
        total_sale AS current_year_sale
    FROM yearly_sales
)
SELECT 
    store_name,
    year,
    last_year_sale,
    current_year_sale,
    ROUND(((current_year_sale - last_year_sale) / last_year_sale) * 100, 3) AS growth_ratio
FROM growth_ratio
WHERE 
    last_year_sale IS NOT NULL
    AND year <> YEAR(CURDATE());
```
18. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
  ``` sql
SELECT 
    CASE
        WHEN p.price < 500 THEN 'Less Expensive Product'
        WHEN p.price BETWEEN 500 AND 1000 THEN 'Mid-Range Product'
        ELSE 'Expensive Product'
    END AS price_segment,
    COUNT(w.claim_id) AS total_claim
FROM
    warranty AS w
        LEFT JOIN
    sales AS s ON w.sale_id = s.sale_id
        JOIN
    products AS p ON p.product_id = s.product_id
WHERE
    w.claim_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR)
GROUP BY price_segment;
```
19. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period
   ``` sql
WITH monthly_sales AS (
    SELECT 
        s.store_id,
        YEAR(s.sale_date) AS year,
        MONTH(s.sale_date) AS month,
        SUM(p.price * s.quantity) AS total_revenue
    FROM sales AS s
    JOIN products AS p
        ON s.product_id = p.product_id
    WHERE s.sale_date >= DATE_SUB(CURDATE(), INTERVAL 4 YEAR) -- Filter for the past 4 years
    GROUP BY s.store_id, year, month
    ORDER BY s.store_id, year, month
)
SELECT 
    store_id,
    month,
    year,
    total_revenue,
    SUM(total_revenue) OVER (PARTITION BY store_id ORDER BY year, month) AS running_total
FROM monthly_sales;
```
20. Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.
``` sql
SELECT 
    p.product_name,
    CASE
        WHEN
            s.sale_date BETWEEN p.launch_date AND DATE_ADD(p.launch_date,
                INTERVAL 6 MONTH)
        THEN
            '0-6 month'
        WHEN
            s.sale_date BETWEEN DATE_ADD(p.launch_date,
                INTERVAL 6 MONTH) AND DATE_ADD(p.launch_date,
                INTERVAL 12 MONTH)
        THEN
            '6-12 month'
        WHEN
            s.sale_date BETWEEN DATE_ADD(p.launch_date,
                INTERVAL 12 MONTH) AND DATE_ADD(p.launch_date,
                INTERVAL 18 MONTH)
        THEN
            '12-18 month'
        ELSE '18+ month'
    END AS plc,
    SUM(s.quantity) AS total_qty_sale
FROM
    sales AS s
        JOIN
    products AS p ON s.product_id = p.product_id
GROUP BY p.product_name , plc
ORDER BY p.product_name , total_qty_sale DESC;
```
## Key Achievements:

- **Database Analysis**:
* Explored a dataset covering multiple years of sales transactions, warranty claims, product details, and store information.
* Worked with a relational database schema comprising five interconnected tables: stores, category, products, sales, and warranty.
  
- **Complex Query Design**:
* Created advanced SQL queries to solve business problems like identifying the highest-selling stores, analyzing sales trends, and calculating warranty claim rates.
* Applied techniques such as window functions, CTEs, and correlation analysis to generate actionable insights.

- **Insights Uncovered**:
* Identified sales performance by store and product categories to guide inventory and marketing strategies.
* Analyzed warranty claims to improve product quality and customer satisfaction.
* Discovered sales trends segmented by product lifecycle (0-6 months, 6-12 months, etc.), enabling targeted promotional strategies.

- **Optimization and Scalability**:
* Optimized queries for large-scale datasets to ensure efficient performance.
* Used advanced JOINs, aggregations, and indexing techniques for scalability.
  
- **Business Impact**:
* Designed queries to calculate year-on-year growth, highlight sales peaks, and monitor warranty claim risks.
* Analyzed product pricing and warranty claims, contributing to informed decision-making about product launches and warranties.
  
## Skills Gained:
* Advanced SQL Proficiency: Mastery in designing complex queries, using CTEs, window functions, and aggregations.
* Data Segmentation: Expertise in dividing data into meaningful segments for detailed analysis.
* Correlation Analysis: Developed insights into relationships between key variables, like product price and warranty claim frequency.
* Problem-Solving: Tackled real-world business questions and provided data-driven recommendations.

## Conclusion:
Completing this project enhanced my confidence in handling large-scale datasets and solving complex analytical problems. It also strengthened my ability to derive insights that drive business decisions. This experience positions me as a skilled data analyst capable of leveraging SQL to tackle real-world challenges effectively.

---
