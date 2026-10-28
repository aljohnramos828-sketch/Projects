-- Note: the column header has change before exporting 

Select *
From cafe_sales
;

-- inspecting all the possible values 
-- This has been applied for all the column
Select distinct location
from cafe_sales
;


-- Clean NULL, blank, 'Unknown', and 'Error' entries
-- in item, quantity, price_per_unit, total_spent, location and transaction_date
Select *
From cafe_sales
Where quantity = '' or
	 quantity = 0 or
	 quantity is null
;

Select *
From cafe_sales
Where item = 'UNKNOWN' or
	 item = '' or
	 item = 'ERROR'
;

-- Replacing no value or unknown value 
UPDATE cafe_sales
SET item = 'Not Specified'
WHERE item = 'UNKNOWN' or
	 item = '' or 
	 item = 'ERROR'
;

-- Double Check if the update have been applied
Select *
From cafe_sales 
Where item = 'Not Specified'
;

-- for price_per_unit
Select *
From cafe_sales
Where price_per_unit = 0 or 
	price_per_unit is Null or
	 price_per_unit = ''
;

-- for total_spent
Select *
From cafe_sales
Where total_spent = 'UNKNOWN' or
	 total_spent = 'ERROR' or
	 total_spent = ''
;

UPDATE cafe_sales
SET total_spent = 'NULL'
Where total_spent = ''
;

-- Double Check again
select *
From cafe_sales
Where total_spent = 'NULL'
;

-- for payment_method
Select *
from cafe_sales
Where payment_method = 'UNKNOWN'
	 or payment_method = 'ERROR' 
	 or payment_method = ''
order by payment_method
;

UPDATE cafe_sales
SET payment_method = 'Unspecified'
Where payment_method = 'UNKNOWN'
	 or payment_method = 'ERROR' 
	 or payment_method = ''
;

-- Double Check again the payment_method
Select *
from cafe_sales
Where payment_method = 'UNspecified'
;

-- For location
Select *
from cafe_sales
Where location = 'UNKNOWN'
	 or location = 'ERROR' 
	 or location = ''
order by location
;

Update cafe_sales
set location = 'NULL'
Where location = 'UNKNOWN'
	 or location = 'ERROR' 
	 or location = ''
order by location
;

-- for transaction_date
Select distinct transaction_date
from cafe_sales
order by transaction_date
;

Select *
from cafe_sales
Where transaction_date = 'UNKNOWN'
	 or transaction_date = 'ERROR' 
	 or transaction_date = ''
;

Update cafe_sales
Set transaction_date = 'NULL'
Where transaction_date = 'UNKNOWN'
	 or transaction_date = 'ERROR' 
	 or transaction_date = ''
;

-- Deleting rows that has no Item and payment method that being specified this doesn't make sense because we dont know the item as well as the payment method
Select *
From cafe_sales
Where (item = 'Not Specified' and payment_method = 'Unspecified')
;

Delete From cafe_sales
Where (item = 'Not Specified' and payment_method = 'Unspecified')
;


-- Cleaning Transaction id as well
Select transaction_id, Right(transaction_id, 7) transaction_id
from cafe_sales
;

Update cafe_sales
Set transaction_id = Right(transaction_id, 7)
;

Select *
from cafe_sales
;

-- Checking if the total spent is valid and replacing it with the true value base on quantity and prize

Select *, (quantity * price_per_unit) as total_value_spent
from cafe_sales
;

Update cafe_sales
set total_spent = (quantity * price_per_unit)
;

-- Converting date into reusable date format 
-- this can be use in EDA
 Select transaction_date, DATE_FORMAT(STR_TO_DATE(transaction_date, '%m/%d/%Y'), '%M %Y') rec_date
 From cafe_sales
 ;
 
 



-- Exploratiory Data Analysis part

-- Checking how many rows will remain if I remove all those null values
Select *
from cafe_sales
where item != 'Not Specified' and
	 payment_method != 'Unspecified' and  
	 location != "NULL" and
	 transaction_date != 'NULL'
;
-- 3234 rows only returns this will significantly affects the analysis. This is not the right solution. 

-- Average total_spend per item 
SELECT item, Round(avg(total_spent),2) avg_spend
From cafe_sales
Where item != 'Not Specified'
Group by item
order by avg_spend DESC
;

-- Average quantity per item 
SELECT item, Round(avg(quantity),2) avg_quantity_sold
From cafe_sales
Where item != 'Not Specified'
Group by item
order by avg_quantity_sold DESC
;
-- Coffee 3

-- Top 5 products based on average_spend and total quantity sold
SELECT item, Round(avg(total_spent),2) avg_spend, Round(sum(quantity),2) total_quantity_sold
From cafe_sales
Where item != 'Not Specified'
Group by item
order by avg_spend DESC, total_quantity_sold DESc
Limit 5
;
-- Salad, Smoothie, Sandwich, Cake, Juice

-- Top 5 product per month based on quantity sold
 Select DATE_FORMAT(STR_TO_DATE(transaction_date, '%m/%d/%Y'), '%M %Y') rec_date, Sum(quantity) as quantity_sold
 From cafe_sales
  Group by rec_date
  order by quantity_sold Desc
  Limit 5
 ;
 -- October,june,march,august,january
 
 -- Most sold item in October 2023
Select  DATE_FORMAT(STR_TO_DATE(transaction_date, '%m/%d/%Y'), '%M %Y') rec_date, item, Sum(quantity) total_quantity_sold
From cafe_sales
Group by rec_date, item
having rec_date = 'October 2023' and item != 'Not Specified'
order by total_quantity_sold DESC
;
-- Coffee is the number 1 item sold maybe this is because of the weather condition every October 
-- Note: Coffee is not included in the top item base on total_spend this means that coffee has it's seasonal peak during this time 

