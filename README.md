# Retail Sales Analytics & Demand Forecasting

End-to-end retail analytics project using **SQL, Python, and Power BI** on the Superstore dataset — covering data analysis, customer segmentation, demand forecasting, and interactive dashboarding.

🚧 **Project Status: In Progress** — SQL analysis phase complete. Python (EDA + Forecasting) and Power BI dashboard coming next.

---

## 📊 Project Overview

This project analyzes retail sales data to uncover business insights around profitability, customer behavior, and regional performance — and builds toward demand forecasting and an interactive dashboard.

**Dataset:** [Sample Superstore](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) (Kaggle) — 9,994 orders across Furniture, Office Supplies, and Technology categories.

**Tech Stack:** MySQL · Python (pandas, Prophet, ARIMA) · Power BI

---

## ✅ Phase 1: SQL Analysis (Complete)

Located in [`/sql`](./sql/01_sql_analysis.sql)

Covers: aggregations, filtering, date functions, window functions (RANK, ROW_NUMBER, LAG), CTEs, and RFM customer segmentation.

### Key Insights So Far

**Regional Profitability**
- West region leads in both sales ($725K) and profit margin (14.94%)
- Central region ranks #2 in sales but has the lowest margin (7.92%) — investigation traced this to Furniture sub-categories

**Loss-Making Product Lines**
- Tables: -8.56% margin (-$17.7K total loss) — biggest loss driver
- Bookcases: -3.02% margin
- Best performers: Copiers (37.2% margin), Labels (44.4% margin)

**Customer Segmentation (RFM Analysis)**
- Champions (109 customers): highest per-customer value at $5,249 avg spend
- "Needs Attention" (295 customers): largest segment by volume, contributing $923K total — a key opportunity for engagement campaigns
- "At Risk" customers (60): still high-value ($4,231 avg spend) — priority for retention efforts

---

## 🔜 Coming Next

- [ ] Phase 2: Python EDA + Demand Forecasting (ARIMA, Prophet, model comparison)
- [ ] Phase 2: Customer segmentation via K-Means clustering
- [ ] Phase 3: Power BI interactive dashboard
- [ ] Phase 4: Full case study write-up

---

## 📁 Repo Structure
\```
/sql
   01_sql_analysis.sql
\```
