CREATE OR REPLACE TABLE subscriptions_clean AS
SELECT
    subscription_id,
    account_id,
    TRY_CAST(start_date AS DATE) AS start_date,
    TRY_CAST(end_date AS DATE) AS end_date,
    LOWER(TRIM(plan_tier)) AS plan_tier,
    seats,
    NULLIF(mrr_amount, -1) AS mrr_amount,       -- fix negative values
    NULLIF(arr_amount, -1) AS arr_amount,
    is_trial::BOOLEAN AS is_trial,
    upgrade_flag::BOOLEAN AS upgrade_flag,
    downgrade_flag::BOOLEAN AS downgrade_flag,
    churn_flag::BOOLEAN AS churn_flag,
    LOWER(TRIM(billing_frequency)) AS billing_frequency,
    auto_renew_flag::BOOLEAN AS auto_renew_flag
FROM subscriptions
WHERE subscription_id IS NOT NULL;
