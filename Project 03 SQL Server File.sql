use [Project 03];
select *from shiping;

-------------------------------------------------------------Data Pre_processing----------------------------------------------------------
-- Replace missing or NULL values in Customer_rating with the average rating.

update shiping
set Customer_rating = (select AVG(Customer_rating) from shiping)
where Customer_rating IS NULL;



Select count(Customer_rating) from shiping as count_of_null
where Customer_rating IS NULL;


-- Trim extra spaces in Warehouse_block:
UPDATE shiping
SET Warehouse_block = LTRIM(RTRIM(Warehouse_block));

update shiping
set Mode_of_Shipment = LTRIM(RTRIM(Mode_of_Shipment));


select distinct Product_importance 
from shiping; 


update shiping 
set Product_importance = case
                           when Product_importance = 'low' then 'Low'
						   when Product_importance = 'medium' then 'Medium'
						   when Product_importance = 'high' then 'High'
						 end; 


select distinct Gender 
from shiping; 


update shiping 
set Gender = case
                when Gender = 'F' then 'Female'
		        when Gender = 'M' then 'Male'
						   
		     end; 

--------------------------------------------------------Aggrigation Function-----------------------------------------------------
select distinct Mode_of_Shipment 
from shiping

-- Unique Count of Mode_of_Shipment
SELECT Mode_of_Shipment, COUNT(Mode_of_Shipment)  AS Unique_Count_for_Each
FROM shiping
GROUP BY Mode_of_Shipment
ORDER BY Mode_of_Shipment;

-- Unique Count of Product_importance
SELECT Product_importance, COUNT(Product_importance)  AS Unique_Count_for_Each
FROM shiping
GROUP BY Product_importance
ORDER BY Product_importance;

-- Unique Count of Gender 
SELECT Gender, COUNT(Gender)  AS Unique_Count_for_Each
FROM shiping
GROUP BY Gender
ORDER BY Gender;


-- Highest cost of product for each mode of shipment 
select Mode_of_shipment, Max(Cost_of_the_Product)  as Max_Cost  from shiping
group by Mode_of_shipment
order by Mode_of_shipment;

-- Lowest cost of product for each mode of shipment
select Mode_of_shipment, min(Cost_of_the_Product)  as Max_Cost  from shiping
group by Mode_of_shipment
order by Mode_of_shipment;

-- Average cost of product for each mode of shipment
select Mode_of_shipment, avg (Cost_of_the_Product)  as Max_Cost  from shiping
group by Mode_of_shipment
order by Mode_of_shipment;
	

-- Highest discount offered on Mode of shipment 
SELECT  Mode_of_shipment, MAX(Discount_offered) AS Max_Discount FROM  [shiping ]
GROUP BY 
    Mode_of_shipment;

-- Lowest discount offered on Mode of shipment
SELECT  Mode_of_shipment, min(Discount_offered) AS Max_Discount FROM  [shiping ]
GROUP BY 
    Mode_of_shipment;

	
-- Average discount offered on Mode of shipment
SELECT  Mode_of_shipment, avg(Discount_offered) AS Max_Discount FROM  [shiping ]
GROUP BY 
    Mode_of_shipment;


--- Alter table; For entries in column titled 'Reached On Time' For '1 '-- 'Yes' and for '0' -- 'No'
ALTER TABLE shiping ADD Status VARCHAR(3);

UPDATE [shiping ]	
SET Status = CASE 
                 WHEN Reached_on_Time_Y_N = 1 THEN 'Yes'
                 WHEN Reached_on_Time_Y_N = 0 THEN 'No'
              END;


-- Count of shipments where the product was not delivered on time:
SELECT  Reached_on_Time_Y_N , count(Reached_on_Time_Y_N) as Order_Not_Posted FROM [shiping ]
WHERE Reached_on_Time_Y_N = 0 
group by  Reached_on_Time_Y_N;

-- Count of shipments where the product was delivered on time:
SELECT  Reached_on_Time_Y_N , count(Reached_on_Time_Y_N) as Order_Not_Posted FROM [shiping ]
WHERE Reached_on_Time_Y_N = 1 
group by  Reached_on_Time_Y_N;

-- Unique count of Warehouse_block Group by Warehouse_blocks
select Warehouse_block, count(Warehouse_block) as Unique_Count from [shiping ]
group by Warehouse_block
order by Warehouse_block;

--  Count of Customer Rating where rating is 4 based on Mode of Shipment
select Mode_of_Shipment, Customer_rating, count(Customer_rating) as Toal_count_Per_Shipment from [shiping ]
group by Mode_of_Shipment, Customer_rating
order by Mode_of_Shipment, Customer_rating;

--- Count of Mode of shipment where Discount Offered is > 50%. Group by Mode of Shipment
select Mode_of_Shipment, Count(Mode_of_Shipment) as Count_Per_Shipment_DR_Greater_then_50_percent from [shiping ]
where Discount_offered > 50
group by Mode_of_Shipment
order by Mode_of_Shipment;

-- Get ID's where 'Prior_Purchases' are between 3 and 5
select ID, Prior_purchases from [shiping ]
where Prior_purchases between 3 and 5; 

