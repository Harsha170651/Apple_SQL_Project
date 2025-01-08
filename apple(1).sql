/* 1)Find each country and number of stores.*/
SELECT 
    country, 
    COUNT(store_id) AS Total_stores
FROM
    stores
GROUP BY country
ORDER BY Total_stores desc;