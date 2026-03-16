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

![Image](https://media.licdn.com/dms/image/v2/D4D22AQFMkanhUyBbFQ/feedshare-shrink_800/B4DZhq2tmOHwAg-/0/1754139385040?e=2147483647\&t=kS5fgi6tETYzxzJINmd-fk2UQaEKvxCsT2-Ez5jUEyg\&v=beta)

![Image](https://media.licdn.com/dms/image/v2/D4D22AQFKnquh8zIEkw/feedshare-shrink_800/B4DZg8d4rqGQAk-/0/1753361130501?e=2147483647\&t=MNYApxh4jUPcON6Ow3wf5qadxqx9ax3wF0dxMelpXhY\&v=beta)

![Image](https://other-levels.com/cdn/shop/files/Restaurants-Sales-Analytics-Excel-Dashboard-Other-Levels-17244369.png?v=1759938831\&width=2688)

![Image](https://www.slideteam.net/media/catalog/product/cache/1280x720/f/o/food_and_beverages_revenue_analysis_dashboard_for_marketing_activities_for_fast_food_slide01.jpg)

Key KPIs:

* Total Revenue
* Average Order Value
* Average Rating
* Total Orders
* Monthly Revenue Trend
* MoM Growth

---

## Food & Cuisine Insights

![Image](https://www.inetsoft.com/images/website/online-food-delivery.PNG)

![Image](https://www.slideteam.net/media/catalog/product/cache/1280x720/f/o/food_delivery_restaurant_performance_tracking_dashboard_food_delivery_service_optimization_slide01.jpg)

![Image](https://dataflip.co/cdn/shop/files/PowerBIDashboardTemplatesforFoodDeliveryServices_1024x1024.jpg?v=1761398698)

![Image](https://user-images.githubusercontent.com/114581035/213843305-4f13141a-ddee-47e8-ae0a-6bd846e84ceb.png)

Insights analyzed:

* Veg vs Non-Veg demand
* Cuisine popularity
* Category performance
* Dish-level revenue trends

---

## Geographic Performance

![Image](https://media.licdn.com/dms/image/v2/D5622AQE1X0OGzT5-lg/feedshare-shrink_800/B56ZqQH_X7JsAk-/0/1763354606031?e=2147483647\&t=iLFl8EUpG77Sq0xMuO9MfS8Z_k3Fn5nsu7WMS98DsEo\&v=beta)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1400/1%2AGRKtcuVkQRdwb5tcdbw3xw.png)

![Image](https://www.googleapis.com/download/storage/v1/b/kaggle-user-content/o/inbox%2F28025666%2F2ced102cc1b4500f6f3e52b271cd6bbf%2FOnline%20Sales%20Dashboard.PNG?alt=media\&generation=1757671974876569)

![Image](https://media.licdn.com/dms/image/v2/D5622AQEuHDmIBmQpOQ/feedshare-shrink_800/B56ZfPS6uWHUAk-/0/1751529533312?e=2147483647\&t=EIMVdHCQeaGGGeqpNIC5TaRO3cnVQoTQqXmhsGgT8NA\&v=beta)

Geographic analysis includes:

* Revenue by State
* Orders by State
* Revenue by City

---

## Pricing & Spending Analysis

![Image](https://user-images.githubusercontent.com/114581035/213843305-4f13141a-ddee-47e8-ae0a-6bd846e84ceb.png)

![Image](https://www.slideteam.net/media/catalog/product/cache/1280x720/d/a/dashboard_to_track_sales_and_expenses_of_restaurant_online_promotion_plan_for_food_business_slide01.jpg)

![Image](https://miro.medium.com/v2/resize%3Afit%3A1400/1%2AuQ8vYB6584p-O9i46eDuMA.png)

![Image](https://repository-images.githubusercontent.com/591021797/3d25ddd6-0ef5-4df8-8168-4fc30b94bcd2)

Customer spending behavior analyzed by:

* price category
* spending bucket
* restaurant pricing tiers

---

## Restaurant Performance

![Image](https://miro.medium.com/v2/resize%3Afit%3A1400/1%2AuQ8vYB6584p-O9i46eDuMA.png)

![Image](https://www.inetsoft.com/images/website/online-food-delivery.PNG)

![Image](https://cdn.prod.website-files.com/62294553e9aeea20d15d7bc2/6798ab3ca1a6bbd3ca23212e_6798aa118ad1f36e1352a340_Staff%2520performance%2520dashbaord.webp)

![Image](https://www.slideteam.net/media/catalog/product/cache/1280x720/d/a/dashboard_to_track_sales_and_expenses_of_restaurant_online_promotion_plan_for_food_business_slide01.jpg)

Key insights include:

* top restaurants by revenue
* top restaurants by orders
* restaurant ranking
* rating comparison

---

## Week-Based Performance

![Image](https://dataflip.co/cdn/shop/files/PowerBIDashboardTemplatesforFoodDeliveryServices_400x.jpg?v=1761398698)

![Image](https://a.storyblok.com/f/66216/895x480/b7dee7b189/1.jpg/m/1440x0)

![Image](https://www.inetsoft.com/images/website/online-food-delivery.PNG)

![Image](https://repository-images.githubusercontent.com/591022881/cadda031-3c53-41c9-b26e-7451abe62746)

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
B.Sc Computer Science Graduate
Aspiring Data Scientist

Email: [jaskarjeyabalan@gmail.com](mailto:jaskarjeyabalan@gmail.com)

---

# License

This project is licensed under the MIT License.
