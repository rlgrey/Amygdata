-- =========================================================
-- Exploratory SQL queries for mental_health_clean
-- (PostgreSQL-style syntax)
-- =========================================================

-- 1. Basic descriptive stats for main scales
SELECT
    AVG(PHQ9)  AS avg_phq9,
    STDDEV(PHQ9) AS std_phq9,
    MIN(PHQ9) AS min_phq9,
    MAX(PHQ9) AS max_phq9,
    AVG(GAD7) AS avg_gad7,
    STDDEV(GAD7) AS std_gad7,
    MIN(GAD7) AS min_gad7,
    MAX(GAD7) AS max_gad7
FROM mental_health_clean;


-- 2. Correlation between PHQ9 and GAD7
-- (PostgreSQL: corr() aggregate)
SELECT
    corr(PHQ9, GAD7) AS corr_phq9_gad7
FROM mental_health_clean;


-- 3. Average PHQ9 per SleepQuality level
SELECT
    SleepQuality,
    COUNT(*)                           AS n,
    AVG(PHQ9)                          AS avg_phq9,
    AVG(GAD7)                          AS avg_gad7
FROM mental_health_clean
GROUP BY SleepQuality
ORDER BY SleepQuality;


-- 4. Average PHQ9 by ScreenTime buckets
SELECT
    CASE
        WHEN ScreenTime < 3 THEN '0–3h'
        WHEN ScreenTime < 6 THEN '3–6h'
        ELSE '6h+'
    END AS screen_time_bucket,
    COUNT(*)              AS n,
    AVG(PHQ9)             AS avg_phq9,
    AVG(GAD7)             AS avg_gad7
FROM mental_health_clean
GROUP BY screen_time_bucket
ORDER BY screen_time_bucket;


-- 5. Distribution of MentalHealthStatus (0 vs 1)
SELECT
    MentalHealthStatus,
    COUNT(*)                                AS n,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct
FROM mental_health_clean
GROUP BY MentalHealthStatus
ORDER BY MentalHealthStatus;


-- 6. Top 10 students with highest PHQ9 scores
SELECT
    id,
    PHQ9,
    GAD7,
    SleepHours,
    ScreenTime,
    SleepQuality,
    FinancialStress,
    OnlineStress
FROM mental_health_clean
ORDER BY PHQ9 DESC
LIMIT 10;


-- 7. Relationship between FinancialStress and PHQ9
SELECT
    FinancialStress,
    COUNT(*)          AS n,
    AVG(PHQ9)         AS avg_phq9,
    AVG(GAD7)         AS avg_gad7
FROM mental_health_clean
GROUP BY FinancialStress
ORDER BY FinancialStress;


-- 8. Correlation of PHQ9 with selected stressors
SELECT
    corr(PHQ9, OnlineStress)      AS corr_phq9_online_stress,
    corr(PHQ9, AcademicStress)    AS corr_phq9_academic_stress,
    corr(PHQ9, FinancialStress)   AS corr_phq9_financial_stress,
    corr(PHQ9, SleepQuality)      AS corr_phq9_sleep_quality
FROM mental_health_clean;


-- 9. Average PHQ9 by GPA buckets (study performance)
SELECT
    CASE
        WHEN GPA < 2.5 THEN '<2.5'
        WHEN GPA < 3.0 THEN '2.5–3.0'
        WHEN GPA < 3.5 THEN '3.0–3.5'
        ELSE '3.5+'
    END AS gpa_bucket,
    COUNT(*)      AS n,
    AVG(PHQ9)     AS avg_phq9,
    AVG(GAD7)     AS avg_gad7
FROM mental_health_clean
GROUP BY gpa_bucket
ORDER BY gpa_bucket;


-- 10. SleepHours vs PHQ9: is there a trend?
SELECT
    SleepHours,
    COUNT(*)      AS n,
    AVG(PHQ9)     AS avg_phq9,
    AVG(GAD7)     AS avg_gad7
FROM mental_health_clean
GROUP BY SleepHours
ORDER BY SleepHours;
