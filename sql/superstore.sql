

-- Query 1: Total Sales & Profit by Region
SELECT
    Region,
    SUM(Sales)   AS Total_Sales,
    SUM(Profit)  AS Total_Profit,
    COUNT(*)     AS Total_Orders
FROM superstore
GROUP BY Region
ORDER BY Total_Sales DESC;


-- Query 2: Sales & Profit by Category and Sub-Category, with margin %
SELECT
    Category,
    Sub_Category,
    SUM(Sales)                                AS Total_Sales,
    SUM(Profit)                               AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2)  AS Profit_Margin_Pct
FROM superstore
GROUP BY Category, Sub_Category
ORDER BY Category, Total_Sales DESC;


-- Query 3: Average Order Value by Segment
SELECT
    Segment,
    COUNT(DISTINCT Order_ID)                         AS Num_Orders,
    SUM(Sales)                                       AS Total_Sales,
    ROUND(AVG(Sales), 2)                             AS Avg_Line_Sales,
    ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2)  AS Avg_Order_Value
FROM superstore
GROUP BY Segment
ORDER BY Total_Sales DESC;




-- Query 1: All individual loss-making order lines
SELECT
    Order_ID,
    Region,
    Category,
    Sub_Category,
    Product_Name,
    Sales,
    Discount,
    Profit
FROM Superstore
WHERE Profit < 0
ORDER BY Profit ASC;


-- Query 2: Loss-making order lines in a specific region (East)
SELECT
    Sub_Category,
    Product_Name,
    Discount,
    Sales,
    Profit
FROM Superstore
WHERE Region = 'East'
  AND Profit < 0
ORDER BY Profit ASC;


-- Query 3: Sub-categories that are loss-making overall (HAVING vs WHERE)
SELECT
    Category,
    Sub_Category,
    SUM(Sales)                                AS Total_Sales,
    SUM(Profit)                               AS Total_Profit,
    ROUND(SUM(Profit) / SUM(Sales) * 100, 2)  AS Profit_Margin_Pct
FROM Superstore
GROUP BY Category, Sub_Category
HAVING SUM(Profit) < 0
ORDER BY Total_Profit ASC;


-- Query 4: Recurring loss patterns by Region + Sub-Category, with avg discount
SELECT
    Region,
    Sub_Category,
    COUNT(*)                   AS Loss_Order_Count,
    SUM(Profit)                AS Total_Loss,
    ROUND(AVG(Discount), 2)    AS Avg_Discount
FROM Superstore
WHERE Profit < 0
GROUP BY Region, Sub_Category
HAVING COUNT(*) >= 3
ORDER BY Total_Loss ASC;


-- =========================================================
-- Module 1.3: Date Functions   (MySQL syntax)
-- Goal: Shipping delay, year/month trends, on-time performance
-- Table: Superstore
-- =========================================================

-- Query 1: Shipping delay per order
SELECT
    Order_ID,
    Order_Date,
    Ship_Date,
    Ship_Mode,
    DATEDIFF(Ship_Date, Order_Date) AS Shipping_Delay_Days
FROM Superstore
ORDER BY Shipping_Delay_Days DESC;


-- Query 2: Average shipping delay by Region and Ship Mode
SELECT
    Region,
    Ship_Mode,
    ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)), 1) AS Avg_Shipping_Days,
    COUNT(*) AS Num_Orders
FROM Superstore
GROUP BY Region, Ship_Mode
ORDER BY Region, Avg_Shipping_Days DESC;


-- Query 3: Sales/Profit trend by Year + Month
SELECT
    YEAR(Order_Date)   AS Order_Year,
    MONTH(Order_Date)  AS Order_Month,
    SUM(Sales)   AS Total_Sales,
    SUM(Profit)  AS Total_Profit,
    COUNT(*)     AS Num_Orders
FROM Superstore
GROUP BY YEAR(Order_Date), MONTH(Order_Date)
ORDER BY Order_Year, Order_Month;


-- Query 4: Clean "YYYY-MM" label for time series/reporting
-- Query 4: Clean "YYYY-MM" label for time series/reporting
SELECT
    DATE_FORMAT(Order_Date, '%Y-%m') AS YearMonth,
    SUM(Sales)  AS Total_Sales,
    SUM(Profit) AS Total_Profit
FROM Superstore
GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
ORDER BY YearMonth;


-- =========================================================
-- Module 1.4: Window Functions   (MySQL syntax)
-- Goal: Top N products per category, MoM growth, running totals
-- Table: Superstore
-- =========================================================

