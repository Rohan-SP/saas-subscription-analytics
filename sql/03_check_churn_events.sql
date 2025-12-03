-- ============================================================
--  CHURN EVENTS — CHECK SCRIPT
-- ============================================================

-- 1. Preview first 20 rows
SELECT *
FROM churn_events
LIMIT 20;

-- 2. Row count
SELECT COUNT(*) AS row_count
FROM churn_events;

-- 3. Schema overview
PRAGMA table_info('churn_events');

-- 4. Date range (min + max churn_date)
SELECT MIN(churn_date), MAX(churn_date)
FROM churn_events;

-- 5. Invalid or missing churn_date values
SELECT *
FROM churn_events
WHERE churn_date IS NULL
   OR TRY_CAST(churn_date AS DATE) IS NULL;

-- 6. Negative or suspicious refund amounts
SELECT *
FROM churn_events
WHERE refund_amount_usd < 0;

-- 7. Refunds unusually large (optional threshold check)
SELECT *
FROM churn_events
WHERE refund_amount_usd > 5000;

-- 8. Distinct reason_code values (check categorical consistency)
SELECT DISTINCT reason_code, LOWER(TRIM(reason_code)) AS normalized
FROM churn_events;

-- 9. Missing reason_code values
SELECT *
FROM churn_events
WHERE reason_code IS NULL
   OR TRIM(reason_code) = '';

-- 10. Check for duplicate churn_event_id
SELECT churn_event_id, COUNT(*) AS occurrences
FROM churn_events
GROUP BY churn_event_id
HAVING COUNT(*) > 1;

-- 11. Check for duplicate churn records by account + date
SELECT account_id, churn_date, COUNT(*) AS occurrences
FROM churn_events
GROUP BY account_id, churn_date
HAVING COUNT(*) > 1;

-- 12. Orphan churn events (account_id not present in accounts table)
SELECT ce.*
FROM churn_events ce
LEFT JOIN accounts a ON ce.account_id = a.account_id
WHERE a.account_id IS NULL;

-- 13. Check missing feedback_text
SELECT COUNT(*) AS missing_feedback
FROM churn_events
WHERE feedback_text IS NULL OR TRIM(feedback_text) = '';

-- 14. Detect reactivation cases (is_reactivation = True) without preceding churn
SELECT *
FROM churn_events
WHERE is_reactivation = TRUE
  AND preceding_upgrade_flag = FALSE
  AND preceding_downgrade_flag = FALSE;

-- 15. Check logical contradictions — refund given but no churn reason
SELECT *
FROM churn_events
WHERE refund_amount_usd > 0
  AND (reason_code IS NULL OR TRIM(reason_code) = '');

-- 16. Verify reason_code spelling consistency
SELECT DISTINCT reason_code
FROM churn_events
ORDER BY reason_code;

-- 17. Suspicious churn_date (future-dated)
SELECT *
FROM churn_events
WHERE TRY_CAST(churn_date AS DATE) > CURRENT_DATE;

-- 18. Check that refund_amount_usd is numeric
SELECT *
FROM churn_events
WHERE TRY_CAST(refund_amount_usd AS DOUBLE) IS NULL;

-- 19. Check boolean fields for non-boolean values
SELECT *
FROM churn_events
WHERE preceding_upgrade_flag NOT IN (TRUE, FALSE)
   OR preceding_downgrade_flag NOT IN (TRUE, FALSE)
   OR is_reactivation NOT IN (TRUE, FALSE);

-- 20. Null account_id check
SELECT *
FROM churn_events
WHERE account_id IS NULL OR TRIM(account_id) = '';

-- ============================================================
-- END OF FILE
-- ============================================================
