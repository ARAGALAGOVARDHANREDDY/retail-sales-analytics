# Retail Sales Analytics & Demand Forecasting

📄 **[Read the full case study →](./CASE_STUDY.md)**

End-to-end retail analytics project using **SQL, Python, and Power BI** on the Superstore dataset — covering data analysis, customer segmentation, demand forecasting, and an interactive dashboard.

🚧 **Project Status: In Progress** — SQL analysis, Python analysis, and Power BI dashboard complete. Case study write-up done — final polish ongoing.

---

## 📊 Project Overview

This project analyzes retail sales data to uncover business insights around profitability, customer behavior, and regional performance — then builds predictive models for demand forecasting and customer segmentation, and packages it all into an interactive dashboard.

**Dataset:** [Sample Superstore](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) (Kaggle) — 9,994 orders across Furniture, Office Supplies, and Technology categories (2014–2017).

**Tech Stack:** MySQL · Python (pandas, matplotlib, seaborn, pmdarima/ARIMA, Prophet, scikit-learn) · Power BI

---

## ✅ Phase 1: SQL Analysis

Located in [`/sql`](./sql/01_sql_analysis.sql)

Covers: aggregations, filtering, date functions, window functions (RANK, ROW_NUMBER, LAG), CTEs, and RFM customer segmentation.

### Key Insights

**Regional Profitability**
- West region leads in both sales ($725K) and profit margin (14.94%)
- Central region ranks #2 in sales but has the lowest margin (7.92%) — traced to Furniture sub-categories

**Loss-Making Product Lines**
- Tables: -8.56% margin (-$17.7K total loss) — biggest loss driver
- Bookcases: -3.02% margin
- Best performers: Copiers (37.2% margin), Labels (44.4% margin)

**Customer Segmentation (RFM Analysis)**
- Champions (109 customers): highest per-customer value at $5,249 avg spend
- "Needs Attention" (295 customers): largest segment by volume, contributing $923K total
- "At Risk" customers (60): still high-value ($4,231 avg spend) — priority for retention efforts

---

## ✅ Phase 2: Python Analysis (EDA, Forecasting, Segmentation)

Located in [`/python`](./python/02_analysis_and_forecasting.ipynb) | Exported data in [`/data`](./data)

### 2.1 Exploratory Data Analysis

**Sales Trend & Seasonality**
- Clear year-over-year growth in total sales (2014–2017)
- Strong seasonal pattern: sales spike sharply in Nov/Dec (holiday season), followed by a January dip

![Monthly Sales Trend](./python/monthly_sales_trend.png)

**Category & Region Performance** — confirmed SQL findings visually

![Category and Region Performance](./python/category_region_performance.png)

**Discount → Profit Investigation**
- Initial hypothesis (extreme 50%+ discounts driving Furniture losses) was tested and **revised** based on evidence
- Real driver: **widespread moderate discounting** — Tables (26% avg discount, 77% of orders discounted) and Bookcases (21% avg discount, 74% of orders discounted) operate on thin margins that can't absorb even moderate discounts
- Overall Discount–Profit correlation is weak (-0.22), but the effect is **highly category-specific** — high-margin categories (Copiers, Labels) absorb discounts easily; low-margin categories (Tables, Bookcases) do not

![Outlier Detection](./python/outlier_detection.png)
![Correlation Heatmap](./python/correlation_heatmap.png)

**Business Recommendation:** Cap discounts on Tables/Bookcases below ~15%, or review base pricing — current discount levels are structurally unprofitable for these sub-categories.

---

### 2.2 Demand Forecasting

Built and compared three forecasting models on daily sales data, holding out the final 90 days (including the Nov/Dec holiday season) as a test set.

| Model | RMSE | MAE |
|---|---|---|
| Baseline (flat average) | $3,504.16 | $2,363.99 |
| ARIMA (weekly seasonality) | $3,083.23 | $2,215.05 |
| **Prophet (weekly + yearly seasonality)** | **$2,869.22** | **$2,025.99** |

