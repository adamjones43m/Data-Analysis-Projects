SELECT * 
FROM cafe_sales;

-- Create staging table 
CREATE TABLE dirty_cafe_sales_staging
LIKE dirty_cafe_sales;

INSERT dirty_cafe_sales_staging
SELECT *
FROM dirty_cafe_sales;

-- check for duplicates 
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY `Transaction ID`) AS row_num      
FROM dirty_cafe_sales_staging
ORDER BY row_num DESC;

-- Trim white space
UPDATE dirty_cafe_sales_staging
SET `Total Spent` = TRIM(`Total Spent`);

-- Handling unknown or missing numerical values 
UPDATE dirty_cafe_sales_staging
SET `Payment Method` = 'UNKNOWN' WHERE `Payment Method` = '';

UPDATE dirty_cafe_sales_staging
SET `Location` = 'UNKNOWN' WHERE `Location` = '';

UPDATE dirty_cafe_sales_staging
SET `Item` = 'UNKNOWN' WHERE `Item` = '';


SELECT `Transaction ID`, `Item`, `Total Spent`
FROM dirty_cafe_sales_staging
WHERE `Total Spent` = 'ERROR' OR `Total Spent` = '' OR `Total Spent` = 'UNKOWN'; 

-- Update 'ERROR', 'UNKNOWN', and blank values with the Mean of Total Spent
SELECT AVG(CAST(`Total Spent` AS DECIMAL (10,2))) AS mean_value
FROM dirty_cafe_sales_staging
WHERE `Total Spent` NOT IN ('ERROR', 'UNKNOWN') AND `Total Spent` != '';

UPDATE dirty_cafe_sales_staging
SET `Total Spent` = '8.78'
WHERE `Total Spent` IN ('ERROR', 'UNKNOWN') OR `Total Spent` = '';

-- change date column format
ALTER TABLE dirty_cafe_sales_staging
MODIFY COLUMN `Transaction Date` DATE;

-- Missing Dates
ALTER TABLE dirty_cafe_sales_staging ADD COLUMN row_num INT;
SET @row := 0;
UPDATE dirty_cafe_sales_staging
SET row_num = (@row := @row + 1)
ORDER BY `Transaction Date`;



UPDATE dirty_cafe_sales_staging AS t1
JOIN (
	SELECT t2.row_num, DATE_ADD((
		SELECT t3.`Transaction Date`
        FROM dirty_cafe_sales_staging AS t3
        WHERE t3.`Transaction Date` IS NOT NULL
          AND t3.row_num < t2.row_num
		ORDER BY t3.row_num DESC
        LIMIT 1
	), INTERVAL 1 DAY) AS next_date
    FROM dirty_cafe_sales_staging AS t2
    WHERE t2.`Transaction Date` IS NULL
) AS updates
ON t1.row_num = updates.row_num
Set t1.`Transaction Date` = updates.next_date;

UPDATE dirty_cafe_sales_staging
SET `Transaction Date` = '2023-01-01'
WHERE `Transaction Date` IS NULL;

-- Add Transaction Month
ALTER Table dirty_cafe_sales_staging ADD COLUMN Transaction_month INT;
UPDATE dirty_cafe_sales_staging
SET Transaction_month = month(`Transaction Date`);

-- Add Transaction Year
ALTER Table dirty_cafe_sales_staging ADD COLUMN Transaction_year INT;
UPDATE dirty_cafe_sales_staging
SET Transaction_year = YEAR(`Transaction Date`);

-- Add day of the week 
ALTER Table dirty_cafe_sales_staging ADD COLUMN Transaction_day INT;
UPDATE dirty_cafe_sales_staging
SET Transaction_day = dayofweek(`Transaction Date`);

SELECT *
FROM dirty_cafe_sales_staging;


