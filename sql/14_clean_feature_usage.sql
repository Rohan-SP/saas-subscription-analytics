CREATE OR REPLACE TABLE feature_usage_clean AS
SELECT
    usage_id,
    subscription_id,
    TRY_CAST(usage_date AS DATE) AS usage_date,
    LOWER(TRIM(feature_name)) AS feature_name,
    usage_count,
    usage_duration_secs,
    error_count,
    is_beta_feature::BOOLEAN AS is_beta_feature
FROM feature_usage
WHERE usage_id IS NOT NULL;
