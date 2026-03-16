--Use the created Swiggy_DB database

USE Swiggy_DB;
GO

--Creating Schema
--Dimension Tables

--Date Table

CREATE TABLE dim_date(
date_id INT IDENTITY(1,1) PRIMARY KEY,
Order_Date DATE,
Year INT,
Month INT,
Day INT,
Year_Month VARCHAR(8),
Year_Month_Sort INT,
Month_Name VARCHAR(20),
Quarter INT,
Week_Number INT,
Year_Week VARCHAR(8),
Year_Week_Sort INT,
Day_Number INT,
Day_of_Week VARCHAR(20),
Year_Day_of_Week VARCHAR(8),
Year_Day_of_Week_Sort INT,
Day_Type VARCHAR(10)
);

--Location Table

CREATE TABLE dim_location(
location_id INT IDENTITY(1,1) PRIMARY KEY,
State VARCHAR(100),
City VARCHAR(100),
Location VARCHAR(200)
);

--Restaurant Table

CREATE TABLE dim_restaurant(
restaurant_id INT IDENTITY(1,1) PRIMARY KEY,
Restaurant_Name VARCHAR(100)
);

--Category Table

CREATE TABLE dim_category(
category_id INT IDENTITY(1,1) PRIMARY KEY,
Category VARCHAR(100)
);

--Dish Table

CREATE TABLE dim_dish(
dish_id INT IDENTITY(1,1) PRIMARY KEY,
Dish_Name VARCHAR(200),
Food_Type VARCHAR(20),
Food_Type_Confidence VARCHAR(10),
Cuisine_Type VARCHAR(50),
Category_Type VARCHAR(50)
);

--Insert Date in Table

--dim_date

SET DATEFIRST 1;

INSERT INTO dim_date
(
Order_Date,
Year,
Month,
Day,
Year_Month,
Year_Month_Sort,
Month_Name,
Quarter,
Week_Number,
Year_Week,
Year_Week_Sort,
Day_Number,
Day_of_Week,
Year_Day_of_Week,
Year_Day_of_Week_Sort,
Day_Type
)

SELECT
DISTINCT 
Order_Date,
YEAR(Order_Date),
MONTH(Order_Date),
DAY(Order_Date),
CAST(YEAR(Order_Date) AS VARCHAR) + '-' + LEFT(DATENAME(MONTH,Order_Date),3),
YEAR(Order_Date) * 100 + MONTH(Order_Date),
DATENAME(MONTH,Order_Date),
DATEPART(QUARTER, Order_Date),
DATEPART(ISO_WEEK, Order_Date),
CAST(Year(Order_Date) AS VARCHAR) + '-W' + RIGHT('00' + CAST(DATEPART(ISO_WEEK, Order_Date) AS VARCHAR),2),
YEAR(Order_Date) * 100 + DATEPART(ISO_WEEK, Order_Date),
((DATEPART(WEEKDAY, Order_Date) + @@DATEFIRST - 2) % 7) + 1,
DATENAME(WEEKDAY, Order_Date),
CAST(YEAR(Order_Date) AS VARCHAR) + '-' + LEFT(DATENAME(WEEKDAY, Order_Date),3),
YEAR(Order_Date) * 100 + ((DATEPART(WEEKDAY, Order_Date) + @@DATEFIRST - 2) % 7) + 1,
CASE
    WHEN DATEPART(WEEKDAY, Order_Date) IN (6,7)
    THEN 'Weekend'
    ELSE 'Weekday'
END
FROM stg_swiggy_data;

--Check the date dimension

SELECT * FROM dim_date;

--dim_location

INSERT INTO dim_location(State,City,Location)
SELECT DISTINCT
State,
City,
Location
FROM stg_swiggy_data;

--Check the location dimension

SELECT * FROM dim_location;

--dim_restaurant

INSERT INTO dim_restaurant(Restaurant_Name)
SELECT DISTINCT
Restaurant_Name
FROM stg_swiggy_data;

--Check the restaurant dimension

SELECT * FROM dim_restaurant;

--dim_category

INSERT INTO dim_category(Category)
SELECT DISTINCT Category
FROM stg_swiggy_data;

--Check the category dimension

SELECT * FROM dim_category;

INSERT INTO dim_dish(Dish_Name, Food_Type, Food_Type_Confidence, Cuisine_Type, Category_Type)

SELECT DISTINCT
Dish_Name,
Food_Type,
Food_Type_Confidence,
Cuisine_Type,
Category_Type
FROM stg_swiggy_data;

--Check the dish dimension

SELECT * FROM dim_dish;