--Use the created Swiggy_DB database

USE Swiggy_DB;
GO

--KPI's

--Total Orders

SELECT COUNT(*) AS Total_Orders
FROM fact_swiggy_orders;

--Total Revenue

SELECT 
SUM(Price_INR) AS Total_Revenue 
From fact_swiggy_orders;

--Average Dish Price

SELECT
AVG(Price_INR) AS Avg_Dish_Price 
From fact_swiggy_orders;

--Average Rating

SELECT 
CAST(AVG(Rating) AS DECIMAL(4,2)) AS Avg_Rating
From fact_swiggy_orders;

--Rating Count

SELECT 
SUM(Rating_Count) AS Total_Rating_Count
FROM fact_swiggy_orders;

--Granular Requirements
--Deep Dive Business Analysis

--Monthly Order Trends

SELECT
d.Year,
d.Month,
d.Year_Month,
COUNT(*) AS Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.Year, d.Month, d.Year_Month
ORDER BY d.Year, d.Month;

--Monthly Revenue Trends

SELECT
d.Year,
d.Month,
d.Year_Month,
SUM(Price_INR) AS Revenue
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.Year, d.Month, d.Year_Month
ORDER BY d.Year, d.Month;

--Quarterly Trends

SELECT
d.Year,
d.Quarter,
SUM(Price_INR) AS Sales,
CAST(AVG(Rating) AS DECIMAL(4,2)) AS Rating,
COUNT(*) AS Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.Year, d.Quarter
ORDER BY SUM(Price_INR) DESC;

--Yearly Trends

SELECT
d.Year,
COUNT(*) AS Total_Orders
FROM fact_swiggy_orders f
Join dim_date d ON f.date_id = d.date_id
GROUP BY d.Year
ORDER BY COUNT(*) DESC;

--Order by Day of week (Mon-Sun)

SELECT
	d.Day_of_Week,
	COUNT(*) AS Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.Day_of_Week, d.Day_Number
ORDER BY d.Day_Number;

--Revenue by Day of week

SELECT
    d.Day_of_Week,
    SUM(Price_INR) AS Revenue
FROM fact_swiggy_orders f
JOIN dim_date d
ON f.date_id = d.date_id
GROUP BY d.Day_of_Week, d.Day_Number
ORDER BY d.Day_Number;

--Location Based Analysis

--Top 10 Cities by Orders

SELECT TOP 10
l.City,
COUNT(*) AS Orders
FROM fact_swiggy_orders f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY l.City
ORDER BY COUNT(*) DESC;

--Top 10 Cities by Revenue

SELECT TOP 10
l.City,
SUM(Price_INR) AS Revenue
FROM fact_swiggy_orders f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY l.City
ORDER BY SUM(Price_INR) DESC;

--Revenue Contribution by State

SELECT
l.State,
SUM(Price_INR) AS Revenue
FROM fact_swiggy_orders f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY l.State
ORDER BY SUM(Price_INR) DESC;

--Restaurant Performance

--Top 10 Restaurants by Orders

SELECT TOP 10
r.Restaurant_Name,
COUNT(*) AS Orders
FROM fact_swiggy_orders f
JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY r.Restaurant_Name
ORDER BY COUNT(*) DESC;

--Top 10 Restaurants by Revenue

SELECT TOP 10
r.Restaurant_Name,
SUM(Price_INR) AS Revenue
FROM fact_swiggy_orders f
JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY r.Restaurant_Name
ORDER BY SUM(Price_INR) DESC;

--Category & Dish Analysis
--Top 10 Categories by Orders

SELECT TOP 10
c.Category,
COUNT(*) AS Orders
FROM fact_swiggy_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.Category
ORDER BY COUNT(*) DESC;

--Top 10 Categories by Revenue

SELECT TOP 10
c.Category,
SUM(Price_INR) AS Revenue
FROM fact_swiggy_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.Category
ORDER BY SUM(Price_INR) DESC;

--Top 10 Dishes by Orders

SELECT TOP 10
d.Dish_Name,
COUNT(*) AS Orders
FROM fact_swiggy_orders f
JOIN dim_dish d ON f.dish_id = d.dish_id
GROUP BY d.Dish_Name
ORDER BY COUNT(*) DESC;

