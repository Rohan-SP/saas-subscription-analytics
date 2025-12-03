-- ============================================================
--  SUPPORT TICKETS — CHECK SCRIPT
-- ============================================================

-- 1. Preview
SELECT *
FROM support_tickets
LIMIT 20;

-- 2. Row count
SELECT COUNT(*) AS row_count
FROM support_tickets;

-- 3. Schema
PRAGMA table_info('support_tickets');

-- 4. Date range: submitted_at + closed_at
SELECT MIN(submitted_at), MAX(submitted_at) FROM support_tickets;
SELECT MIN(closed_at), MAX(closed_at) FROM support_tickets;

-- 5. Null or invalid submitted_at
SELECT *
FROM support_tickets
WHERE submitted_at IS NULL
   OR TRY_CAST(submitted_at AS TIMESTAMP) IS NULL;

-- 6. Null or invalid closed_at
SELECT *
FROM support_tickets
WHERE closed_at IS NOT NULL
  AND TRY_CAST(closed_at AS TIMESTAMP) IS NULL;

-- 7. Tickets where closed_at < submitted_at
SELECT *
FROM support_tickets
WHERE closed_at IS NOT NULL
  AND TRY_CAST(closed_at AS TIMESTAMP) < TRY_CAST(submitted_at AS TIMESTAMP);

-- 8. Distinct priority categories
SELECT DISTINCT priority, LOWER(TRIM(priority)) AS normalized
FROM support_tickets;

-- 9. Missing priority
SELECT *
FROM support_tickets
WHERE priority IS NULL OR TRIM(priority) = '';

-- 10. Negative response or resolution times
SELECT *
FROM support_tickets
WHERE resolution_time_hours < 0
   OR first_response_time_minutes < 0;

-- 11. Missing satisfaction_score
SELECT COUNT(*) AS missing_satisfaction
FROM support_tickets
WHERE satisfaction_score IS NULL;

-- 12. Satisfaction_score outside valid range (0–5)
SELECT *
FROM support_tickets
WHERE satisfaction_score < 0 OR satisfaction_score > 5;

-- 13. Check invalid escalation flag
SELECT *
FROM support_tickets
WHERE escalation_flag NOT IN (TRUE, FALSE);

-- 14. Duplicate ticket_id
SELECT ticket_id, COUNT(*) AS occurrences
FROM support_tickets
GROUP BY ticket_id
HAVING COUNT(*) > 1;

-- 15. Orphan account_id (no match in accounts)
SELECT st.*
FROM support_tickets st
LEFT JOIN accounts a ON st.account_id = a.account_id
WHERE a.account_id IS NULL;

-- 16. Very long resolution times (optional anomaly detection)
SELECT *
FROM support_tickets
WHERE resolution_time_hours > 200;

-- ============================================================
-- END FILE
-- ============================================================
