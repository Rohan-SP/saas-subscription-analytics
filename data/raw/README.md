# SaaS Subscription Analytics & Churn Analysis

An end-to-end analytics project that transforms raw SaaS operational data into clean analytical tables, core business metrics, cohort analyses, and churn insights.  
The project demonstrates realistic data cleaning, SQL-based analysis, and business-oriented interpretation suitable for data analyst and product analytics roles.

---

## Project Overview

This project analyzes a fictional SaaS company’s subscription business to answer key questions:

- How does **revenue (MRR)** evolve over time?
- How well do customers **retain** by signup cohort?
- How does **feature adoption** evolve across cohorts?
- What are the **drivers of churn**?
- Is churn driven by low usage, poor support, or customer value?

The full workflow mirrors real-world analytics work:  
**raw data → data quality checks → cleaned tables → business metrics → cohort analysis → insights & dashboarding**.

---

## Data Sources

Raw CSV files (located in `data/raw/`):

- `ravenstack_accounts.csv` – account metadata
- `ravenstack_subscriptions.csv` – subscription lifecycle & revenue
- `ravenstack_churn_events.csv` – churn events and reasons
- `ravenstack_feature_usage.csv` – feature usage activity
- `ravenstack_support_tickets.csv` – support interactions

Cleaned outputs are stored in `data/processed/`.

---

## Tech Stack

- **SQL:** DuckDB  
- **Python:** Pandas, NumPy  
- **Visualization:** Matplotlib, Seaborn  
- **Environment:** Jupyter Notebooks  
- **Data Storage:** DuckDB (`saas.db`)


---

## Workflow

### 1. Data Quality Checks
- Validated date formats and ranges
- Detected duplicates and missing values
- Identified invalid numeric values
- Checked referential integrity across tables

### 2. Data Cleaning
- Standardized categorical fields
- Corrected date inconsistencies
- Removed or flagged invalid records
- Produced clean, analysis-ready tables:
  - `accounts_clean`
  - `subscriptions_clean`
  - `churn_events_clean`
  - `feature_usage_clean`
  - `support_tickets_clean`

### 3. Business Metrics
- Monthly Recurring Revenue (MRR)
- Active accounts per month
- Churn rate and retention rate
- Feature usage distributions
- Support volume and resolution times

### 4. Cohort Analysis
- **Retention by signup cohort**
- **Feature adoption by cohort**
- **Churn by cohort**
- Visualized using cohort heatmaps

### 5. Churn Driver Analysis
- Aggregated account-level features:
  - Usage activity
  - Support experience
  - Revenue and plan attributes
- Compared churned vs retained users
- Computed correlations and distributions

**Key finding:**  
Churned users showed **similar engagement, support experience, and MRR** compared to retained users, indicating churn driven by **non-behavioral factors** (e.g., pricing sensitivity, competitive alternatives).

### 6. Dashboarding
- MRR trend over time
- Retention, adoption, and churn cohort heatmaps
- Top features by usage
- Support ticket volume over time

---

## Key Insights

- High engagement does **not guarantee retention**
- Usage and support metrics had **near-zero correlation** with churn
- Churn is likely driven by **external or qualitative factors**
- Cohort analysis reveals improving retention in later cohorts

---

## How to Run

1. Install dependencies:
   ```bash
   pip install -r requirements.txt

2. Initialize the database
    import duckdb
    con = duckdb.connect("saas.db")
3. Run notebooks in order
    From 01 - 09

Author
Rohan Patel