-- Get 'Product_Importance' = High and 'Status' = Yes
select Product_importance, [Status] from [shiping ]
where Product_importance = 'High' and [Status] = 'Yes'
group by Mode_of_Shipment;

-- Count for Above Query 
select Count(Product_importance), [Status] as Count_of_PI from [shiping ]
where Product_importance = 'High' and [Status] = 'Yes'
group by Mode_of_Shipment, [Status];

-------------------------------------------------Aggregation Functions-----------------------------------

--Find the average Cost_of_the_Product:
select AVG(Cost_of_the_Product) as Avg_Cost from [shiping ];

-- Count the number of shipments per Warehouse_block
select Warehouse_block, COUNT(*) as Shipment_Count from [shiping ]
group by Warehouse_block;

--- Sum of Discount_offered for shipments delivered on time
select SUM(Discount_offered) as Total_Sum from [shiping ]
where Reached_on_Time_Y_N = 1; 

--- Find the minimum and maximum Weight_in_gms per Mode_of_Shipment:
select Mode_of_Shipment, Min(Weight_in_gms) as Min_Weight,  max(Weight_in_gms) as Max_Weight from shiping
group by Mode_of_Shipment;

-- Count the number of shipments with high Product_importance:
select COUNT(*) as Total_count_HIS from [shiping ]
where Product_importance = 'High';

--- Find the total weight of products shipped from each Warehouse_block
select  Warehouse_block, SUM(Weight_in_gms) as Total_Weight_Shipped from [shiping ]
group by Warehouse_block;

-------------------------------------------------------------Window Functions---------------------------------------------------
-- Rank shipments based on Cost_of_the_Product within each Warehouse_block
SELECT ID, Warehouse_block, Cost_of_the_Product,
       RANK() OVER (PARTITION BY Warehouse_block ORDER BY Cost_of_the_Product DESC) AS Cost_Rank
FROM shiping;

-- Calculate the running total of Cost_of_the_Product for each Warehouse_block:
SELECT ID, Warehouse_block, Cost_of_the_Product,
       SUM(Cost_of_the_Product) OVER (PARTITION BY Warehouse_block ORDER BY ID) AS Running_Total_Cost
FROM shiping;


-- Find the difference between the current and previous shipment Cost_of_the_Product within each block
SELECT ID, Warehouse_block, Cost_of_the_Product,
       LAG(Cost_of_the_Product, 1, 0) OVER (PARTITION BY Warehouse_block ORDER BY ID) AS Prev_Cost,
       (Cost_of_the_Product - LAG(Cost_of_the_Product, 1, 0) OVER (PARTITION BY Warehouse_block ORDER BY ID)) AS Cost_Difference
FROM shiping;

-- Calculate the average Customer_rating per Mode_of_Shipment and show it for each record
SELECT ID, Mode_of_Shipment, Customer_rating,
       AVG(Customer_rating) OVER (PARTITION BY Mode_of_Shipment) AS Avg_Rating_By_Mode
FROM shiping;


-- Rank the shipments by Discount_offered within each Mode_of_Shipment
SELECT ID, Mode_of_Shipment, Discount_offered,
       DENSE_RANK() OVER (PARTITION BY Mode_of_Shipment ORDER BY Discount_offered DESC) AS Discount_Rank
FROM shiping;

-- Calculate the cumulative sum of Weight_in_gms for each mode of shipment
SELECT ID, Mode_of_Shipment, Weight_in_gms,
       SUM(Weight_in_gms) OVER (PARTITION BY Mode_of_Shipment ORDER BY ID) AS Cumulative_Weight
FROM shiping;

-- Find the lead shipment (next shipment) for each Mode_of_Shipment based on ID
SELECT ID, Mode_of_Shipment, Cost_of_the_Product,
       LEAD(Cost_of_the_Product, 1) OVER (PARTITION BY Mode_of_Shipment ORDER BY ID) AS Next_Cost
FROM shiping;



---------------------------------------------Recursive Queries--------------------------------------------------------------------
-- Create a recursive query to list all shipment IDs
WITH ShipmentIDs AS (
    SELECT ID
    FROM [shiping ]
    WHERE ID = 1
    UNION ALL
    SELECT s.ID
    FROM [shiping ] s
    JOIN ShipmentIDs si ON s.ID = si.ID + 1
)
SELECT * FROM ShipmentIDs;

--- Calculate the factorial of a number using recursion
WITH Factorial AS (
    SELECT 1 AS n, 1 AS fact
    UNION ALL
    SELECT n + 1, (n + 1) * fact
    FROM Factorial
    WHERE n < 10
)
SELECT * FROM Factorial;


-- Recursive query to sum the Cost_of_the_Product of shipments in a hierarchical order
WITH  ShipmentSum AS (
    SELECT ID, Cost_of_the_Product
    FROM shiping
    WHERE ID = 1
    UNION ALL
    SELECT s.ID, s.Cost_of_the_Product + ss.Cost_of_the_Product
    FROM shiping s
    JOIN ShipmentSum ss ON s.ID = ss.ID + 1
)
SELECT * FROM ShipmentSum;



