--get all the eco_ids for each country where is_marine is false and not 100001
WITH terrestrial_eco_ids_per_country AS (
    SELECT country_name, array_agg(eco) as eco_ids
    FROM (
        SELECT DISTINCT country_name,  eco
        FROM cep_water
        WHERE is_marine = false AND eco != 100001
    ) as subquery
    GROUP BY country_name
),
countries_with_areas AS(
    SELECT name0, km2_tot as rep_area_km2
    -- , ST_Area(geom::geography) / 1000000 AS calculated_area_km2 
    FROM gaul0 
),
terrestrial_eco_with_areas AS (
    SELECT eco_id, area as rep_area_km2
    -- ,ST_Area(geom::geography)/1000000 as calculated_area_km2
    FROM tres_eco 
    WHERE eco_id IN (
        SELECT eco_id 
        FROM cep_water
        WHERE is_marine = false
    ) 
    OR eco_id = 10001
)

-- SUM area of all ecoregions in the list of eco ids for each country and group & order result by country
SELECT country_name, 
    cwa.rep_area_km2 as country_rep_area_km2 
    -- ,cwa.calculated_area_km2 as country_calculated_area_km2, 
    ,ROUND(SUM(tewa.rep_area_km2)) as sum_terrestrial_eco_rep_area_km2 
    -- ,SUM(tewa.calculated_area_km2) as sum_terrestrial_eco_calculated_area_km2
FROM terrestrial_eco_ids_per_country
JOIN countries_with_areas cwa ON country_name = name0
JOIN terrestrial_eco_with_areas tewa ON eco_id = ANY(eco_ids)
GROUP BY country_name, country_rep_area_km2
ORDER BY country_name


-- SELECT country_name, eco_ids as ids,
--     cwa.calculated_area_km2 as country_calculated_area_km2,
--     SUM(tewa.calculated_area_km2) as sum_terrestrial_eco_calculated_area_km2
-- FROM terrestrial_eco_ids_per_country 
-- JOIN countries_with_areas cwa ON country_name = name0
-- JOIN terrestrial_eco_with_areas tewa ON eco_id = ANY(eco_ids)
-- GROUP BY country_name, eco_ids, country_calculated_area_km2
-- ORDER BY country_name
-- LIMIT 10








