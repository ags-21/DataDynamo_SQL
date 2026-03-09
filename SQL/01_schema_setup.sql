-- Drop tables if they exist so that you can restart

drop table if exists data_dynamo.mm_books;

-- STEP 1
-- Creating the table 
CREATE TABLE data_dynamo.mm_books (
  id INT,
  purchase_date VARCHAR,
  special_day INT,
  online_sales_offer INT,
  customer_id VARCHAR,
  gender VARCHAR(1),
  product_name VARCHAR,
  item_status VARCHAR,
  quantity INT,
  currency VARCHAR,
  item_price INT,
  shipping_price INT,
  ship_city VARCHAR,
  ship_state VARCHAR,
  ship_postal_code INT,
  category varchar,
  total_amount INT,
  author VARCHAR,
  publication_ VARCHAR,
  profit_percentage INT,
  profit NUMERIC,
  cost_price NUMERIC
);

-- STEP 2
-- Alter tables to turn special_day and online_sales_offer into BOOL types
ALTER TABLE data_dynamo.mm_books
    ALTER COLUMN special_day TYPE BOOL
    USING CASE
        WHEN special_day = 1 THEN TRUE
        WHEN special_day = 0 THEN FALSE
        ELSE NULL
    END;

ALTER TABLE data_dynamo.mm_books
    ALTER COLUMN online_sales_offer TYPE BOOL
    USING CASE
        WHEN online_sales_offer = 1 THEN TRUE
        WHEN online_sales_offer = 0 THEN FALSE
        ELSE NULL
    END;


-- STEP 3
-- Alter table to turn purchase date into a timestamp
ALTER TABLE data_dynamo.mm_books
	ALTER COLUMN purchase_date TYPE TIMESTAMP
	USING TO_TIMESTAMP(purchase_date, 'DD/MM/YYYY HH24:MI');


-- STEP 4
-- Update columns to make them valid
update data_dynamo.mm_books
set category = lower(category); 

update data_dynamo.mm_books
set product_name = lower(product_name); 

update data_dynamo.mm_books
set item_status = lower(item_status); 

update data_dynamo.mm_books
set author = lower(btrim(replace(author, E'\u00A0', '')));

update data_dynamo.mm_books
set ship_city = lower(btrim(replace(ship_city, E'\u00A0', ''))); 

update data_dynamo.mm_books
set ship_state = lower(btrim(replace(ship_state, E'\u00A0', '')));

update data_dynamo.mm_books
set publication_ = lower(btrim(replace(publication_, E'\u00A0', '')));