-- Query 1: Top 5 products by Sales within each Category (RANK)
SELECT *
FROM (
    SELECT
        Category,
        Product_Name,
        SUM(Sales) AS Total_Sales,
        RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS Sales_Rank
    FROM Superstore
    GROUP BY Category, Product_Name
) ranked
WHERE Sales_Rank <= 5
ORDER BY Category, Sales_Rank;


-- Query 2: Most recent order per customer (ROW_NUMBER)
SELECT *
FROM (
    SELECT
        Customer_ID,
        Order_ID,
        Order_Date,
        Sales,
        ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Order_Date DESC) AS rn
    FROM Superstore
) latest
WHERE rn = 1;


-- Query 3: Month-over-Month Sales Growth (LAG)
SELECT
    Year_Month,
    Total_Sales,
    LAG(Total_Sales) OVER (ORDER BY Year_Month) AS Prev_Month_Sales,
    ROUND(
        100.0 * (Total_Sales - LAG(Total_Sales) OVER (ORDER BY Year_Month))
        / LAG(Total_Sales) OVER (ORDER BY Year_Month),
    2) AS MoM_Growth_Pct
FROM (
    SELECT
        DATE_FORMAT(Order_Date, '%Y-%m') AS Year_Month,
        SUM(Sales) AS Total_Sales
    FROM Superstore
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
) monthly
ORDER BY Year_Month;


-- Query 4: Running (cumulative) total sales over time
SELECT
    YearMonth,
    Total_Sales,
    SUM(Total_Sales) OVER (ORDER BY YearMonth) AS Running_Total_Sales
FROM (
    SELECT
        DATE_FORMAT(Order_Date, '%Y-%m') AS YearMonth,
        SUM(Sales) AS Total_Sales
    FROM Superstore
    GROUP BY DATE_FORMAT(Order_Date, '%Y-%m')
) monthly
ORDER BY YearMonth;


-- Query 5: % of orders shipped late (>5 days) by Region
SELECT
    Region,
    ROUND(AVG(DATEDIFF(Ship_Date, Order_Date)), 1) AS Avg_Delay_Days,
    SUM(CASE WHEN DATEDIFF(Ship_Date, Order_Date) > 5 THEN 1 ELSE 0 END) AS Orders_Over_5_Days,
    COUNT(*) AS Total_Orders,
    ROUND(100.0 * SUM(CASE WHEN DATEDIFF(Ship_Date, Order_Date) > 5 THEN 1 ELSE 0 END) / COUNT(*), 1) AS Pct_Late
FROM Superstore
GROUP BY Region
ORDER BY Pct_Late DESC;





-- Query 1: Basic CTE — Region profitability
WITH region_summary AS (
    SELECT
        Region,
        SUM(Sales)  AS Total_Sales,
        SUM(Profit) AS Total_Profit
    FROM Superstore
    GROUP BY Region
)
SELECT
    Region,
    Total_Sales,
    Total_Profit,
    ROUND(Total_Profit / Total_Sales * 100, 2) AS Profit_Margin_Pct
FROM region_summary
ORDER BY Profit_Margin_Pct DESC;


-- Query 2: Chained CTEs — region totals + rank + status flag
WITH region_totals AS (
    SELECT
        Region,
        SUM(Sales)  AS Total_Sales,
        SUM(Profit) AS Total_Profit,
        ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
    FROM Superstore
    GROUP BY Region
),
ranked_regions AS (
    SELECT
        *,
        RANK() OVER (ORDER BY Profit_Margin_Pct DESC) AS Margin_Rank
    FROM region_totals
)
SELECT
    Region,
    Total_Sales,
    Total_Profit,
    Profit_Margin_Pct,
    Margin_Rank,
    CASE WHEN Profit_Margin_Pct < 0 THEN 'Loss-Making' ELSE 'Profitable' END AS Status
FROM ranked_regions
ORDER BY Margin_Rank;


-- Query 3: CTE + scalar subquery — below-average spending customers
WITH customer_totals AS (
    SELECT
        Customer_ID,
        SUM(Sales) AS Total_Spend
    FROM Superstore
    GROUP BY Customer_ID
)
SELECT
    Customer_ID,
    Total_Spend
FROM customer_totals
WHERE Total_Spend < (SELECT AVG(Total_Spend) FROM customer_totals)
ORDER BY Total_Spend ASC;


