-- Selecting the Swiggy project database to begin the data preparation process
USE Swiggy_DB;
GO

-- After import check the data

SELECT * FROM raw_swiggy_data;

-- Data Validation & Cleaning

-- Checking for missing values across key business fields such as location, order date, and pricing.
-- This helps identify incomplete records that may impact analysis accuracy.

-- Null Value Assessment:

-- We are performing a null check across all critical columns to understand the extent of missing data.
-- Numerical columns such as Price_INR, Rating, and Rating_Count are retained as NULL
-- to preserve analytical integrity, as replacing them with 0 may distort business insights
-- (e.g., Rating = 0 implies poor feedback, while NULL indicates no rating provided).
-- Categorical nulls have already been handled by replacing with 'Unknown'.

SELECT
	SUM(CASE WHEN State IS NULL THEN 1 ELSE 0 END) AS null_state,
	SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city,
	SUM(CASE WHEN Order_Date IS NULL THEN 1 ELSE 0 END) AS null_order_date,
	SUM(CASE WHEN Restaurant_Name IS NULL THEN 1 ELSE 0 END) AS null_restaurant,
	SUM(CASE WHEN Location IS NULL THEN 1 ELSE 0 END) AS null_location,
	SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS null_category,
	SUM(CASE WHEN Dish_Name IS NULL THEN 1 ELSE 0 END) AS null_dish,
	SUM(CASE WHEN Price_INR IS NULL THEN 1 ELSE 0 END) AS null_price,
	SUM(CASE WHEN Rating IS NULL THEN 1 ELSE 0 END) AS null_rating,
	SUM(CASE WHEN Rating_Count IS NULL THEN 1 ELSE 0 END) AS null_rating_count
FROM raw_swiggy_data;

-- Blank or Empty Strings

SELECT * 
FROM raw_swiggy_data
WHERE
State ='' OR City='' OR Restaurant_Name='' OR Category='' OR Dish_Name='';

-- Creating a staging table from raw data.
-- This allows us to clean and transform the data without affecting the original dataset.

CREATE TABLE stg_swiggy_data (
ID INT IDENTITY(1,1) PRIMARY KEY,
State VARCHAR(150) NULL,
City VARCHAR(150) NULL,
Order_Date DATE NULL,
Restaurant_Name VARCHAR(150) NULL,
Location VARCHAR(150) NULL,
Category VARCHAR(150) NULL,
Dish_Name VARCHAR(200) NULL,
Price_INR FLOAT NULL,
Rating FLOAT NULL,
Rating_Count SMALLINT NULL
);

-- Cleaning and transforming data while copying from raw to staging table.

INSERT INTO stg_swiggy_data(State, City, Order_Date, Restaurant_Name, Location, Category, Dish_Name, Price_INR, Rating, Rating_Count)

SELECT
COALESCE(NULLIF(LTRIM(RTRIM(State)),''),'Unknown'),
COALESCE(NULLIF(LTRIM(RTRIM(City)),''),'Unknown'),
TRY_CAST(Order_Date AS DATE),
COALESCE(NULLIF(LTRIM(RTRIM(Restaurant_Name)),''),'Unknown'),
COALESCE(NULLIF(LTRIM(RTRIM(Location)),''),'Unknown'),
COALESCE(NULLIF(LTRIM(RTRIM(Category)),''),'Unknown'),
COALESCE(NULLIF(LTRIM(RTRIM(Dish_Name)),''),'Unknown'),
TRY_CAST(Price_INR AS FLOAT),

CASE 
    WHEN TRY_CAST(Rating AS FLOAT) > 5 THEN 5
    ELSE TRY_CAST(Rating AS FLOAT)
END,

TRY_CAST(Rating_Count AS SMALLINT)
FROM raw_swiggy_data;

-- Check the copy data

SELECT * FROM stg_swiggy_data;

-- Identifying duplicate order records based on customer location, restaurant, dish, and pricing details.
-- Duplicate records may distort total sales and order count insights.

SELECT
State, City, Order_Date, Restaurant_Name, Location, Category,
Dish_Name, Price_INR, Rating, Rating_Count, COUNT(*) AS CNT
FROM stg_swiggy_data
GROUP BY
State, City, Order_Date, Restaurant_Name, Location, Category,
Dish_Name, Price_INR, Rating, Rating_Count
HAVING COUNT(*)>1;

-- Removing duplicate records while retaining one unique order entry.
-- This helps maintain accurate business metrics such as revenue and order volume.

