CREATE OR REPLACE TABLE support_tickets_clean AS
SELECT
    ticket_id,
    account_id,
    TRY_CAST(submitted_at AS TIMESTAMP) AS submitted_at,
    TRY_CAST(closed_at AS TIMESTAMP) AS closed_at,
    resolution_time_hours,
    LOWER(TRIM(priority)) AS priority,
    first_response_time_minutes,
    satisfaction_score,
    escalation_flag::BOOLEAN AS escalation_flag
FROM support_tickets
WHERE ticket_id IS NOT NULL;