--Top 10 Dishes by Revenue

SELECT TOP 10
d.Dish_Name,
SUM(Price_INR) AS Revenue
FROM fact_swiggy_orders f
JOIN dim_dish d ON f.dish_id = d.dish_id
GROUP BY d.Dish_Name
ORDER BY SUM(Price_INR) DESC;

--Food Type Analysis

SELECT
	d.Food_Type,
	COUNT(*) AS Orders,
	SUM(Price_INR) AS Revenue,
	CAST(AVG(Rating) AS DECIMAL(4,2)) AS Avg_Rating
FROM fact_swiggy_orders f
JOIN dim_dish d ON f.dish_id = d.dish_id
GROUP BY d.Food_Type
ORDER BY Revenue DESC;

-- Food Type Confidence Analysis

SELECT
	d.Food_Type_Confidence,
	COUNT(*) AS Orders,
	SUM(Price_INR) AS Revenue,
	CAST(AVG(Rating) AS DECIMAL(4,2)) AS Avg_Rating
FROM fact_swiggy_orders f
JOIN dim_dish d ON f.dish_id = d.dish_id
GROUP BY d.Food_Type_Confidence
ORDER BY Revenue DESC;

-- Cuisine Type Analysis

SELECT
	d.Cuisine_Type,
	COUNT(*) AS Orders,
	SUM(Price_INR) AS Revenue,
	CAST(AVG(Rating) AS DECIMAL(4,2)) AS Avg_Rating
FROM fact_swiggy_orders f
JOIN dim_dish d ON f.dish_id = d.dish_id
GROUP BY d.Cuisine_Type
ORDER BY Revenue DESC;

-- Category Type Analysis

SELECT
	d.Category_Type,
	COUNT(*) AS Orders,
	SUM(Price_INR) AS Revenue,
	CAST(AVG(Rating) AS DECIMAL(4,2)) AS Avg_Rating
FROM fact_swiggy_orders f
JOIN dim_dish d ON f.dish_id = d.dish_id
GROUP BY d.Category_Type
ORDER BY Revenue DESC;

--Price Category Analysis

SELECT
	Price_Category,
	COUNT(*) AS Orders,
	SUM(Price_INR) AS Revenue,
	SUM(Price_INR) * 1.0 / COUNT(*) AS Avg_Order_Value,
	CAST(AVG(Rating) AS DECIMAL(4,2)) AS Avg_Rating
FROM fact_swiggy_orders
GROUP BY Price_Category
ORDER BY Orders DESC;

--Rating Status Analysis

SELECT
	Rating_Status,
	COUNT(*) AS Orders,
	SUM(Price_INR) AS Revenue,
	SUM(Price_INR) * 1.0 / COUNT(*) AS Avg_Order_Value,
	CAST(AVG(Rating) AS DECIMAL(4,2)) AS Avg_Rating
FROM fact_swiggy_orders
GROUP BY Rating_Status;

--Order Count by Day Type (Weekday vs Weekend)

SELECT
    Day_Type,
    COUNT(order_id) AS Orders,
	SUM(Price_INR) AS Revenue,
	SUM(Price_INR) * 1.0 / COUNT(order_id) AS Avg_Order_Value,
	CAST(AVG(Rating) AS DECIMAL(4,2)) AS Avg_Rating
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY Day_Type
ORDER BY Day_Type;

--Category-wise Order Distribution by Day Type (Weekday vs Weekend)

SELECT
    Day_Type,
    Category,
    COUNT(order_id) AS Orders
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY Day_Type, Category
ORDER BY Day_Type, Orders DESC;

--Price Category Analysis by Day Type (Weekday vs Weekend)

SELECT
Day_Type,
Price_Category,
COUNT(order_id) AS Orders,
SUM(Price_INR) AS Revenue,
CAST(AVG(Rating) AS DECIMAL(4,2)) AS Avg_Rating
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY Day_type, Price_Category
ORDER BY Day_Type, Orders DESC;

--Rating Status Analysis by Day Type (Weekday vs Weekend)

