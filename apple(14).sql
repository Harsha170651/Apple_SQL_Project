-- 14)List the months in the last 3 years where sales exceeded 5000 units from usa.

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
