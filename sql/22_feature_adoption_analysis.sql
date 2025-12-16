WITH signup AS (
    SELECT 
        account_id,
        DATE_TRUNC('month', signup_date) AS cohort_month
    FROM accounts_clean
),
usage AS (
    SELECT
        u.subscription_id,
        s.account_id,
        DATE_TRUNC('month', usage_date) AS usage_month
    FROM feature_usage_clean u
    JOIN subscriptions_clean s USING (subscription_id)
),
cohort_usage AS (
    SELECT
        s.cohort_month,
        u.usage_month,
        COUNT(DISTINCT u.account_id) AS active_users
    FROM signup s
    JOIN usage u USING (account_id)
    GROUP BY 1,2
),
cohort_size AS (
    SELECT 
        cohort_month,
        COUNT(*) AS cohort_users
    FROM signup
    GROUP BY 1
)
SELECT
    c.cohort_month,
    c.usage_month,
    cohort_users,
    active_users,
    active_users * 1.0 / cohort_users AS adoption_rate
FROM cohort_usage c
JOIN cohort_size s USING (cohort_month)
ORDER BY cohort_month, usage_month;
