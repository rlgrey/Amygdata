-- =========================================================
-- 1. Staging table for raw CSV data
--    (columns as TEXT – łatwe ładowanie przez COPY / LOAD)
-- =========================================================

DROP TABLE IF EXISTS mental_health_raw;

CREATE TABLE mental_health_raw (
    PHQ9                TEXT,
    GAD7                TEXT,
    SleepHours          TEXT,
    ExerciseFreq        TEXT,
    SocialActivity      TEXT,
    OnlineStress        TEXT,
    GPA                 TEXT,
    FamilySupport       TEXT,
    ScreenTime          TEXT,
    AcademicStress      TEXT,
    DietQuality         TEXT,
    SelfEfficacy        TEXT,
    PeerRelationship    TEXT,
    FinancialStress     TEXT,
    SleepQuality        TEXT,
    MentalHealthStatus  TEXT
);

-- Przykład ładowania (PostgreSQL):
-- COPY mental_health_raw
-- FROM '/path/to/mental_health.csv'
-- DELIMITER ','
-- CSV HEADER;


-- =========================================================
-- 2. Clean analytical table with proper data types
-- =========================================================

DROP TABLE IF EXISTS mental_health_clean;

CREATE TABLE mental_health_clean (
    id                  SERIAL PRIMARY KEY,
    PHQ9                DOUBLE PRECISION NOT NULL,
    GAD7                DOUBLE PRECISION NOT NULL,
    SleepHours          DOUBLE PRECISION NOT NULL,
    ExerciseFreq        DOUBLE PRECISION NOT NULL,
    SocialActivity      DOUBLE PRECISION NOT NULL,
    OnlineStress        DOUBLE PRECISION NOT NULL,
    GPA                 DOUBLE PRECISION NOT NULL,
    FamilySupport       DOUBLE PRECISION NOT NULL,
    ScreenTime          DOUBLE PRECISION NOT NULL,
    AcademicStress      DOUBLE PRECISION NOT NULL,
    DietQuality         DOUBLE PRECISION NOT NULL,
    SelfEfficacy        DOUBLE PRECISION NOT NULL,
    PeerRelationship    DOUBLE PRECISION NOT NULL,
    FinancialStress     DOUBLE PRECISION NOT NULL,
    SleepQuality        DOUBLE PRECISION NOT NULL,
    MentalHealthStatus  INTEGER NOT NULL   -- 0 = no risk, 1 = at risk
);


-- =========================================================
-- 3. Simple ETL: cast from RAW to CLEAN
--    (zakłada PostgreSQL / kompatybilny dialekt)
-- =========================================================

INSERT INTO mental_health_clean (
    PHQ9,
    GAD7,
    SleepHours,
    ExerciseFreq,
    SocialActivity,
    OnlineStress,
    GPA,
    FamilySupport,
    ScreenTime,
    AcademicStress,
    DietQuality,
    SelfEfficacy,
    PeerRelationship,
    FinancialStress,
    SleepQuality,
    MentalHealthStatus
)
SELECT
    CAST(PHQ9               AS DOUBLE PRECISION),
    CAST(GAD7               AS DOUBLE PRECISION),
    CAST(SleepHours         AS DOUBLE PRECISION),
    CAST(ExerciseFreq       AS DOUBLE PRECISION),
    CAST(SocialActivity     AS DOUBLE PRECISION),
    CAST(OnlineStress       AS DOUBLE PRECISION),
    CAST(GPA                AS DOUBLE PRECISION),
    CAST(FamilySupport      AS DOUBLE PRECISION),
    CAST(ScreenTime         AS DOUBLE PRECISION),
    CAST(AcademicStress     AS DOUBLE PRECISION),
    CAST(DietQuality        AS DOUBLE PRECISION),
    CAST(SelfEfficacy       AS DOUBLE PRECISION),
    CAST(PeerRelationship   AS DOUBLE PRECISION),
    CAST(FinancialStress    AS DOUBLE PRECISION),
    CAST(SleepQuality       AS DOUBLE PRECISION),
    CAST(MentalHealthStatus AS INTEGER)
FROM mental_health_raw
WHERE
    PHQ9 IS NOT NULL
    AND GAD7 IS NOT NULL;
