# Retail Sales Analytics & Demand Forecasting

End-to-end retail analytics project using **SQL, Python, and Power BI** on the Superstore dataset — covering data analysis, customer segmentation, demand forecasting, and interactive dashboarding.

🚧 **Project Status: In Progress** — SQL analysis and Python EDA complete. Forecasting models, clustering, and Power BI dashboard coming next.

---

## 📊 Project Overview

This project analyzes retail sales data to uncover business insights around profitability, customer behavior, and regional performance — and builds toward demand forecasting and an interactive dashboard.

**Dataset:** [Sample Superstore](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) (Kaggle) — 9,994 orders across Furniture, Office Supplies, and Technology categories.

**Tech Stack:** MySQL · Python (pandas, matplotlib, seaborn, Prophet, ARIMA, scikit-learn) · Power BI

---

## ✅ Phase 1: SQL Analysis

Located in [`/sql`](./sql/01_sql_analysis.sql)

Covers: aggregations, filtering, date functions, window functions (RANK, ROW_NUMBER, LAG), CTEs, and RFM customer segmentation.

### Key Insights

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

## ✅ Phase 2: Python EDA

Located in [`/python`](./python/02_eda_analysis.ipynb)

Exploratory data analysis using pandas, matplotlib, and seaborn — validating SQL findings visually and investigating root causes of profitability issues.

### Key Findings

**Sales Trend & Seasonality**
- Clear year-over-year growth in total sales (2015–2018)
- Strong seasonal pattern: sales spike sharply in Nov/Dec (holiday season), followed by a January dip

![Monthly Sales Trend](./python/images/monthly_sales_trend.png)

**Category & Region Performance**
- Python visualizations confirmed SQL findings — West/East regions lead in sales, Tables/Bookcases show negative profit

![Category and Region Performance](./python/images/category_region_performance.png)

**Discount → Profit Investigation**
- Initial hypothesis (extreme 50%+ discounts driving Furniture losses) was tested and **revised** based on evidence
- Real driver: **widespread moderate discounting** — Tables (26% avg discount, 77% of orders discounted) and Bookcases (21% avg discount, 74% of orders discounted) operate on thin margins that can't absorb even moderate discounts
- Overall Discount–Profit correlation is weak (-0.22) across all categories, but the effect is **highly category-specific** — high-margin categories (Copiers, Labels) absorb discounts easily, while low-margin categories (Tables, Bookcases) do not

![Outlier Detection](./python/images/outlier_detection.png)
![Correlation Heatmap](./python/images/correlation_heatmap.png)

**Business Recommendation:** Cap discounts on Tables/Bookcases below ~15%, or review base pricing — current discount levels are structurally unprofitable for these sub-categories.

---

## 🔜 Coming Next

- [x] Phase 1: SQL Analysis
- [x] Phase 2: Python EDA
- [ ] Phase 2: Demand Forecasting (ARIMA, Prophet, model comparison)
- [ ] Phase 2: Customer segmentation via K-Means clustering
- [ ] Phase 3: Power BI interactive dashboard
- [ ] Phase 4: Full case study write-up

---

## 📁 Repo Structure
\```
/sql
   01_sql_analysis.sql
/python
   02_eda_analysis.ipynb
   /images
      monthly_sales_trend.png
      category_region_performance.png
      outlier_detection.png
      correlation_heatmap.png
\```
