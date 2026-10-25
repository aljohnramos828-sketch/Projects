-- Find revenue–profit mismatches
-- Identify products with high revenue but low profit. Rank them by profit margin and total revenue.

Select *
From sales_data
;

Select Subcategory, Round(Sum(Net_Sales_INR),2) Total_NetSale, Round(Sum(Profit_INR),2) Total_Profit
From sales_data
Group by Subcategory
order by Total_Profit DESC, Total_NetSale DESC
;

-- Which regions and cities are underperforming base on their profit and quantity sold?
-- Region
Select Region, Sum(Quantity) Quantity_Sold, sum(Profit_INR) Profit
From sales_data
Group by Region
Order by Profit Desc, Quantity_Sold Desc
;
-- East and Central Region

-- Top 5 underperforming cities
-- Cities
Select City, Sum(Quantity) Quantity_Sold, sum(Profit_INR) Profit
From sales_data
Group by City
Having sum(Profit_INR) < 1200000 and Quantity_Sold < 2450
Order by Profit Desc, Quantity_Sold Desc
;

-- Patna, Kolkata, Raipur, Guwahati, Indore

-- Which products sell in high quantities but contribute little profit?

Select Subcategory, Sum(Quantity) Quantity_Sold,  Sum(Profit_INR) Profit
From sales_data
group by Subcategory
order by Quantity_Sold Desc, Profit Asc
;
-- Note: Binder produces more profit even it solds 3.5k which is top 5 in the most sold quantity products

Select Subcategory,  Sum(Profit_INR) Profit,  Sum(Quantity) Quantity_Sold
From sales_data
group by Subcategory
order by Profit DESC, Quantity_Sold asc
;
-- Note: Laptop rank top 4 in the most profit however it is top 1 in the most quantity Sold

-- Which Channel have the most Profit? 

Select `Channel`,  Round(Sum(Profit_INR),2) Profit,  Round(Sum(Quantity),2) Quantity_Sold
From sales_data
group by `Channel`
order by Profit DESC, Quantity_Sold asc
;

-- Does customer satisfaction vary across sales channels?

Select `Channel`, Customer_Satisfaction, sum(Net_Sales_INR),Sum(Profit_INR) Profit
from sales_data
Group by Channel, Customer_Satisfaction
order by Channel, Customer_Satisfaction DESC
;




