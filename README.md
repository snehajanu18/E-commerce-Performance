# E-commerce-Performance
This project analyzes an e-commerce dataset to understand operational performance and customer behavior. Using SQL for data processing and Tableau for visualization, the analysis focuses on key areas such as delivery efficiency, customer growth, and service quality. Two interactive dashboards were created to highlight trends .

## Dataset Summary
- Source: Olist Brazilian E-commerce dataset  
- Size: ~100,000 orders (2016–2018)  
- Tables:
  - Orders (timestamps, status)
  - Customers (location)
  - Order Items (products, sellers)
  - Payments (order value)
  - Reviews (customer feedback) :contentReference[oaicite:1]{index=1}

---

## Tech Stack
- Python (Pandas)
- PostgreSQL (SQL)
- Tableau

---

## Exploratory Data Analysis (Python)
- Loaded CSV files into DataFrames  
- Performed structure and data inspection  
- Handled missing values  
- Prepared data for database integration :contentReference[oaicite:2]{index=2}

---

## Database Integration
- Data loaded into PostgreSQL using Python (SQLAlchemy)  
- Tables created for structured querying :contentReference[oaicite:3]{index=3}

---

## Data Analysis (SQL)
Key analyses performed:
- Monthly revenue trend  
- Yearly revenue growth  
- Top 10 product categories by revenue  
- Monthly unique customers  
- Repeat purchase rate (~3%)  
- Delivery delay percentage (~8.11%)  
- State-wise delivery time :contentReference[oaicite:4]{index=4}

---

## Tableau Dashboards

### 1. Executive Revenue Overview
Focus: business performance and delivery efficiency  

Includes:
- Monthly revenue trend  
- Yearly growth KPI  
- Top categories by revenue  
- Revenue by state  
- Delayed delivery % :contentReference[oaicite:5]{index=5}

---

### 2. Customer & Experience Overview
Focus: customer behavior and satisfaction  

Includes:
- Monthly unique customers  
- Repeat purchase rate  
- Delivery delay impact on reviews  
- Top states by delivery time :contentReference[oaicite:6]{index=6}

---

## Key Insights
- Revenue shows steady growth over time  
- Repeat purchase rate is low (~3%)  
- Delivery delays (~8%) negatively impact customer reviews  
- Certain states have significantly higher delivery times  
- Top categories drive majority of revenue :contentReference[oaicite:7]{index=7}

---

## Business Recommendations
- Improve delivery performance in high-delay regions  
- Increase customer retention (loyalty programs, offers)  
- Optimize inventory and pricing in weak categories  
- Scale high-performing categories  
- Monitor and control low-rated sellers  
- Improve communication with customers :contentReference[oaicite:8]{index=8}

---
