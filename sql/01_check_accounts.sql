-------------------------------------------------------
-- SECTION 1: BASIC STRUCTURE & PREVIEW
-------------------------------------------------------

SELECT *
FROM accounts
LIMIT 20;

SELECT COUNT(*) AS total_rows
FROM accounts;

PRAGMA table_info('accounts');


-------------------------------------------------------
-- SECTION 2: DATE CHECKS
-------------------------------------------------------

-- Raw date values
SELECT DISTINCT signup_date
FROM accounts
ORDER BY signup_date;

-- Unparseable dates
SELECT signup_date
FROM accounts
WHERE TRY_CAST(signup_date AS DATE) IS NULL
  AND signup_date IS NOT NULL
  AND TRIM(signup_date) <> '';

-- Impossible/future dates
SELECT *
FROM accounts
WHERE TRY_CAST(signup_date AS DATE) > CURRENT_DATE
   OR TRY_CAST(signup_date AS DATE) < DATE '1990-01-01';


-------------------------------------------------------
-- SECTION 3: CATEGORY CHECKS
-------------------------------------------------------

-- Industries
SELECT DISTINCT industry, LOWER(TRIM(industry)) AS normalized
FROM accounts
ORDER BY 1;

-- Countries
SELECT DISTINCT country, LOWER(TRIM(country)) AS normalized
FROM accounts
ORDER BY 1;

-- Referral source
SELECT DISTINCT referral_source, LOWER(TRIM(referral_source)) AS normalized
FROM accounts
ORDER BY 1;

-- Plan tiers
SELECT DISTINCT plan_tier, LOWER(TRIM(plan_tier)) AS normalized
FROM accounts
ORDER BY 1;


-------------------------------------------------------
-- SECTION 4: NUMERIC CHECKS
-------------------------------------------------------

-- Seats negative or unrealistic
SELECT *
FROM accounts
WHERE seats < 0;

-- Check if seats stored incorrectly
SELECT seats
FROM accounts
WHERE TRY_CAST(seats AS DOUBLE) IS NULL
  AND seats IS NOT NULL;


-------------------------------------------------------
-- SECTION 5: DUPLICATE CHECKS
-------------------------------------------------------

-- Duplicate account IDs
SELECT account_id, COUNT(*) AS duplicates
FROM accounts
GROUP BY account_id
HAVING COUNT(*) > 1;

-- Duplicate full rows
SELECT *, COUNT(*) AS row_count
FROM accounts
GROUP BY ALL
HAVING COUNT(*) > 1;


-------------------------------------------------------
-- SECTION 6: NULL / MISSING VALUES
-------------------------------------------------------

SELECT
    SUM(CASE WHEN account_id IS NULL OR TRIM(account_id) = '' THEN 1 END) AS missing_account_id,
    SUM(CASE WHEN signup_date IS NULL OR TRIM(signup_date) = '' THEN 1 END) AS missing_signup_date,
    SUM(CASE WHEN industry IS NULL OR TRIM(industry) = '' THEN 1 END) AS missing_industry,
    SUM(CASE WHEN country IS NULL OR TRIM(country) = '' THEN 1 END) AS missing_country,
    SUM(CASE WHEN referral_source IS NULL OR TRIM(referral_source) = '' THEN 1 END) AS missing_referral_source,
    SUM(CASE WHEN plan_tier IS NULL OR TRIM(plan_tier) = '' THEN 1 END) AS missing_plan_tier,
    SUM(CASE WHEN seats IS NULL THEN 1 END) AS missing_seats
FROM accounts;