**Prophet performed best**, improving RMSE by ~18% over the baseline. This matches the seasonality pattern identified in EDA — Prophet's ability to explicitly model yearly holiday seasonality (unlike ARIMA, which was limited to weekly patterns) gave it an edge in predicting the holiday-season test period.

![Forecast Comparison](./python/forecast_comparison.png)

---

### 2.3 Customer Segmentation (K-Means Clustering)

Applied K-Means clustering (K=4, chosen via Elbow Method) on scaled RFM features, to independently validate the SQL-based RFM segmentation using unsupervised machine learning.

![Elbow Method](./python/elbow_method.png)

| Cluster | Customers | Avg Recency | Avg Frequency | Avg Monetary | Label |
|---|---|---|---|---|---|
| 2 | 64 | 123.7 days | 8.3 | $9,479.5 | Champions |
| 0 | 298 | 72.7 days | 8.5 | $3,322.2 | Loyal/Active |
| 1 | 335 | 101.2 days | 4.7 | $1,669.7 | Average/Occasional |
| 3 | 96 | 559.5 days | 3.7 | $1,470.2 | Lost/Churned |

![Customer Clusters](./python/customer_clusters.png)

**Validation finding:** K-Means independently confirmed the broad structure of the SQL RFM segmentation — a small high-value "Champions" tier, a large mid-tier group, and a distinct "Lost/Churned" tier — confirming these patterns reflect real underlying customer behavior. K-Means identified a smaller, higher-value Champions group ($9,479 avg) than the SQL NTILE approach ($5,249 avg), suggesting the SQL method may be more generous in labeling top-tier customers.

---

## ✅ Phase 3: Power BI Dashboard

A 3-page interactive dashboard built on the cleaned data and Python outputs, with proper data modeling (including a dedicated Date table for time intelligence), custom DAX measures, and a consistent Navy/Gold theme matching this repo's branding.

> **Note:** the `.pbix` file is in [`/powerbi/retail_sales_dashboard.pbix`](./powerbi) — download it and open in Power BI Desktop to explore interactively.

### Page 1: Executive Overview

KPI cards (Total Sales, Total Profit, Total Orders, Profit Margin %), a continuous daily sales trend line (2014-2017), and a Year-over-Year comparison chart built with time-intelligence DAX (`SAMEPERIODLASTYEAR`).

![Executive Overview](./powerbi/retail_sales_dashboard.pbix/overview.png)

### Page 2: Regional & Product Deep-Dive

Interactive Region and Sub-Category slicers, a Region profitability chart, a Sub-Category profit chart (clearly showing Tables, Bookcases, and Supplies in negative territory), and a drill-down Category → Sub-Category matrix — visualizing the same "why is Central underperforming" story from the SQL and Python analysis, now fully interactive.

![Regional Deep-Dive](./powerbi/retail_sales_dashboard.pbix/regional_deep_dive.png)

### Page 3: Forecast & Segmentation

The daily forecast comparison (Actual vs. Baseline vs. ARIMA vs. Prophet) recreated as an interactive chart, alongside a customer segment breakdown (donut chart + average RFM table per segment) matching the K-Means clustering results from Phase 2.

![Forecast and Segmentation](./powerbi/retail_sales_dashboard.pbix/forecast_segmentation.png)

### Key DAX Measures

```dax
Total Sales = SUM(superstore_cleaned[Sales])
Profit Margin % = DIVIDE([Total Profit], [Total Sales], 0)
Sales Last Year = CALCULATE([Total Sales], SAMEPERIODLASTYEAR(DateTable[Date]))
YoY Growth % = DIVIDE([Total Sales] - [Sales Last Year], [Sales Last Year], 0)
```

**Technical note:** Time intelligence measures required building a dedicated, continuous `DateTable` (via `CALENDAR()`, marked as an official Date Table) rather than relying on the raw `Order Date` column — a standard Power BI practice, since `SAMEPERIODLASTYEAR()` and `DATEADD()` need a gapless calendar to shift dates correctly.

