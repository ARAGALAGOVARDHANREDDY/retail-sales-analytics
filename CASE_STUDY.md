# Case Study: Retail Sales Analytics & Demand Forecasting

*How I used SQL, Python, and Power BI to find why a top-performing region was quietly losing money — and built a forecasting + segmentation system on top of it.*

---

## The Problem

A retail business (Superstore, ~9,994 orders, 2014–2017) had no clear answer to three questions:

1. **Where is profit actually being lost**, and why?
2. **What will demand look like next quarter**, so inventory and staffing can plan ahead?
3. **Which customers matter most**, and where should retention effort go?

I treated this as a self-directed analytics engagement — sourcing the data, building the full pipeline, and answering all three questions end-to-end.

---

## Approach

I deliberately used three tools together, each for what it's best at, rather than doing everything in one:

| Tool | Role |
|---|---|
| **SQL (MySQL)** | Source-of-truth data cleaning + fast, direct business-question answering |
| **Python** | Deeper statistical investigation, demand forecasting, machine-learning segmentation |
| **Power BI** | Turning the analysis into something a non-technical stakeholder could explore themselves |

---

## Finding #1 — A profitable-looking region was quietly bleeding margin

Querying the database by region showed **Central ranked #2 in sales volume** but had by far the **lowest profit margin (7.92%)** — almost half of the top region's (West, 14.94%).

Drilling into sub-categories with SQL window functions and CTEs isolated the cause: **Tables (-8.56% margin) and Bookcases (-3.02% margin)** were actively losing money.

**My first hypothesis** — that a handful of extreme, one-off discounts (50%+) were causing this — turned out to be *wrong* when I tested it in Python: only 36 of 319 Table orders had discounts that high. The **real driver was structural**: Tables carried a 26% *average* discount across 77% of all orders, and Bookcases a 21% average across 74% — moderate, routine discounting that thin base margins on bulky furniture simply couldn't absorb.

> **Business recommendation:** cap Furniture discounts below ~15%, or revisit base pricing on Tables/Bookcases specifically — the current policy is structurally unprofitable, not just occasionally over-discounted.

This finding mattered enough that I rebuilt it two different ways (SQL aggregation and Python correlation/outlier analysis) before trusting it — both agreed.

---

## Finding #2 — Demand forecasting: a lesson in matching model complexity to data

I built three forecasting models of increasing sophistication — a naive baseline, ARIMA, and Prophet — and evaluated them against 90 held-out days that included the November/December holiday spike identified in EDA.

| Model | RMSE | MAE |
|---|---|---|
| Baseline | $3,504 | $2,364 |
| ARIMA | $3,083 | $2,215 |
| **Prophet** | **$2,869** | **$2,026** |

Prophet won by ~18%, which lined up with what EDA predicted: Prophet is the only one of the three that explicitly models yearly seasonality, and the data had a clear, strong yearly pattern.

I also tested the same three models at **weekly granularity** — and the result flipped: the simple baseline won there, because only ~4 years of data gave ARIMA and Prophet too few full yearly cycles to reliably learn seasonality at that grain, causing them to overshoot. I kept this as a documented secondary finding rather than hiding it, because it's a genuinely important lesson: **more sophisticated models aren't automatically better — they need enough historical data to earn their complexity.**

---

## Finding #3 — Customer segments, validated two independent ways

I built an RFM (Recency, Frequency, Monetary) segmentation in SQL using `NTILE(5)` scoring, then **independently re-derived it in Python using K-Means clustering** on the same underlying features — a completely different, unsupervised method.

Both approaches agreed on the big picture: a small high-value "Champions" tier, a large mid-tier group, and a distinct "Lost/Churned" tier. That agreement is what gives me confidence the segments reflect real customer behavior, not an artifact of how I happened to score them.

They *disagreed* in one useful way: K-Means' Champions group was smaller and more extreme ($9,479 avg spend, 64 customers) than SQL's more generous cut ($5,249 avg spend, 109 customers) — worth knowing if this segmentation were ever used to target a marketing budget.

**Business recommendation:** prioritize the "At Risk" segment (still $4,231 avg spend, but recency has slipped) for win-back campaigns before they fully churn, and treat "Needs Attention" as the highest-leverage growth segment — it's the single largest revenue pool ($923K) despite modest per-customer value.

---

## The Dashboard

All of the above is packaged into a 3-page interactive Power BI dashboard: an executive overview, a regional/product deep-dive with drill-down filtering, and a forecast + segmentation page — built on a proper data model (including a dedicated date table for time-intelligence DAX) rather than flat, static exports.

---

## What This Project Demonstrates

- **SQL:** aggregations, window functions, CTEs, and segmentation logic written directly in the database — not just SELECT *
- **Python:** the full data-science loop — EDA, hypothesis testing (including *revising* a wrong hypothesis with evidence), time-series forecasting with model comparison, and unsupervised ML
- **Power BI:** proper data modeling, DAX time intelligence, and dashboard design that tells a story rather than displaying charts
- **Analytical judgment:** two examples of testing an assumption against data and updating the conclusion (the discount hypothesis, and the daily-vs-weekly forecasting granularity) — not just running tools and reporting whatever came out

---

## Tech Stack

`MySQL` · `Python (pandas, matplotlib, seaborn, pmdarima, Prophet, scikit-learn)` · `Power BI (DAX, Power Query)`

**Full repo, code, and dashboard:** [github.com/ARAGALAGOVARDHANREDDY/retail-sales-analytics](https://github.com/ARAGALAGOVARDHANREDDY/retail-sales-analytics)