-- Query 4: "Executive report" — Region x Category performance, ranked, flagged
WITH category_perf AS (
    SELECT
        Region,
        Category,
        SUM(Sales)  AS Total_Sales,
        SUM(Profit) AS Total_Profit,
        ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS Profit_Margin_Pct
    FROM Superstore
    GROUP BY Region, Category
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY Region ORDER BY Total_Sales DESC) AS Sales_Rank_In_Region
    FROM category_perf
)
SELECT
    Region,
    Category,
    Total_Sales,
    Profit_Margin_Pct,
    Sales_Rank_In_Region,
    CASE
        WHEN Sales_Rank_In_Region <= 3 THEN 'Top Performer'
        WHEN Profit_Margin_Pct < 0     THEN 'Underperformer'
        ELSE 'Average'
    END AS Performance_Flag
FROM ranked
ORDER BY Region, Sales_Rank_In_Region;



-- =========================================================
-- Module 1.6: RFM Analysis   (MySQL syntax)
-- Goal: Recency, Frequency, Monetary scoring + customer segmentation
-- Table: Superstore
-- =========================================================

-- Step 1: Raw R, F, M values per customer
SELECT
    Customer_ID,
    DATEDIFF((SELECT MAX(Order_Date) FROM Superstore), MAX(Order_Date)) AS Recency_Days,
    COUNT(DISTINCT Order_ID) AS Frequency,
    SUM(Sales) AS Monetary
FROM Superstore
GROUP BY Customer_ID;


-- Step 2, 3 & 4: Full RFM scoring + segmentation (customer-level detail)
WITH rfm_raw AS (
    SELECT
        Customer_ID,
        DATEDIFF((SELECT MAX(Order_Date) FROM Superstore), MAX(Order_Date)) AS Recency_Days,
        COUNT(DISTINCT Order_ID) AS Frequency,
        SUM(Sales) AS Monetary
    FROM Superstore
    GROUP BY Customer_ID
),
rfm_scored AS (
    SELECT
        Customer_ID,
        Recency_Days,
        Frequency,
        Monetary,
        NTILE(5) OVER (ORDER BY Recency_Days DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC)     AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC)      AS M_Score
    FROM rfm_raw
),
rfm_segmented AS (
    SELECT
        *,
        CONCAT(R_Score, F_Score, M_Score) AS RFM_Code,
        (R_Score + F_Score + M_Score) AS RFM_Total,
        CASE
            WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
            WHEN R_Score >= 4 AND F_Score >= 3                  THEN 'Loyal Customers'
            WHEN R_Score >= 4 AND F_Score <= 2                  THEN 'New / Promising'
            WHEN R_Score <= 2 AND F_Score >= 4                  THEN 'At Risk (was loyal)'
            WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN 'Lost / Churned'
            ELSE 'Needs Attention'
        END AS Customer_Segment
    FROM rfm_scored
)
SELECT * FROM rfm_segmented
ORDER BY RFM_Total DESC;


-- Step 5: Segment-level summary — how many customers per segment, and their value
WITH rfm_raw AS (
    SELECT
        Customer_ID,
        DATEDIFF((SELECT MAX(Order_Date) FROM Superstore), MAX(Order_Date)) AS Recency_Days,
        COUNT(DISTINCT Order_ID) AS Frequency,
        SUM(Sales) AS Monetary
    FROM Superstore
    GROUP BY Customer_ID
),
rfm_scored AS (
    SELECT
        Customer_ID,
        Monetary,
        NTILE(5) OVER (ORDER BY Recency_Days DESC) AS R_Score,
        NTILE(5) OVER (ORDER BY Frequency ASC)     AS F_Score,
        NTILE(5) OVER (ORDER BY Monetary ASC)      AS M_Score
    FROM rfm_raw
),
rfm_segmented AS (
    SELECT
        *,
        CASE
            WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
            WHEN R_Score >= 4 AND F_Score >= 3                  THEN 'Loyal Customers'
            WHEN R_Score >= 4 AND F_Score <= 2                  THEN 'New / Promising'
            WHEN R_Score <= 2 AND F_Score >= 4                  THEN 'At Risk (was loyal)'
            WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN 'Lost / Churned'
            ELSE 'Needs Attention'
        END AS Customer_Segment
    FROM rfm_scored
)
SELECT
    Customer_Segment,
    COUNT(*) AS Num_Customers,
    ROUND(AVG(Monetary), 2) AS Avg_Spend,
    SUM(Monetary) AS Total_Segment_Value
FROM rfm_segmented
GROUP BY Customer_Segment
ORDER BY Total_Segment_Value DESC;