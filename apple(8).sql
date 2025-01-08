-- 8)What is the average price of products in each category?

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
