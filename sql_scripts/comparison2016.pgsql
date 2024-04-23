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
protected_groupings AS (
    --group by protected and unprotected 
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
countries_with_areas AS(
    SELECT name0, km2_tot as rep_area_km2
    FROM gaul0 
),
-- join protected_groupings with countries_with_areas
protected_groupings_with_areas AS (
    SELECT 
        protected_groupings.country_name,
        protected_groupings.is_protected,
        protected_groupings.seasonal_2015,
        protected_groupings.permanent_2015,
        SUM(protected_groupings.seasonal_2015 + protected_groupings.permanent_2015) AS total_inland_water_km2,
        countries_with_areas.rep_area_km2
        -- calcualte percentages
    FROM
        protected_groupings
    JOIN
        countries_with_areas
    ON
        protected_groupings.country_name = countries_with_areas.name0
    GROUP BY
        protected_groupings.country_name,
        protected_groupings.is_protected,
        protected_groupings.seasonal_2015,
        protected_groupings.permanent_2015,
        countries_with_areas.rep_area_km2
)

SELECT *
FROM protected_groupings_with_areas;