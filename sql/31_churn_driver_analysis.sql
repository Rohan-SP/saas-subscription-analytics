-- 06_churn_driver_analysis.sql
-- Purpose: Build churn analysis dataset using CTEs only
-- Safe to rerun, no persistence

WITH churn_labels AS (
    SELECT
        a.account_id,
        CASE WHEN c.account_id IS NOT NULL THEN 1 ELSE 0 END AS churned
    FROM accounts_clean a
    LEFT JOIN churn_events_clean c
        ON a.account_id = c.account_id
),

usage_features AS (
    SELECT
        s.account_id,
        COUNT(DISTINCT u.usage_date) AS active_usage_days,
        SUM(u.usage_count) AS total_usage_events,
        AVG(u.usage_count) AS avg_usage_per_day
    FROM subscriptions_clean s
    LEFT JOIN feature_usage_clean u
        ON s.subscription_id = u.subscription_id
    GROUP BY s.account_id
),

ticket_features AS (
    SELECT
        account_id,
        COUNT(*) AS ticket_count,
        AVG(resolution_time_hours) AS avg_resolution_time,
        AVG(first_response_time_minutes) AS avg_first_response_time,
        AVG(satisfaction_score) AS avg_satisfaction
    FROM support_tickets_clean
    GROUP BY account_id
),

subscription_features AS (
    SELECT
        account_id,
        COUNT(*) AS subscription_count,
        MAX(plan_tier) AS plan_tier,
        MAX(mrr_amount) AS mrr,
        MAX(seats) AS seats,
        MAX(billing_frequency) AS billing_frequency,
        MAX(is_trial) AS is_trial
    FROM subscriptions_clean
    GROUP BY account_id
)

SELECT
    l.account_id,
    l.churned,
    u.active_usage_days,
    u.total_usage_events,
    u.avg_usage_per_day,
    t.ticket_count,
    t.avg_resolution_time,
    t.avg_first_response_time,
    t.avg_satisfaction,
    s.subscription_count,
    s.plan_tier,
    s.mrr,
    s.seats,
    s.billing_frequency,
    s.is_trial
FROM churn_labels l
LEFT JOIN usage_features u USING (account_id)
LEFT JOIN ticket_features t USING (account_id)
LEFT JOIN subscription_features s USING (account_id);
