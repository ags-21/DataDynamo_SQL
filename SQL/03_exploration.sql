/*------------------------------------------------------------------
 -----------------DATA EXPLORATION/ANALYSIS: from-------------------
 -------------------------------------------------------------------*/
--IMPORT VALIDATION--
--Comparing the imported data to the Excel file.
--Customer_ID validation

SELECT 
	COUNT(mb.customer_id), 
	mb.customer_id
FROM data_dynamo.mm_books mb  
GROUP BY mb.customer_id 
ORDER BY 1 DESC
LIMIT 5;

--Gender validation

SELECT 
	COUNT(mb.gender), 
	mb.gender
FROM data_dynamo.mm_books mb 
GROUP BY mb.gender
ORDER BY 1 DESC;

--Category validation

SELECT 
	COUNT(amb.category), 
	amb.category 
FROM data_dynamo.mm_books amb 
GROUP BY amb.category 
ORDER BY 1 DESC;


--DATA EXPLORATION--

-- ANALYSIS
-- How many rows in the data.

SELECT
	COUNT(*) total_rows
FROM data_dynamo.mm_books amb;

-- How many unique rows of data.

SELECT count(DISTINCT id) total_unique_rows
FROM data_dynamo.mm_books amb;

-- How many columns.

SELECT count(*) total_columns
FROM information_schema.COLUMNS
WHERE table_name ='mm_books';

-- How many charachters is the longest product name.

SELECT 
	MAX(amb.product_name) longest_product_name,
	MAX(LENGTH(amb.product_name)) no_charachters
FROM data_dynamo.mm_books amb;

-- How many unique categories.

SELECT COUNT(DISTINCT amb.category) unique_categories
FROM data_dynamo.mm_books amb;

SELECT COUNT(DISTINCT LOWER(amb.category)) unique_categories
FROM data_dynamo.mm_books amb;

-- Check for NULL values

SELECT
  COUNT(*) - COUNT(id) AS id_nulls,
  COUNT(*) - COUNT(special_day) AS special_day_nulls,
  COUNT(*) - COUNT(online_sales_offer) AS online_sales_offer_nulls,
  COUNT(*) - COUNT(quantity) AS quantity_nulls,
  COUNT(*) - COUNT(item_price) AS item_price_nulls,
  COUNT(*) - COUNT(shipping_price) AS shipping_price_nulls,
  COUNT(*) - COUNT(ship_postal_code) AS postal_nulls,
  COUNT(*) - COUNT(total_amount) AS total_amount_nulls,
  COUNT(*) - COUNT(profit_percentage) AS profit_pct_nulls,
  COUNT(*) - COUNT(profit) AS profit_nulls,
  COUNT(*) - COUNT(cost_price) AS cost_price_nulls
FROM data_dynamo.mm_books;

select mm.purchase_date, mm.customer_id, COUNT(*) from data_dynamo.mm_books mm
group by mm.purchase_date, mm.customer_id
having COUNT(*) > 1;

--Max and Min Dates (Timeliness check)

SELECT 
	MIN(amb.purchase_date) Oldest,
	MAX(amb.purchase_date) Newest
FROM data_dynamo.mm_books amb;

-- Whitespace Check

SELECT
	COUNT(CASE
		WHEN product_name != TRIM(product_name) THEN 1
		END) product_name_whtspce,
	COUNT(CASE
		WHEN category != TRIM(category) THEN 1
		END) category_whtspce,
	COUNT(CASE
		WHEN author != TRIM(author) THEN 1
		END) author_whtspce,
	COUNT(CASE
		WHEN amb.publication_ != TRIM(amb.publication_ ) THEN 1
		END) publication_whtspce
FROM data_dynamo.mm_books amb;

-- Impact of offer on product profit.

SELECT
    id, total_amount, cost_price, shipping_price, profit
FROM
    data_dynamo.mm_books amb 
WHERE
    online_sales_offer IS TRUE;

--Expected profits (Profit = total_amount - cost_price - shipping_price)

SELECT
    id,
    profit,
    (total_amount - cost_price - shipping_price) expected_profit 
FROM
    data_dynamo.mm_books amb 
WHERE
    profit != (total_amount - cost_price - shipping_price)
    AND online_sales_offer IS FALSE;

-- Check if total_amount = (item_price * quantity) + shipping_price
SELECT
	COUNT(*) calculation_mismatch
FROM data_dynamo.mm_books amb 
WHERE ABS(amb.total_amount - ((amb.item_price * amb.quantity) + amb.shipping_price )) > 0.01
	AND amb.online_sales_offer IS FALSE;

-- Check if total_amount = item_price + shipping_price
SELECT
	COUNT(*) calculation_mismatch
FROM data_dynamo.mm_books amb 
WHERE ABS(amb.total_amount - ((amb.item_price) + amb.shipping_price )) > 0.01
	AND amb.online_sales_offer IS FALSE
	AND amb.special_day IS FALSE;

-- Sum of sum of columns across all numeric columns

SELECT SUM(
	   id
       + CASE WHEN special_day THEN 1 ELSE 0 END
       + CASE WHEN online_sales_offer THEN 1 ELSE 0 END
       + quantity
       + item_price	   
       + shipping_price
       + ship_postal_code
       + total_amount
       + profit_percentage
       + profit
       + cost_price
       ) AS total_sum_of_row_sums
FROM data_dynamo.mm_books amb ;

-- Sum of row sums across all numeric columns

SELECT SUM(
	   id
       + CASE 
	       WHEN special_day THEN 1 
	       ELSE 0 
	       END
       + CASE 
	       WHEN online_sales_offer THEN 1 
	       ELSE 0 
	       END
       + quantity
       + item_price	   
       + shipping_price
       + ship_postal_code
       + total_amount
       + profit_percentage
       + profit
       + cost_price
       ) AS total_sum_of_row_sums
FROM data_dynamo.mm_books;


-- INCONSISTENCIES
-- Author:

SELECT
	COUNT(amb.author),
	amb.author
FROM data_dynamo.mm_books amb
WHERE amb.author LIKE '%Kanti Jain%'
GROUP BY 2
ORDER BY 1 DESC;

-- Publication:

SELECT
	COUNT(amb.publication_ ),
	amb.publication_ 
FROM data_dynamo.mm_books amb
WHERE amb.publication_  LIKE '%S Chand%'
GROUP BY 2
ORDER BY 1 DESC;

--Ship City:

SELECT
	COUNT(amb.ship_city),
	amb.ship_city
FROM data_dynamo.mm_books amb
WHERE amb.ship_city  ILIKE '%new delhi%'
GROUP BY 2
ORDER BY 1 DESC;

--Ship_state:

SELECT
	COUNT(amb.ship_state),
	amb.ship_state
FROM data_dynamo.mm_books amb
WHERE amb.ship_state  ILIKE '%Tamil Nadu%'
GROUP BY 2
ORDER BY 1 DESC;

