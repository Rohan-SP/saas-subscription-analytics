WITH signup AS (
    SELECT 
        account_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM accounts_clean
),
active_months AS (
    SELECT
        s.account_id,
        DATE_TRUNC('month', start_date) AS active_month
    FROM subscriptions_clean s
    WHERE churn_flag = False OR end_date > start_date
),
cohort_activity AS (
    SELECT
        sign.cohort_month,
        am.active_month,
        COUNT(DISTINCT am.account_id) AS active_users
    FROM signup sign
    JOIN active_months am USING (account_id)
    GROUP BY 1,2
),
cohort_size AS (
    SELECT
        cohort_month,
        COUNT(DISTINCT account_id) AS cohort_users
    FROM signup
    GROUP BY 1
)
SELECT
    c.cohort_month,
    c.active_month,
    cohort_users,
    active_users,
    active_users * 1.0 / cohort_users AS retention_rate
FROM cohort_activity c
JOIN cohort_size s USING (cohort_month)
ORDER BY cohort_month, active_month;
