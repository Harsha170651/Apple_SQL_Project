-- 11)Identify least selling product of each country for each year based on total unit sold?


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