--get all the eco_ids for each country where is_marine is false and not 100001
WITH total_country_areas AS(
    SELECT SUM(km2_tot) as total_rep_area_km2
    ,SUM(ST_Area(geom::geography)) / 1000000 AS total_calculated_area_km2
    FROM gaul0
),
terrestrial_eco_with_areas AS (
    SELECT SUM(area) as total_rep_area_km2
    ,SUM(ST_Area(geom::geography)) / 1000000 as total_calculated_area_km2
    FROM tres_eco 
    WHERE eco_id IN (
        SELECT eco_id 
        FROM cep_water
        WHERE is_marine = false
    ) 
    OR eco_id = 10001
)
-- Select both areas
SELECT a.total_rep_area_km2 as total_country_rep_area_km2, 
b.total_rep_area_km2 as total_teres_ecoregion_rep_area_km2,
a.total_calculated_area_km2 as total_country_calculated_area_km2,
b.total_calculated_area_km2 as total_teres_ecoregion_calculated_area_km2
FROM total_country_areas a, terrestrial_eco_with_areas b