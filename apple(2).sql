/* 2)What is the total number of units sold by each store?*/

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