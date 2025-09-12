-- Cafe Sales Exploratory Analysis

-- Items sold by year
SELECT Item, Transaction_year, SUM(Quantity)
FROM dirty_cafe_sales_staging
GROUP BY Item, Transaction_year
ORDER BY Transaction_year;

-- Most popular items
SELECT Item,  SUM(Quantity) AS Quantity_sold
FROM dirty_cafe_sales_staging
GROUP BY Item
ORDER BY SUM(Quantity) DESC; 

-- Busiest Months ( by year)
SELECT Transaction_month, Transaction_year,  SUM(Quantity) AS Quantity_sold
FROM dirty_cafe_sales_staging
GROUP BY Transaction_month, Transaction_year
ORDER BY SUM(Quantity) DESC; 

-- Revenue by Month & Year
SELECT Transaction_month, Transaction_year,  SUM(`Total Spent`) AS Revenue
FROM dirty_cafe_sales_staging
GROUP BY Transaction_month, Transaction_year
ORDER BY Revenue DESC; 

-- Busiest day of the week (Revenue and Quantity)
SELECT Transaction_day,  SUM(`Total Spent`) AS Revenue, SUM(Quantity) AS Quantity_sold
FROM dirty_cafe_sales_staging
GROUP BY Transaction_day
ORDER BY Revenue DESC; 

-- Most popular day for takeaways 
SELECT Transaction_day, SUM(Quantity) AS Quantity_sold, Location
FROM dirty_cafe_sales_staging
WHERE Location = 'Takeaway'
GROUP BY Transaction_day
ORDER BY Quantity_sold DESC;

-- In-store vs Takeaway
SELECT Location, SUM(`Total Spent`) AS Revenue, SUM(Quantity) AS Quantity_sold
FROM dirty_cafe_sales_staging
WHERE Location = 'Takeaway' OR Location = 'In-store'
GROUP BY Location
ORDER BY Quantity_sold DESC;

SELECT *
FROM dirty_cafe_sales_staging;