SELECT
Day_Type,
Rating_Status,
COUNT(order_id) AS Orders,
SUM(Price_INR) AS Revenue,
SUM(Price_INR) * 1.0 / COUNT(order_id) AS Avg_Price_Value
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY Day_type, Rating_Status
ORDER BY Day_Type, Orders DESC;

--Category Performance (Orders + Avg Rating)

SELECT
	c.Category,
	COUNT(*) AS Orders,
	CAST(AVG(f.Rating) AS DECIMAL(4,2)) AS Avg_Rating
FROM fact_swiggy_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.Category
ORDER BY COUNT(*) DESC;

--Customer Spending Insights
--Total Orders by Price Range

WITH Price_Bucket AS (
SELECT*,
	CASE
		WHEN Price_INR < 100 THEN 'Below 100 INR'
		WHEN Price_INR BETWEEN 100 AND 199 THEN '100-199 INR'
		WHEN Price_INR BETWEEN 200 AND 299 THEN '200-299 INR'
		WHEN Price_INR BETWEEN 300 AND 399 THEN '300-399 INR'
		WHEN Price_INR BETWEEN 400 AND 499 THEN '400-499 INR'
		ELSE 'Above 500 INR'
	END AS Price_Range
FROM fact_swiggy_orders
)
SELECT Price_Range, COUNT(*) AS Orders
FROM Price_Bucket
GROUP BY Price_Range
ORDER BY COUNT(*) DESC;

--Rating Count Distribution (1-5 Stars)

SELECT
	Rating,
	COUNT(*) AS Orders
FROM fact_swiggy_orders
GROUP BY Rating
ORDER BY COUNT(*) DESC;


--Top 10 Cities Contributing % to Total Revenue

WITH City_Revenue AS (
SELECT
	l.City,
	SUM(f.Price_INR) AS revenue
FROM fact_swiggy_orders f
JOIN dim_location l ON f.location_id = l.location_id
GROUP BY l.City
),
Total_Revenue AS (
	SELECT SUM(revenue) AS Total_Rev
	FROM City_Revenue
)
SELECT TOP 10
	c.City,
	c.revenue AS Revenue,
	CAST(
		(c.revenue * 100.0 / t.Total_Rev)
		AS DECIMAL(5,2)
		) AS Contribution_Percentage
FROM City_Revenue c
CROSS JOIN Total_Revenue t
ORDER BY c.revenue DESC;

--Month-Over-Month Growth % 
--First month shows NULL because there is no previous month to compare with.

WITH Monthly_Revenue AS (
	SELECT
		d.Year,
		d.Month,
		d.Year_Month,
		SUM(f.Price_INR) AS revenue
	FROM fact_swiggy_orders f
	JOIN dim_date d ON f.date_id = d.date_id
	GROUP BY d.Year, d.Month,d.Year_Month
)
SELECT
	Year,
	Month,
	Year_Month,
	LAG(revenue) OVER (ORDER BY Year, Month)
	AS Previous_Month_Revenue,
	CAST(
	(
		(revenue - LAG(revenue) OVER (ORDER BY Year, Month)) * 100.0
		/ NULLIF(LAG(revenue) OVER (ORDER BY Year, Month), 0)
	) AS DECIMAL(5,2)
	) AS MoM_Growth_Percentage
FROM Monthly_Revenue
ORDER BY Year, Month;

--Running Total Revenue

SELECT
	d.Year,
	d.Month,
	d.Year_Month,
	SUM(f.Price_INR) AS Monthly_Revenue,
	SUM(SUM(f.Price_INR)) OVER (ORDER BY d.Year, d.Month)
	AS Running_Total_Revenue
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.Year, d.Month, d.Year_Month
ORDER BY d.Year, d.Month;

--Revenue per Restaurant per Month

SELECT
	d.Year,
	d.Month,
	d.Year_Month,
	r.Restaurant_Name,
	SUM(f.Price_INR) AS Monthly_Revenue
FROM fact_swiggy_orders f
JOIN dim_date d ON f.date_id = d.date_id
JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY d.Year, d.Month, d.Year_Month, r.Restaurant_Name
ORDER BY d.Year, d.Month, r.Restaurant_Name;

--Restaurant Ranking by Monthly Revenue

