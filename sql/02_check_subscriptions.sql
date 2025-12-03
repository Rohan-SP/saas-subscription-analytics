-------------------------------------------------------
-- SECTION 1: BASIC STRUCTURE & PREVIEW
-------------------------------------------------------

SELECT *
FROM subscriptions
LIMIT 20;

SELECT COUNT(*) AS total_rows
FROM subscriptions;

PRAGMA table_info('subscriptions');


-------------------------------------------------------
-- SECTION 2: DATE CHECKS
-------------------------------------------------------

-- Look at raw start and end dates
SELECT DISTINCT start_date
FROM subscriptions
ORDER BY start_date;

SELECT DISTINCT end_date
FROM subscriptions
ORDER BY end_date;

-- Detect unparseable start dates
SELECT start_date
FROM subscriptions
WHERE TRY_CAST(start_date AS DATE) IS NULL
  AND start_date IS NOT NULL
  AND TRIM(start_date) <> '';

-- Detect unparseable end dates
SELECT end_date
FROM subscriptions
WHERE TRY_CAST(end_date AS DATE) IS NULL
  AND end_date IS NOT NULL
  AND TRIM(end_date) <> '';

-- Detect end_date BEFORE start_date
SELECT *
FROM subscriptions
WHERE TRY_CAST(end_date AS DATE) < TRY_CAST(start_date AS DATE)
  AND end_date IS NOT NULL;

-- Detect future start dates (unlikely)
SELECT *
FROM subscriptions
WHERE TRY_CAST(start_date AS DATE) > CURRENT_DATE;


-------------------------------------------------------
-- SECTION 3: PLAN TIER CHECKS
-------------------------------------------------------

SELECT DISTINCT plan_tier, LOWER(TRIM(plan_tier)) AS normalized
FROM subscriptions
ORDER BY 1;


-------------------------------------------------------
-- SECTION 4: BILLING FREQUENCY
-------------------------------------------------------

SELECT DISTINCT billing_frequency, LOWER(TRIM(billing_frequency)) AS normalized
FROM subscriptions
ORDER BY 1;

-- Check invalid billing frequency values
SELECT *
FROM subscriptions
WHERE LOWER(TRIM(billing_frequency)) NOT IN ('monthly', 'annual');


-------------------------------------------------------
-- SECTION 5: NUMERIC CHECKS
-------------------------------------------------------

-- Negative or zero MRR values
SELECT *
FROM subscriptions
WHERE mrr_amount < 0;

-- Zero MRR but is_trial = false (suspicious)
SELECT *
FROM subscriptions
WHERE mrr_amount = 0
  AND is_trial = False;

-- ARRs that don't match MRR * billing cycle
SELECT *
FROM subscriptions
WHERE arr_amount < 0;

-- Seats negative or zero
SELECT *
FROM subscriptions
WHERE seats <= 0;

-- Check numeric conversion issues
SELECT seats
FROM subscriptions
WHERE TRY_CAST(seats AS DOUBLE) IS NULL
  AND seats IS NOT NULL;


-------------------------------------------------------
-- SECTION 6: FLAG LOGIC VALIDATION
-------------------------------------------------------

-- churn_flag should be false if end_date is NULL
SELECT *
FROM subscriptions
WHERE churn_flag = True
  AND end_date IS NULL;

-- churn_flag should be true if end_date exists
SELECT *
FROM subscriptions
WHERE churn_flag = False
  AND end_date IS NOT NULL;

-- is_trial should not have MRR > 0
SELECT *
FROM subscriptions
WHERE is_trial = True AND mrr_amount > 0;

-- upgrade and downgrade cannot both be true
SELECT *
FROM subscriptions
WHERE upgrade_flag = True AND downgrade_flag = True;


-------------------------------------------------------
-- SECTION 7: NULL / MISSING VALUES
-------------------------------------------------------

SELECT
    SUM(CASE WHEN subscription_id IS NULL OR TRIM(subscription_id) = '' THEN 1 END) AS missing_subscription_id,
    SUM(CASE WHEN account_id IS NULL OR TRIM(account_id) = '' THEN 1 END) AS missing_account_id,
    SUM(CASE WHEN start_date IS NULL OR TRIM(start_date) = '' THEN 1 END) AS missing_start_date,
    SUM(CASE WHEN plan_tier IS NULL OR TRIM(plan_tier) = '' THEN 1 END) AS missing_plan_tier,
    SUM(CASE WHEN billing_frequency IS NULL OR TRIM(billing_frequency) = '' THEN 1 END) AS missing_billing_frequency,
    SUM(CASE WHEN seats IS NULL THEN 1 END) AS missing_seats,
    SUM(CASE WHEN mrr_amount IS NULL THEN 1 END) AS missing_mrr_amount
FROM subscriptions;


-------------------------------------------------------
-- SECTION 8: DUPLICATE CHECKS
-------------------------------------------------------

-- Duplicate subscription IDs
SELECT subscription_id, COUNT(*) AS duplicates
FROM subscriptions
GROUP BY subscription_id
HAVING COUNT(*) > 1;

-- Duplicate rows
SELECT *, COUNT(*) AS row_count
FROM subscriptions
GROUP BY ALL
HAVING COUNT(*) > 1;


-------------------------------------------------------
-- SECTION 9: REFERENTIAL INTEGRITY
-------------------------------------------------------

-- Subscription references invalid account_id
SELECT s.*
FROM subscriptions s
LEFT JOIN accounts a
    ON s.account_id = a.account_id
WHERE a.account_id IS NULL;
