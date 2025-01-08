# Apple_SQL_Project
 ![Apple Logo](https://github.com/najirh/Apple-Retail-Sales-SQL-Project---Analyzing-Millions-of-Sales-Rows/blob/main/Apple_Changsha_RetailTeamMembers_09012021_big.jpg.slideshow-xlarge_2x.jpg) Apple Retail Sales SQL Project - Analyzing Millions of Sales Rows


## Project Overview

This project is designed to showcase advanced SQL querying techniques through the analysis of over 1 million rows of Apple retail sales data. The dataset includes information about products, stores, sales transactions, and warranty claims across various Apple retail locations globally. By tackling a variety of questions, from basic to complex, you'll demonstrate your ability to write sophisticated SQL queries that extract valuable insights from large datasets.

The project is ideal for data analysts looking to enhance their SQL skills by working with a large-scale dataset and solving real-world business questions.

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
13. Identify the least selling product in each country for each year based on total units sold.
14. Calculate how many warranty claims were filed within 180 days of a product sale.
15. Determine how many warranty claims were filed for products launched in the last two years.
16. List the months in the last three years where sales exceeded 5,000 units in the USA.
17. Identify the product category with the most warranty claims filed in the last two years
18. Determine the percentage chance of receiving warranty claims after each purchase for each country.
19. Analyze the year-by-year growth ratio for each store.
20. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
21. Identify the store with the highest percentage of "Paid Repaired" claims relative to total claims filed.
22. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period
23. Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.

## Project Focus

This project primarily focuses on developing and showcasing the following SQL skills:

- **Complex Joins and Aggregations**: Demonstrating the ability to perform complex SQL joins and aggregate data meaningfully.
- **Window Functions**: Using advanced window functions for running totals, growth analysis, and time-based queries.
- **Data Segmentation**: Analyzing data across different time frames to gain insights into product performance.
- **Correlation Analysis**: Applying SQL functions to determine relationships between variables, such as product price and warranty claims.
- **Real-World Problem Solving**: Answering business-related questions that reflect real-world scenarios faced by data analysts.


## Dataset

- **Size**: 1 million+ rows of sales data.
- **Period Covered**: The data spans multiple years, allowing for long-term trend analysis.
- **Geographical Coverage**: Sales data from Apple stores across various countries.

## Conclusion

By completing this project, you will develop advanced SQL querying skills, improve your ability to handle large datasets, and gain practical experience in solving complex data analysis problems that are crucial for business decision-making. This project is an excellent addition to your portfolio and will demonstrate your expertise in SQL to potential employers.

---
