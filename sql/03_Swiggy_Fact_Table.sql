--Use the created Swiggy_DB database

USE Swiggy_DB;
GO

--Create Fact Table

CREATE TABLE fact_swiggy_orders(
order_id INT IDENTITY(1,1) PRIMARY KEY,
date_id INT,
location_id INT,
restaurant_id INT,
category_id INT,
dish_id INT,
Price_INR DECIMAL(10,2),
Rating DECIMAL(4,2),
Rating_Count INT,
Price_Category VARCHAR(20),
Rating_Status VARCHAR(15),

--Foreign Key Constraints

FOREIGN KEY(date_id) REFERENCES dim_date(date_id),
FOREIGN KEY(location_id) REFERENCES dim_location(location_id),
FOREIGN KEY(restaurant_id) REFERENCES dim_restaurant(restaurant_id),
FOREIGN KEY(category_id) REFERENCES dim_category(category_id),
FOREIGN KEY(dish_id) REFERENCES dim_dish(dish_id)
);

--Insert fact_swiggy_orders

INSERT INTO fact_swiggy_orders
(date_id,location_id,restaurant_id,category_id,dish_id,
Price_INR,Rating,Rating_Count,Price_Category,Rating_Status)

SELECT
dd.date_id,
dl.location_id,
dr.restaurant_id,
dc.category_id,
dsh.dish_id,
s.Price_INR,
s.Rating,
s.Rating_Count,
s.Price_Category,
s.Rating_Status
FROM stg_swiggy_data s

--JOIN with dimension tables to get the corresponding IDs for the fact table

JOIN dim_date dd
ON dd.Order_Date=s.Order_Date

JOIN dim_location dl
ON dl.State=s.State
AND dl.City=s.City
AND dl.Location=s.Location

JOIN dim_restaurant dr
ON dr.Restaurant_Name=s.Restaurant_Name

JOIN dim_category dc
ON dc.Category=s.Category

JOIN dim_dish dsh
ON dsh.Dish_Name=s.Dish_Name
AND dsh.Food_Type=s.Food_Type
And dsh.Food_Type_Confidence=s.Food_Type_Confidence
And dsh.Cuisine_Type=s.Cuisine_Type
AND dsh.Category_Type=s.Category_Type;


--Check the fact table

SELECT * FROM fact_swiggy_orders;