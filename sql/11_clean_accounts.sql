CREATE OR REPLACE TABLE accounts_clean AS
SELECT
    account_id,
    account_name,
    LOWER(TRIM(industry)) AS industry,
    UPPER(TRIM(country)) AS country,
    TRY_CAST(signup_date AS DATE) AS signup_date,
    LOWER(TRIM(referral_source)) AS referral_source,
    LOWER(TRIM(plan_tier)) AS plan_tier,
    seats,
    is_trial::BOOLEAN AS is_trial,
    churn_flag::BOOLEAN AS churn_flag
FROM accounts
WHERE account_id IS NOT NULL;
