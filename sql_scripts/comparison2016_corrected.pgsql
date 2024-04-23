WITH protected_areas AS (
    SELECT 
        country_name, 
        SUM(transition_1 + transition_3 + transition_8) / 1000000 AS protected_seasonal,
        SUM(transition_1 + transition_2 + transition_7) / 1000000 AS protected_permanent
    FROM 
        cep_grouped
    -- WHERE country_name = 'Afghanistan' 
    WHERE is_marine = FALSE
    AND eco != 10001
    AND is_protected = TRUE
    GROUP BY 
        country_name
),
unprotected_areas AS (
    SELECT 
        country_name, 
        SUM(transition_1 + transition_3 + transition_8) / 1000000 AS unprotected_seasonal,
        SUM(transition_1 + transition_2 + transition_7) / 1000000 AS unprotected_permanent
    FROM 
        cep_grouped
    -- WHERE country_name = 'Afghanistan' 
    WHERE is_marine = FALSE
    AND eco != 10001
    AND is_protected = FALSE
    GROUP BY 
        country_name
),
countries_with_areas AS(
    SELECT name0, km2_tot as rep_area_km2
    FROM gaul0 
),
merged_summary AS (
    SELECT 
        protected_areas.country_name,
        protected_seasonal,
        protected_permanent,
        unprotected_seasonal,
        unprotected_permanent,
        countries_with_areas.rep_area_km2
    FROM 
        protected_areas
    JOIN 
        unprotected_areas
    ON 
        protected_areas.country_name = unprotected_areas.country_name
    JOIN
        countries_with_areas
    ON
        protected_areas.country_name = countries_with_areas.name0
)
SELECT
    country_name,
    SUM(protected_seasonal + protected_permanent + unprotected_seasonal + unprotected_permanent) / rep_area_km2 AS "% of country land area that is IW",
    SUM(protected_permanent + unprotected_permanent) / rep_area_km2 AS "% of country's land area that is IPW",
    SUM(protected_seasonal + unprotected_seasonal) / rep_area_km2 AS "% of country's land area that is ISW",
    protected_permanent / SUM(protected_permanent + unprotected_permanent) AS "% of IPW that is protected",
    protected_seasonal / SUM(protected_seasonal + unprotected_seasonal) AS "% of ISW that is protected",
    SUM(protected_seasonal + protected_permanent) / SUM(protected_seasonal + protected_permanent + unprotected_seasonal + unprotected_permanent) AS "% of IW that is protected"
FROM
    merged_summary
GROUP BY
    country_name,
    protected_permanent,
    protected_seasonal,
    rep_area_km2
LIMIT 5

-- SELECT
--     *
-- FROM
--     merged_summary
-- LIMIT 5
