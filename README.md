# Swiggy Revenue Analytics & Forecasting

![Project Cover](images/business_overview.png)

End-to-end **Data Analytics and Revenue Forecasting project** analyzing Swiggy food delivery data using **SQL, Power BI, and Python (Facebook Prophet)**.

This project demonstrates how raw food delivery order data can be transformed into **business intelligence dashboards and predictive forecasting models**.

---

# Project Workflow

The project follows a **modern analytics pipeline**:

```
Raw Data
   │
   ▼
SQL Data Cleaning & Modeling
   │
   ▼
Power BI Business Intelligence Dashboard
   │
   ▼
Python Time Series Forecasting
   │
   ▼
Revenue Predictions & Business Insights
```

---

# Dataset

The dataset contains food delivery order data including:

* Order Date
* Restaurant Name
* City
* State
* Cuisine Type
* Food Category
* Order Price
* Customer Rating

The dataset was cleaned and structured using SQL before analytics and forecasting.

---

# 1️⃣ SQL Data Preparation

The first stage of the project focused on **data engineering and transformation** using SQL.

The SQL pipeline performs:

• table cleanup
• data cleaning
• dimension table creation
• fact table construction
• KPI analysis views

SQL files used in the project:

```
00_drop_tables.sql
01_data_cleaning.sql
02_dimension_tables.sql
03_fact_table.sql
04_kpi_analysis.sql
05_analytics_view.sql
```

These scripts transform the raw dataset into a **structured analytics dataset** suitable for BI dashboards and machine learning models.

---

# 2️⃣ Power BI Business Intelligence Dashboard

After preparing the dataset, Power BI was used to create **interactive dashboards for business analysis**.

---

## Business Overview

![Image](images/business_overview.png)

Key KPIs:

* Total Revenue
* Average Order Value
* Average Rating
* Total Orders
* Monthly Revenue Trend
* MoM Growth

---

## Food & Cuisine Insights

![Image](images/food_cuisine_insights.png)

Insights analyzed:

* Veg vs Non-Veg demand
* Cuisine popularity
* Category performance
* Dish-level revenue trends

---

## Geographic Performance

![Image](images/geographic_performance.png)

Geographic analysis includes:

* Revenue by State
* Orders by State
* Revenue by City

---

## Pricing & Spending Analysis

![Image](images/pricing_spending_analysis.png)

Customer spending behavior analyzed by:

* price category
* spending bucket
* restaurant pricing tiers

---

## Restaurant Performance

![Image](images/restaurant_performance.png)

Key insights include:

* top restaurants by revenue
* top restaurants by orders
* restaurant ranking
* rating comparison

---

## Week-Based Performance

![Image](images/week_based_performance.png)

Demand pattern analysis:

* weekday vs weekend revenue
* category demand by day
* spending patterns by day type

---

# 3️⃣ Python Revenue Forecasting

After analyzing historical data through dashboards, the next step was **predicting future revenue using machine learning**.

The forecasting model uses **Facebook Prophet**, a time-series forecasting library designed to capture:

* trend patterns
* seasonal effects
* demand fluctuations

The forecasting pipeline includes:

• data preprocessing
• time series aggregation
• feature engineering (weekend indicator)
• Prophet model training
• cross-validation evaluation

Forecasts generated:

```
Daily Revenue Forecast
Weekly Revenue Forecast
Monthly Revenue Forecast
Weekday vs Weekend Forecast
Restaurant Revenue Forecast
City Revenue Forecast
Cuisine Revenue Forecast
Category Revenue Forecast
Price Category Revenue Forecast
State Revenue Forecast
```

---

# Model Evaluation

Model accuracy was evaluated using **time-series cross-validation**.

Metrics used:

* MAE (Mean Absolute Error)
* RMSE (Root Mean Squared Error)
* MAPE (Mean Absolute Percentage Error)

These metrics measure the difference between predicted and actual revenue.

---

# Key Business Insights

Important insights discovered from the analysis:

1️⃣ Weekend demand is significantly higher than weekday demand

2️⃣ A few cities contribute a majority of revenue

3️⃣ Non-vegetarian food categories dominate demand

4️⃣ Premium price categories generate the highest revenue share

5️⃣ A small number of restaurants contribute disproportionately to total platform revenue

6️⃣ Revenue demand is expected to grow steadily based on forecasting results

---

# Project Structure

```
swiggy-revenue-forecasting
│
├── data
│   ├── raw
│   ├── processed
│   └── analytics
│
├── sql
│
├── dashboard
│
├── notebooks
│
├── src
│
├── forecasts
│
├── images
│
├── README.md
├── requirements.txt
├── LICENSE
└── .gitignore
```

---

# Future Improvements

Possible improvements:

* integrate real-time order data
* deploy forecasting model with Streamlit
* incorporate holiday / festival demand
* experiment with deep learning models (LSTM)

---

# Author

**Jaskar Jeyabalan S**

Email: [jaskarjeyabalan@gmail.com](mailto:jaskarjeyabalan@gmail.com)

---

# License

This project is licensed under the MIT License.
