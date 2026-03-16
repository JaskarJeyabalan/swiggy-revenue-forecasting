--Use the created Swiggy_DB database

USE Swiggy_DB;
GO

--Delete existing view if it exists before creating a new one

DROP VIEW IF EXISTS vw_swiggy_analytics;
GO

--Create a view to consolidate data from fact and dimension tables for analytics

CREATE VIEW vw_swiggy_analytics AS
SELECT

--dimension and fact table columns
--dim_date

f.order_id,
d.Order_Date,
d.Year,
d.Month,
d.Day,
d.Year_Month,
d.Year_Month_Sort,
d.Month_Name,
d.Quarter,
d.Week_Number,
d.Year_Week,
d.Year_Week_Sort,
d.Day_Number,
d.Day_of_Week,
d.Year_Day_of_Week,
d.Year_Day_of_Week_Sort,
d.Day_Type,

--dim_location

l.State,
l.City,
l.Location,

--dim_restaurant

r.Restaurant_Name,

--dim_category

c.Category,

--dim_dish

di.Dish_Name,
di.Food_Type,
di.Food_Type_Confidence,
di.Cuisine_Type,
di.Category_Type,

--stg_swiggy_data

f.Price_INR,
f.Rating,
f.Rating_Count,
f.Price_Category,
f.Rating_Status

FROM fact_swiggy_orders f

--Join the all tables

JOIN dim_date d 
ON f.date_id = d.date_id

JOIN dim_location l 
ON f.location_id = l.location_id

JOIN dim_restaurant r 
ON f.restaurant_id = r.restaurant_id

JOIN dim_category c 
ON f.category_id = c.category_id

JOIN dim_dish di 
ON f.dish_id = di.dish_id

GO

--Check the view

SELECT * FROM vw_swiggy_analytics;