WITH CTE AS ( SELECT *, 
ROW_NUMBER() Over(
PARTITION BY State, City, Order_Date, 
Restaurant_Name, Location, Category, Dish_Name,
Price_INR, Rating, Rating_Count
ORDER BY Order_Date DESC
) AS RN FROM stg_swiggy_data ) DELETE FROM CTE WHERE RN>1;

-- Standardizing dish names by converting all text to lowercase.
-- This avoids mismatches caused by inconsistent naming formats (e.g., "Pizza" vs "pizza").

UPDATE stg_swiggy_data
SET Dish_Name = LOWER(Dish_Name);

-- Correcting spelling mistakes in dish names.
-- This improves the accuracy of Veg/Non-Veg and Cuisine classification.

UPDATE stg_swiggy_data
SET Dish_Name =
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
Dish_Name,
'chciken','chicken'),
'panneer','paneer'),
'panner','paneer'),
'briyani','biryani'),
'biriyani','biryani'),
'bryani','biryani'),
'lolypop','lollipop'),
'hydrabadi','hyderabadi'),
'hyderabadhi','hyderabadi'),
'chowmin','chowmein'),
'fride','fried'),
'burji','bhurji'),
' masla ',' masala '),
'shezwan','schezwan'),
'channa bathura','chole bhature'),
'chana bathura','chole bhature'),
'kheema','keema'),
'choclate','chocolate'),
'idly','idli'),
'parrota','parotta'),
'makkanvala','makhanwala'),
'tutty fruity','tutti frutti'),
'vanila','vanilla'),
'strawbery','strawberry'),
'bluebery','blueberry'),
'kuma','kurma'),
'nan','naan'),
'manchurain','manchurian');

--Check the cleaned Dish_Name

SELECT DISTINCT Dish_Name FROM stg_swiggy_data;

-- Classifying dishes as Veg or Non-Veg based on dish name keywords.
-- This allows comparison of vegetarian and non-vegetarian order trends.
-- Add Food Type Column in Raw Data (Veg / Non-Veg)

ALTER TABLE stg_swiggy_data
ADD Food_Type VARCHAR(20);

-- Update Food Type based on Dish Name Keywords

UPDATE stg_swiggy_data
SET Food_Type = 
CASE

-- Classify as Non-Veg if Dish Name contains keywords related to non-vegetarian items

WHEN Dish_Name LIKE '%non veg%' OR Dish_Name LIKE '%non-veg%'
     OR Dish_Name LIKE '%chicken%' OR Dish_Name LIKE '%mutton%'
     OR Dish_Name LIKE '%egg%' OR Dish_Name LIKE '%fish%'
     OR Dish_Name LIKE '%prawn%' OR Dish_Name LIKE '%lamb%'
     OR Dish_Name LIKE '%bacon%' OR Dish_Name LIKE '%pepperoni%'
     OR Dish_Name LIKE '%sausage%' OR Dish_Name LIKE '%omelette%'
     OR Dish_Name LIKE '%keema%' OR Dish_Name LIKE '%wings%'
     OR Dish_Name LIKE '%bucket%' OR Dish_Name LIKE '%zinger%'
     OR Dish_Name LIKE '%mcspicy%' OR Dish_Name LIKE '%whopper%'
THEN 'Non-Veg'

-- Classify as Veg if Dish Name contains keywords related to vegetarian items

WHEN Dish_Name LIKE '%veg%' OR Dish_Name LIKE '%vegtarian%'
     OR Dish_Name LIKE '%veggie%' OR Dish_Name LIKE '%paneer%'
     OR Dish_Name LIKE '%mushroom%' OR Dish_Name LIKE '%aloo%'
     OR Dish_Name LIKE '%gobi%' OR Dish_Name LIKE '%corn%'
     OR Dish_Name LIKE '%palak%' OR Dish_Name LIKE '%dal%'
     OR Dish_Name LIKE '%rajma%' OR Dish_Name LIKE '%chole%'
     OR Dish_Name LIKE '%tofu%' OR Dish_Name LIKE '%soya%'
     OR Dish_Name LIKE '%poori%' OR Dish_Name LIKE '%tikki%'
THEN 'Veg'

-- Classify remaining as Unknown if no keywords found

ELSE 'Unknown'
END
WHERE Food_Type IS NULL;

--Check the added column

SELECT Food_Type FROM stg_swiggy_data;