WITH Restaurant_Monthly_Revenue AS (
	SELECT
		d.Year,
		d.Month,
		d.Year_Month,
		r.Restaurant_Name,
		SUM(f.Price_INR) AS Monthly_Revenue
	FROM fact_swiggy_orders f
	JOIN dim_date d ON f.date_id = d.date_id
	JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
	GROUP BY d.Year, d.Month, d.Year_Month, r.Restaurant_Name
)
SELECT*
FROM (
	SELECT *,
		RANK() OVER (PARTITION BY Year, Month ORDER BY Monthly_Revenue DESC) AS Revenue_Rank
	FROM Restaurant_Monthly_Revenue
	) ranked
WHERE Revenue_Rank <= 5
ORDER BY Year, Month, Revenue_Rank;

--Average Order Value (AOV)

SELECT
	COUNT(DISTINCT order_id) AS Orders,
	SUM(Price_INR) Revenue,
	SUM(Price_INR) * 1.0 / COUNT(DISTINCT order_id) AS Avg_Order_Value
FROM fact_swiggy_orders;

--Restaurant Contribution %

SELECT
	r.Restaurant_Name,
	SUM(f.Price_INR) AS Restaurant_Revenue,
	CAST(
		SUM(f.Price_INR) * 100.0 /
		SUM(SUM(f.Price_INR)) OVER () AS DECIMAL(5,2)
		) AS Contribution_Percentage
FROM fact_swiggy_orders f
JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY r.Restaurant_Name
ORDER BY Restaurant_Revenue DESC;

--Category Contribution %

SELECT
	c.Category,
	SUM(f.Price_INR) AS Category_Revenue,
	CAST(
		SUM(f.Price_INR) * 100.0 /
		SUM(SUM(f.Price_INR)) OVER () AS DECIMAL(5,2)
		) AS Contribution_Percentage
FROM fact_swiggy_orders f
JOIN dim_category c ON f.category_id = c.category_id
GROUP BY c.Category
ORDER BY Contribution_Percentage DESC;

--Top 10 Restaurants by Revenue %

WITH Restaurant_Revenue AS (
SELECT
	r.Restaurant_Name,
	SUM(f.Price_INR) AS revenue,
	CAST(
		SUM(f.Price_INR) * 100.0 /
		SUM(SUM(f.Price_INR)) OVER ()
		AS DECIMAL(5,2)
		) AS Revenue_Percentage
FROM fact_swiggy_orders f
JOIN dim_restaurant r ON f.restaurant_id = r.restaurant_id
GROUP BY r.Restaurant_Name
)
SELECT TOP 10
	Restaurant_Name,
	revenue AS Revenue,
	Revenue_Percentage AS Revenue_Percentage
FROM Restaurant_Revenue
ORDER BY Revenue_Percentage DESC;

--Revenue Decline Detection (Month-wise)

WITH Monthly_Revenue AS (
	SELECT
		d.Year,
		d.Month,
		d.Year_Month,
		SUM(f.Price_INR) AS revenue
	FROM fact_swiggy_orders f
	JOIN dim_date d ON f.date_id = d.date_id
	GROUP BY d.Year, d.Month, d.Year_Month
)
SELECT *,
	LAG(revenue) OVER (ORDER BY Year, Month) AS Previous_Month_Revenue,
	revenue - LAG(revenue) OVER (ORDER BY Year, Month) AS Revenue_Change
FROM Monthly_Revenue
ORDER BY Year, Month;

--Revenue Trend Flagging (Growth / Decline)

WITH Monthly_Revenue AS (
	SELECT
		d.Year,
		d.Month,
		d.Year_Month,
		SUM(f.Price_INR) AS revenue
	FROM fact_swiggy_orders f
	JOIN dim_date d ON f.date_id = d.date_id
	GROUP BY d.Year, d.Month, d.Year_Month
)
SELECT *,
	CASE
	WHEN revenue > LAG(revenue) OVER (ORDER BY Year, Month) THEN 'Growth'
	WHEN revenue < LAG(revenue) OVER (ORDER BY Year, Month) THEN 'Decline'
	ELSE 'No Change'
	END AS Revenue_Trend
FROM Monthly_Revenue
ORDER BY Year, Month;

--Check the fact table

SELECT * FROM fact_swiggy_orders;