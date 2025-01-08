/* 3)How many sales occurred in December 2023?*/

SELECT 
    COUNT(sale_id) AS total_sales
FROM
    sales
WHERE
    YEAR(sale_date) = '2023'
        AND MONTH(sale_date) = '12';