-- Assigning confidence levels to the Veg/Non-Veg classification based on the presence of specific keywords.

ALTER TABLE stg_swiggy_data
ADD Food_Type_Confidence VARCHAR(10);

-- Update Food_Type_Confidence based on Food_Type

UPDATE stg_swiggy_data
SET Food_Type_Confidence =
CASE
    WHEN Food_Type = 'Non-Veg'
        AND (
            Dish_Name LIKE '%chicken%' OR
            Dish_Name LIKE '%mutton%' OR
            Dish_Name LIKE '%fish%' OR
            Dish_Name LIKE '%prawn%' OR
            Dish_Name LIKE '%egg%' OR
            Dish_Name LIKE '%bacon%' OR
            Dish_Name LIKE '%sausage%' OR
            Dish_Name LIKE '%kebab%' OR
            Dish_Name LIKE '%tikka%' OR
            Dish_Name LIKE '%keema%' OR
            Dish_Name LIKE '%wings%'
        )
    THEN 'High'

    WHEN Food_Type = 'Veg'
        AND (
            Dish_Name LIKE '%paneer%' OR
            Dish_Name LIKE '%mushroom%' OR
            Dish_Name LIKE '%aloo%' OR
            Dish_Name LIKE '%gobi%' OR
            Dish_Name LIKE '%dal%' OR
            Dish_Name LIKE '%rajma%' OR
            Dish_Name LIKE '%chole%'
        )
    THEN 'Medium'

    ELSE 'Low'
END;

-- Check the confidence levels

SELECT Food_Type, Food_Type_Confidence FROM stg_swiggy_data;

-- Categorizing dishes into Cuisine Types such as South Indian, Chinese, Fast Food, etc.
-- This helps analyze customer preference across different food styles.
--Add Cuisine_Type Column based on Dish_Name keywords

ALTER TABLE stg_swiggy_data
ADD Cuisine_Type VARCHAR(50);

--Update Cuisine_Type based on Dish_Name keywords

UPDATE stg_swiggy_data
SET Cuisine_Type =
CASE

-- Beverages
WHEN Dish_Name LIKE '%juice%' OR Dish_Name LIKE '%shake%'
     OR Dish_Name LIKE '%lassi%' OR Dish_Name LIKE '%coffee%'
     OR Dish_Name LIKE '%tea%' OR Dish_Name LIKE '%soda%'
     OR Dish_Name LIKE '%mojito%' OR Dish_Name LIKE '%milkshake%'
     OR Dish_Name LIKE '%badam milk%' OR Dish_Name LIKE '%cooler%'
     OR Dish_Name LIKE '%sharbat%' OR Dish_Name LIKE '%smoothie%'
     OR Dish_Name LIKE '%coke%' OR Dish_Name LIKE '%pepsi%'
     OR Dish_Name LIKE '%fanta%' OR Dish_Name LIKE '%7up%'
THEN 'Beverage'

-- Desserts
WHEN Dish_Name LIKE '%ice cream%' OR Dish_Name LIKE '%cake%'
     OR Dish_Name LIKE '%brownie%' OR Dish_Name LIKE '%halwa%'
     OR Dish_Name LIKE '%jamun%' OR Dish_Name LIKE '%rasgulla%'
     OR Dish_Name LIKE '%laddu%' OR Dish_Name LIKE '%barfi%'
     OR Dish_Name LIKE '%peda%' OR Dish_Name LIKE '%kulfi%'
     OR Dish_Name LIKE '%falooda%' OR Dish_Name LIKE '%mousse%'
     OR Dish_Name LIKE '%sundae%' OR Dish_Name LIKE '%cheesecake%'
     OR Dish_Name LIKE '%chocolate%'
THEN 'Dessert'

-- Biryani
WHEN Dish_Name LIKE '%biryani%'
THEN 'Biryani'

-- Korean
WHEN Dish_Name LIKE '%korean%'
THEN 'Korean'

-- Chinese
WHEN Dish_Name LIKE '%noodles%' OR Dish_Name LIKE '%fried rice%'
     OR Dish_Name LIKE '%manchurian%' OR Dish_Name LIKE '%schezwan%'
     OR Dish_Name LIKE '%hakka%' OR Dish_Name LIKE '%chilli%'
THEN 'Chinese'

