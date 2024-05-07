WITH groupings AS (
    SELECT 
		cep_grouped.cep_id,
        -- SUM and convert FROM M2 to KM2 
        SUM(transition_1 + transition_3 + transition_8) / 1000000 AS seasonal_2015, 
        SUM(transition_1 + transition_2 + transition_7) / 1000000 AS permanent_2015
	FROM 
		cep_grouped
    WHERE 
        is_marine = FALSE 
    AND 
        eco != 10001
	GROUP BY 
		cep_grouped.cep_id
),
grouped_cep_summaries AS (
    -- join temp groupings table with cep_water table, but don't select transition columns
    SELECT 
        cep_grouped.cep_id,
        country_name,
        is_protected,
        groupings.seasonal_2015,
        groupings.permanent_2015
    FROM
        cep_grouped
    JOIN
        groupings
    ON
        cep_grouped.cep_id = groupings.cep_id
),
--group by protected and unprotected 
is_protected_groupings AS (
    SELECT 
        country_name,
        is_protected,
        SUM(seasonal_2015) AS seasonal_2015,
        SUM(permanent_2015) AS permanent_2015
    FROM
        grouped_cep_summaries
    GROUP BY
        country_name,
        is_protected
),

protected_groupings AS(
    SELECT
        is_protected_groupings.country_name,
        is_protected_groupings.is_protected,
        is_protected_groupings.seasonal_2015,
        is_protected_groupings.permanent_2015,
        SUM(is_protected_groupings.seasonal_2015 + is_protected_groupings.permanent_2015) AS total_inland_water_km2
    FROM
        is_protected_groupings
    WHERE
        is_protected_groupings.is_protected = TRUE
    GROUP BY
        is_protected_groupings.country_name,
        is_protected_groupings.is_protected,
        is_protected_groupings.seasonal_2015,
        is_protected_groupings.permanent_2015
),

unprotected_groupings AS(
    SELECT
        is_protected_groupings.country_name,
        is_protected_groupings.is_protected,
        is_protected_groupings.seasonal_2015,
        is_protected_groupings.permanent_2015,
        SUM(is_protected_groupings.seasonal_2015 + is_protected_groupings.permanent_2015) AS total_inland_water_km2
    FROM
        is_protected_groupings
    WHERE
        is_protected_groupings.is_protected = FALSE
    GROUP BY
        is_protected_groupings.country_name,
        is_protected_groupings.is_protected,
        is_protected_groupings.seasonal_2015,
        is_protected_groupings.permanent_2015
),
countries_with_areas AS(
    SELECT name0, km2_tot as rep_area_km2
    FROM gaul0 
),
inland_water_groupings AS(
    SELECT
        protected_groupings.country_name,
        --calculate as percentages of land cover
        (SUM(protected_groupings.total_inland_water_km2 + unprotected_groupings.total_inland_water_km2) / countries_with_areas.rep_area_km2) * 100 AS "% of country's land area that is IW",
        (SUM(protected_groupings.permanent_2015 + unprotected_groupings.permanent_2015) / countries_with_areas.rep_area_km2) * 100 AS "% of country's land area that is IPW",
        (SUM(protected_groupings.seasonal_2015 + unprotected_groupings.seasonal_2015) / countries_with_areas.rep_area_km2) * 100 AS "% of country's land area that is ISW",
        (protected_groupings.permanent_2015 / SUM(protected_groupings.permanent_2015 + unprotected_groupings.permanent_2015)) * 100 AS "% of IPW that is protected",
        (protected_groupings.seasonal_2015 / SUM(protected_groupings.seasonal_2015 + unprotected_groupings.seasonal_2015))* 100  AS "% of ISW that is protected",
        (SUM(protected_groupings.permanent_2015 + unprotected_groupings.permanent_2015) / SUM(protected_groupings.total_inland_water_km2 + unprotected_groupings.total_inland_water_km2)) * 100 AS "% of IW that is protected"

        -- protected_groupings.seasonal_2015 AS protected_seasonal_2015,
        -- protected_groupings.permanent_2015 AS protected_permanent_2015,
        -- protected_groupings.total_inland_water_km2 AS protected_total_inland_water_km2,
        -- unprotected_groupings.seasonal_2015 AS unprotected_seasonal_2015,
        -- unprotected_groupings.permanent_2015 AS unprotected_permanent_2015,
        -- unprotected_groupings.total_inland_water_km2 AS unprotected_total_inland_water_km2,
        -- countries_with_areas.rep_area_km2
    FROM
        protected_groupings
    JOIN
        unprotected_groupings
    ON
        protected_groupings.country_name = unprotected_groupings.country_name
    JOIN 
        countries_with_areas
    ON
        protected_groupings.country_name = countries_with_areas.name0
    GROUP BY
        protected_groupings.country_name,
        countries_with_areas.rep_area_km2,
        protected_groupings.total_inland_water_km2,
        protected_groupings.permanent_2015,
        protected_groupings.seasonal_2015,
        protected_groupings.is_protected,
        unprotected_groupings.total_inland_water_km2,
        unprotected_groupings.permanent_2015,
        unprotected_groupings.seasonal_2015
)

SELECT *
FROM inland_water_groupings
ORDER BY country_name
LIMIT 5