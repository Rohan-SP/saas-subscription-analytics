WITH signup AS (
    SELECT 
        account_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM accounts_clean
),
churn AS (
    SELECT
        account_id,
        DATE_TRUNC('month', churn_date) AS churn_month
    FROM churn_clean
),
cohort_churn AS (
    SELECT
        s.cohort_month,
        c.churn_month,
        COUNT(DISTINCT c.account_id) AS churned_users
    FROM signup s
    JOIN churn c USING (account_id)
    GROUP BY 1,2
),
cohort_size AS (
    SELECT cohort_month, COUNT(*) AS cohort_users
    FROM signup
    GROUP BY 1
)
SELECT
    cc.cohort_month,
    cc.churn_month,
    cohort_users,
    churned_users,
    churned_users * 1.0 / cohort_users AS churn_rate
FROM cohort_churn cc
JOIN cohort_size USING (cohort_month)
ORDER BY cohort_month, churn_month;