-- South Indian
WHEN Dish_Name LIKE '%dosa%' OR Dish_Name LIKE '%idli%'
     OR Dish_Name LIKE '%vada%' OR Dish_Name LIKE '%appam%'
     OR Dish_Name LIKE '%puttu%' OR Dish_Name LIKE '%rasam%'
     OR Dish_Name LIKE '%sambar%' OR Dish_Name LIKE '%poori%'
     OR Dish_Name LIKE '%upma%' OR Dish_Name LIKE '%akki roti%'
     OR Dish_Name LIKE '%pongal%' OR Dish_Name LIKE '%meals%'
THEN 'South Indian'

-- North Indian
WHEN Dish_Name LIKE '%naan%' OR Dish_Name LIKE '%kulcha%'
     OR Dish_Name LIKE '%paratha%' OR Dish_Name LIKE '%korma%'
     OR Dish_Name LIKE '%makhani%'
THEN 'North Indian'

-- Fast Food
WHEN Dish_Name LIKE '%pizza%' OR Dish_Name LIKE '%burger%'
     OR Dish_Name LIKE '%pasta%' OR Dish_Name LIKE '%fries%'
     OR Dish_Name LIKE '%sandwich%' OR Dish_Name LIKE '%wrap%'
     OR Dish_Name LIKE '%roll%' OR Dish_Name LIKE '%shawarma%'
     OR Dish_Name LIKE '%taco%' OR Dish_Name LIKE '%nachos%'
     OR Dish_Name LIKE '%momo%' OR Dish_Name LIKE '%burrito%'
     OR Dish_Name LIKE '%zinger%' OR Dish_Name LIKE '%whopper%'
     OR Dish_Name LIKE '%mcspicy%' OR Dish_Name LIKE '%mcaloo%'
     OR Dish_Name LIKE '%bucket%' OR Dish_Name LIKE '%evm%'
THEN 'Fast Food'

-- Others
ELSE 'Others'
END;

--Check the added column

SELECT Cuisine_Type FROM stg_swiggy_data;

-- Categorizing dishes based on their role in a meal such as Starter, Snacks, Main Course, or Beverage.
-- This enables analysis of customer consumption patterns.
--Add Category_Type Column based on Dish_Name keywords

ALTER TABLE stg_swiggy_data
ADD Category_Type VARCHAR(50);

--Update Category_Type based on Dish_Name keywords

UPDATE stg_swiggy_data
SET Category_Type =
CASE

-- Breakfast
WHEN Dish_Name LIKE '%dosa%' OR Dish_Name LIKE '%idli%'
     OR Dish_Name LIKE '%vada%' OR Dish_Name LIKE '%upma%'
     OR Dish_Name LIKE '%appam%' OR Dish_Name LIKE '%puttu%'
     OR Dish_Name LIKE '%pongal%' OR Dish_Name LIKE '%akki roti%'
     OR Dish_Name LIKE '%poori%'
THEN 'Breakfast Item'

-- Snacks
WHEN Dish_Name LIKE '%chips%'
OR Dish_Name LIKE '%papad%'
OR Dish_Name LIKE '%nachos%'
OR Dish_Name LIKE '%popcorn%'
OR Dish_Name LIKE '%pakoda%'
OR Dish_Name LIKE '%peanuts%'
OR Dish_Name LIKE '%fries%'
OR Dish_Name LIKE '%murukku%'
OR Dish_Name LIKE '%mixture%'
THEN 'Snacks'

-- Soup
WHEN Dish_Name LIKE '%soup%'
THEN  'Soup'

-- Bread
WHEN Dish_Name LIKE '%naan%' OR Dish_Name LIKE '%roti%'
     OR Dish_Name LIKE '%chapati%' OR Dish_Name LIKE '%kulcha%'
     OR Dish_Name LIKE '%paratha%'
THEN 'Bread'

-- Main Course
WHEN Dish_Name LIKE '%biryani%' OR Dish_Name LIKE '%rice%'
     OR Dish_Name LIKE '%pulav%' OR Dish_Name LIKE '%pulao%'
     OR Dish_Name LIKE '%noodles%' OR Dish_Name LIKE '%curry%'
     OR Dish_Name LIKE '%dal%' OR Dish_Name LIKE '%parota%'
     OR Dish_Name LIKE '%meals%' OR Dish_Name LIKE '%thali%'
     OR Dish_Name LIKE '%shawarma%' OR Dish_Name LIKE '%wrap%'
     OR Dish_Name LIKE '%roll%' OR Dish_Name LIKE '%burger%'
     OR Dish_Name LIKE '%pizza%' OR Dish_Name LIKE '%pasta%'
     OR Dish_Name LIKE '%dum%' OR Dish_Name LIKE '%makhani%'
     OR Dish_Name LIKE '%sandwich%'
