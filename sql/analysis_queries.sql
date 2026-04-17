-- =============================================================================
-- analysis_queries.sql
-- Analytical queries for the graduation-rates-sat-analysis dataset
-- Compatible with: SQLite, PostgreSQL, MySQL
-- Table: grad_rates (sector, graduation_rate, sat_total, sat_imputed)
-- =============================================================================


-- -----------------------------------------------------------------------------
-- 1. OVERVIEW: Record count and basic coverage
-- -----------------------------------------------------------------------------
SELECT
    sector,
    COUNT(*)                                    AS n_schools,
    SUM(sat_imputed)                            AS n_imputed,
    ROUND(AVG(sat_imputed) * 100, 1)            AS pct_imputed
FROM grad_rates
GROUP BY sector
ORDER BY sector;


-- -----------------------------------------------------------------------------
-- 2. DESCRIPTIVE STATISTICS by sector
-- -----------------------------------------------------------------------------
SELECT
    sector,
    ROUND(AVG(graduation_rate), 2)              AS avg_grad_rate,
    ROUND(MIN(graduation_rate), 2)              AS min_grad_rate,
    ROUND(MAX(graduation_rate), 2)              AS max_grad_rate,
    ROUND(AVG(sat_total), 0)                    AS avg_sat_total,
    ROUND(MIN(sat_total), 0)                    AS min_sat_total,
    ROUND(MAX(sat_total), 0)                    AS max_sat_total
FROM grad_rates
GROUP BY sector
ORDER BY sector;


-- -----------------------------------------------------------------------------
-- 3. TOP 5 PERFORMERS by graduation rate within each sector
-- -----------------------------------------------------------------------------
-- Public top 5
SELECT
    'Public'                                    AS sector,
    graduation_rate,
    sat_total,
    sat_imputed
FROM grad_rates
WHERE sector = 'Public'
ORDER BY graduation_rate DESC
LIMIT 5;

-- Private top 5
SELECT
    'Private'                                   AS sector,
    graduation_rate,
    sat_total,
    sat_imputed
FROM grad_rates
WHERE sector = 'Private'
ORDER BY graduation_rate DESC
LIMIT 5;


-- -----------------------------------------------------------------------------
-- 4. SAT BAND ANALYSIS
--    Bucket schools into SAT bands; compare average grad rates across bands
-- -----------------------------------------------------------------------------
SELECT
    CASE
        WHEN sat_total < 1000 THEN 'Below 1000'
        WHEN sat_total BETWEEN 1000 AND 1099 THEN '1000–1099'
        WHEN sat_total BETWEEN 1100 AND 1199 THEN '1100–1199'
        WHEN sat_total BETWEEN 1200 AND 1299 THEN '1200–1299'
        WHEN sat_total >= 1300              THEN '1300+'
    END                                         AS sat_band,
    COUNT(*)                                    AS n_schools,
    ROUND(AVG(graduation_rate), 2)              AS avg_grad_rate,
    ROUND(AVG(CASE WHEN sector = 'Public'  THEN graduation_rate END), 2) AS avg_grad_public,
    ROUND(AVG(CASE WHEN sector = 'Private' THEN graduation_rate END), 2) AS avg_grad_private
FROM grad_rates
GROUP BY sat_band
ORDER BY MIN(sat_total);


-- -----------------------------------------------------------------------------
-- 5. OUTPERFORMERS: Schools exceeding their sector's average graduation rate
--    Useful for identifying institutions that punch above their SAT weight
-- -----------------------------------------------------------------------------
WITH sector_avg AS (
    SELECT
        sector,
        AVG(graduation_rate)                    AS avg_grad_rate
    FROM grad_rates
    GROUP BY sector
)
SELECT
    g.sector,
    g.graduation_rate,
    g.sat_total,
    g.sat_imputed,
    ROUND(g.graduation_rate - s.avg_grad_rate, 2) AS above_sector_avg
FROM grad_rates g
JOIN sector_avg s ON g.sector = s.sector
WHERE g.graduation_rate > s.avg_grad_rate
ORDER BY above_sector_avg DESC;


-- -----------------------------------------------------------------------------
-- 6. SENSITIVITY CHECK: Exclude imputed SAT records
--    Validates that results hold when only observed SAT scores are used
-- -----------------------------------------------------------------------------
SELECT
    sector,
    COUNT(*)                                    AS n_schools_observed,
    ROUND(AVG(graduation_rate), 2)              AS avg_grad_rate,
    ROUND(AVG(sat_total), 0)                    AS avg_sat_total
FROM grad_rates
WHERE sat_imputed = 0
GROUP BY sector
ORDER BY sector;


-- -----------------------------------------------------------------------------
-- 7. APPLIED PREDICTION CHECK
--    How many schools fall within ±5 percentage points of
--    the sector-specific regression prediction?
--
--    Public model:  predicted = -51.385 + 0.103957 * sat_total
--    Private model: predicted =   8.939 + 0.061701 * sat_total
-- -----------------------------------------------------------------------------
SELECT
    sector,
    graduation_rate,
    sat_total,
    CASE
        WHEN sector = 'Public'
            THEN ROUND(-51.385 + 0.103957 * sat_total, 2)
        WHEN sector = 'Private'
            THEN ROUND(8.939  + 0.061701 * sat_total, 2)
    END                                         AS predicted_grad_rate,
    ROUND(
        graduation_rate - CASE
            WHEN sector = 'Public'
                THEN -51.385 + 0.103957 * sat_total
            WHEN sector = 'Private'
                THEN   8.939 + 0.061701 * sat_total
        END, 2
    )                                           AS residual
FROM grad_rates
ORDER BY ABS(residual) DESC;
