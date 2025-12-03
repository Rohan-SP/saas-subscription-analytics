-- ============================================================
--  FEATURE USAGE — CHECK SCRIPT
-- ============================================================

-- 1. Preview
SELECT *
FROM feature_usage
LIMIT 20;

-- 2. Row count
SELECT COUNT(*) AS row_count
FROM feature_usage;

-- 3. Schema
PRAGMA table_info('feature_usage');

-- 4. Date range
SELECT MIN(usage_date), MAX(usage_date)
FROM feature_usage;

-- 5. Invalid or missing usage_date
SELECT *
FROM feature_usage
WHERE usage_date IS NULL
   OR TRY_CAST(usage_date AS DATE) IS NULL;

-- 6. Negative or unrealistic numeric fields
SELECT *
FROM feature_usage
WHERE usage_count < 0
   OR usage_duration_secs < 0
   OR error_count < 0;

-- 7. Distinct feature names
SELECT DISTINCT feature_name
FROM feature_usage
ORDER BY feature_name;

-- 8. Missing feature_name
SELECT *
FROM feature_usage
WHERE feature_name IS NULL OR TRIM(feature_name) = '';

-- 9. Duplicate usage_id
SELECT usage_id, COUNT(*) AS occurrences
FROM feature_usage
GROUP BY usage_id
HAVING COUNT(*) > 1;

-- 10. Orphan subscription_id (no match in subscriptions)
SELECT fu.*
FROM feature_usage fu
LEFT JOIN subscriptions s ON fu.subscription_id = s.subscription_id
WHERE s.subscription_id IS NULL;

-- 11. Extremely high usage_count (potential anomaly)
SELECT *
FROM feature_usage
WHERE usage_count > 1000;

-- 12. Invalid boolean field
SELECT *
FROM feature_usage
WHERE is_beta_feature NOT IN (TRUE, FALSE);

-- 13. Feature name formatting consistency
SELECT DISTINCT feature_name,
       LOWER(TRIM(feature_name)) AS normalized
FROM feature_usage;

-- 14. Check usage_duration_secs outliers (e.g., > 1 day)
SELECT *
FROM feature_usage
WHERE usage_duration_secs > 86400;

-- 15. Null subscription_id
SELECT *
FROM feature_usage
WHERE subscription_id IS NULL OR TRIM(subscription_id) = '';

-- ============================================================
-- END FILE
-- ============================================================
