-- 10)Identify each store and best selling day based on highest qty sold?

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

        
       

