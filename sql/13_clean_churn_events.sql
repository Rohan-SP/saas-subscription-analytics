CREATE OR REPLACE TABLE churn_events_clean AS
SELECT
    churn_event_id,
    account_id,
    TRY_CAST(churn_date AS DATE) AS churn_date,
    LOWER(TRIM(reason_code)) AS reason_code,
    refund_amount_usd,
    preceding_upgrade_flag::BOOLEAN AS preceding_upgrade_flag,
    preceding_downgrade_flag::BOOLEAN AS preceding_downgrade_flag,
    is_reactivation::BOOLEAN AS is_reactivation,
    TRIM(feedback_text) AS feedback_text
FROM churn_events
WHERE churn_event_id IS NOT NULL;