THEN 'Main Course'

-- Starter
WHEN Dish_Name LIKE '%wings%' OR Dish_Name LIKE '%lollipop%'
     OR Dish_Name LIKE '%tikka%' OR Dish_Name LIKE '%kebab%'
     OR Dish_Name LIKE '%nuggets%' OR Dish_Name LIKE '%popcorn chicken%'
     OR Dish_Name LIKE '%chilli chicken%' OR Dish_Name LIKE '%manchurian%'
     OR Dish_Name LIKE '%seekh%' OR Dish_Name LIKE '%tangdi%'
     OR Dish_Name LIKE '%finger%' OR Dish_Name LIKE '%65%'
     OR Dish_Name LIKE '%fingers%' OR Dish_Name LIKE '%fry%'
     OR Dish_Name LIKE '%pepper%' OR Dish_Name LIKE '%chilli%'
     OR Dish_Name LIKE '%tandoori%' OR Dish_Name LIKE '%grilled%'
     OR Dish_Name LIKE '%peri%' OR Dish_Name LIKE '%crispy%'
THEN 'Starter'

-- Side Dish
WHEN Dish_Name LIKE '%salad%' OR Dish_Name LIKE '%raitha%'
     OR Dish_Name LIKE '%pickle%' OR Dish_Name LIKE '%dip%'
     OR Dish_Name LIKE '%chutney%' OR Dish_Name LIKE '%sauce%'
     OR Dish_Name LIKE '%salan%' OR Dish_Name LIKE '%podi%'
     OR Dish_Name LIKE '%curd%'
THEN 'Side Dish'

-- Desserts
WHEN Cuisine_Type = 'Dessert'
THEN 'Dessert'

-- Beverages
WHEN Cuisine_Type = 'Beverage'
THEN 'Beverage'

-- Others
ELSE 'Others'
END;

-- Update Dish_Name to Proper Case for better readability in analysis and reporting.

UPDATE s
SET Dish_Name = p.Proper_Dish_Name
FROM stg_swiggy_data s
CROSS APPLY (
    SELECT STRING_AGG(
        UPPER(LEFT(value,1)) + LOWER(SUBSTRING(value,2,LEN(value))),
        ' '
    ) AS Proper_Dish_Name
    FROM STRING_SPLIT(s.dish_name,' ')
) p
WHERE s.dish_name IS NOT NULL;

-- Check the updated Dish_Name

SELECT Dish_Name FROM stg_swiggy_data;

-- Categorizing dishes into Low, Medium, and Premium price segments.
-- This helps understand customer spending behavior.
-- Add Price_Category Column

ALTER TABLE stg_swiggy_data
ADD Price_Category VARCHAR(20);

-- Update Price_Category based on Price_INR using CASE statement

DECLARE @P33 FLOAT, @P66 FLOAT;

SELECT TOP 1
@P33 = PERCENTILE_CONT(0.33) WITHIN GROUP (ORDER BY Price_INR) OVER(),
@P66 = PERCENTILE_CONT(0.66) WITHIN GROUP (ORDER BY Price_INR) OVER()
FROM stg_swiggy_data
WHERE Price_INR IS NOT NULL;

UPDATE stg_swiggy_data
SET Price_Category =
CASE
    WHEN Price_INR IS NULL THEN 'Unknown'
    WHEN @P33 IS NULL OR @P66 IS NULL THEN 'Unknown'
    WHEN Price_INR <= @P33 THEN 'Low'
    WHEN Price_INR <= @P66 THEN 'Medium'
    ELSE 'Premium'
END;

--Check the price category

SELECT Price_INR, Price_Category FROM stg_swiggy_data;

-- Classifying orders as Rated or Not Rated.
-- This helps analyze customer feedback participation.
-- Add Rating_Flag Column (Rated / Not Rated)

ALTER TABLE stg_swiggy_data
ADD Rating_Status VARCHAR(15);

--Update Rating_Statue based on Rating using CASE statement

UPDATE stg_swiggy_data
SET Rating_Status =
CASE
    WHEN Rating IS NULL THEN 'Not Rated'
    ELSE 'Rated'
END;

--Check the rating status

SELECT Rating, Rating_Status FROM stg_swiggy_data;

-- Final cleaned and transformed dataset ready for analysis.


SELECT * FROM stg_swiggy_data;