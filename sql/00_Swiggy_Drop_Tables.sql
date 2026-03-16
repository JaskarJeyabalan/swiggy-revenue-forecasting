--Use the created Swiggy_DB database

USE Swiggy_DB;
GO

-- Delete existing tables if they exist before creating new ones

DROP TABLE IF EXISTS fact_swiggy_orders;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_location;
DROP TABLE IF EXISTS dim_restaurant;
DROP TABLE IF EXISTS dim_category;
DROP TABLE IF EXISTS dim_dish;
DROP TABLE IF EXISTS stg_swiggy_data;
DROP VIEW IF EXISTS vw_swiggy_analytics;
GO