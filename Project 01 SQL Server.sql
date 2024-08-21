use [Project 01];
select * from stocks

-- Just want to see only AAPL. 
SELECT Ticker  FROM stocks
WHERE Ticker = 'AAPL';

-- Just want to see count AAPL.
SELECT COUNT(*) AS AAPL_Count
FROM stocks
WHERE Ticker = 'AAPL';


-- Just want to see only GOOG. 
SELECT Ticker  FROM stocks
WHERE Ticker = 'GOOG';

-- Count of GOOD.
SELECT COUNT(*) AS GOOG_Count
FROM stocks
WHERE Ticker = 'GOOG';



-- Just want to see only MSFT. 
SELECT Ticker  FROM stocks
WHERE Ticker = 'MSFT';

-- Count of MSFT.
SELECT COUNT(*) AS MSFT_Count
FROM stocks
WHERE Ticker = 'MSFT';


-- Just want to see only NFLX. 
SELECT Ticker  FROM stocks
WHERE Ticker = 'NFLX'


-- Count of NFLX.
SELECT COUNT(*) AS NFLX_Count
FROM stocks
WHERE Ticker = 'NFLX';

-- Ticker where the volume is greater than 80,000,000
SELECT Ticker, Volume
FROM stocks
WHERE Ticker IN ('AAPL', 'GOOG', 'MSFT', 'NFLX')
AND Volume > 80000000;

-- Ticker where Close  is greater than 300.
SELECT Ticker, [Close]
FROM stocks
WHERE Ticker IN ('AAPL', 'GOOG', 'MSFT', 'NFLX')
AND [Close] > 300;

-- To count how many times each ticker appears with a closing price greater than 300
SELECT Ticker, COUNT(*) AS Count
FROM stocks
WHERE Ticker IN ('AAPL', 'GOOG', 'MSFT', 'NFLX')
AND [Close] > 300
GROUP BY Ticker;


-- Ticker where Open  is less than 150.
SELECT Ticker, [Open]
FROM stocks
WHERE Ticker IN ('AAPL', 'GOOG', 'MSFT', 'NFLX')
AND [Open] < 150;

-- To count how many times each ticker appears with a Opening price less than 150
SELECT Ticker, COUNT(*) AS Count
FROM stocks
WHERE Ticker IN ('AAPL', 'GOOG', 'MSFT', 'NFLX')
AND [Open] < 150
GROUP BY Ticker;

SELECT [Date] , Ticker, COUNT(*) AS Count
FROM stocks
WHERE Ticker IN ('AAPL', 'GOOG', 'MSFT', 'NFLX') 
GROUP BY Ticker;

-----------------------------------------------Data Cleaning-----------------------------------------------
-- 01: Remove Null or Invalid Entries in Volume Column:
DELETE FROM Stocks
WHERE Volume IS NULL OR Volume < 0;

-- 02: Update Incorrect or Missing Values (e.g., Replace Null with a Default Value):
UPDATE Stocks
SET Adj_Close = [Close]
WHERE Adj_Close IS NULL;

-- 03: Trim Extra Whitespace from Ticker:
UPDATE Stocks
SET Ticker = LTRIM(RTRIM(Ticker));

-----------------------------------------------Filtering Data------------------------------------------------
-- 01: Filter Records for a Specific Ticker 
-- ('AAPL')
SELECT * FROM Stocks
WHERE Ticker = 'AAPL';
-- ('GOOG')
SELECT * FROM Stocks
WHERE Ticker = 'GOOG';
-- ('MSFT')
SELECT * FROM Stocks
WHERE Ticker = 'MSFT';
-- ('NFLX')
SELECT * FROM Stocks
WHERE Ticker = 'NFLX';

-- 02: Filter Records Based on a Date Range:
SELECT * FROM Stocks
WHERE Date BETWEEN '2023-02-01' AND '2023-02-28';

-- 03: Filter Records with High Stock Prices Greater Than a Specific Value:
SELECT * FROM Stocks
WHERE High > 150.00;

----------------------------------------------Aggregation Functions------------------------------------------
-- 01: Find the Average Closing Price for Each Ticker:
SELECT Ticker, AVG([Close]) AS Avg_Close
FROM Stocks
GROUP BY Ticker;

-- 02: Calculate the Total Volume for Each Ticker:
SELECT Ticker, SUM(CAST(Volume AS BIGINT)) AS Total_Volume
FROM Stocks
GROUP BY Ticker;


-- 03: Count the Number of Trading Days for Each Ticker:
SELECT Ticker, COUNT([Date]) AS Trading_Days
FROM Stocks
GROUP BY Ticker;


--------------------------------------------Data Transformation-----------------------------------------------
-- 01: Convert Date to Month and Year Format:
SELECT Ticker, FORMAT(Date, 'yyyy-MM') AS Year_Month, [Close]
FROM Stocks;

-- 02: Round the Open, High, Low, and Close Prices to 2 Decimal Places:
SELECT Ticker, [Date], ROUND([Open], 2) AS [Open], ROUND([High], 2) AS [High], 
       ROUND([Low], 2) AS [Low], ROUND([Close], 2) AS [Close]
FROM Stocks;

-- 03: Calculate Price Difference Between Close and Open:
SELECT Ticker, [Date], ([Close] - [Open]) AS Price_Change
FROM Stocks;

---------------------------------------------------Window Functions-------------------------------------------
-- 01: Calculate the Moving Average of the Closing Price Over the Last 5 Days:
SELECT Ticker, [Date], [Close], 
       AVG([Close]) OVER (PARTITION BY Ticker ORDER BY [Date] ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS Moving_Avg
FROM Stocks;

-- 02: Rank Stocks Based on Volume for Each Day:
SELECT Ticker, [Date], Volume, 
       RANK() OVER (PARTITION BY [Date] ORDER BY Volume DESC) AS Volume_Rank
FROM Stocks;

-- 03: Calculate Cumulative Volume for Each Ticker:
SELECT Ticker, [Date], Volume, 
       SUM(Volume) OVER (PARTITION BY Ticker ORDER BY [Date]) AS Cumulative_Volume
FROM Stocks;

------------------------------------------------Recursive Queries-----------------------------------------------
-- 01: Recursive Query to Generate a Sequence of Dates:
WITH DateSequence AS (
    SELECT CAST('2023-02-01' AS [DATE]) AS [Date]
    UNION ALL
    SELECT DATEADD(DAY, 1, [Date])
    FROM DateSequence
    WHERE [Date] < '2023-02-28'
)
SELECT * FROM DateSequence;

-- 02: Recursive Query to Calculate Running Total of Volume:
WITH RunningTotal AS (
    SELECT Ticker, [Date], Volume, Volume AS Cumulative_Volume
    FROM Stocks
    WHERE Date = (SELECT MIN([Date]) FROM Stocks WHERE Ticker = 'AAPL')
    UNION ALL
    SELECT s.Ticker, s.[Date], s.Volume, rt.Cumulative_Volume + s.Volume
    FROM Stocks s
    JOIN RunningTotal rt ON s.Ticker = rt.Ticker AND s.[Date] = DATEADD(DAY, 1, rt.[Date])
)
SELECT * FROM RunningTotal;



