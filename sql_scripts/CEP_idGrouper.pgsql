DROP VIEW IF EXISTS "cep_grouped";
CREATE VIEW cep_grouped AS
WITH groupings AS (
    SELECT 
		cep_water.cep_id,
        SUM(transition_0) as transition_0,
        SUM(transition_1) as transition_1,
        SUM(transition_2) as transition_2,
        SUM(transition_3) as transition_3,
        SUM(transition_4) as transition_4,
        SUM(transition_5) as transition_5,
        SUM(transition_6) as transition_6,
        SUM(transition_7) as transition_7,
        SUM(transition_8) as transition_8,
        SUM(transition_9) as transition_9,
        SUM(transition_10) as transition_10
	FROM 
		cep_water 
	GROUP BY 
		cep_water.cep_id
)

-- join temp groupings table with cep_water table, but don't select transition columns
SELECT DISTINCT
    cep_water.cep_id,
    country,
    country_name,
    iso3,
    eco,
    eco_name,
    is_marine,
    pa,
    pa_name,
    is_protected,
    -- add all columns from groupings except cep_id
    groupings.transition_0,
    groupings.transition_1,
    groupings.transition_2,
    groupings.transition_3,
    groupings.transition_4,
    groupings.transition_5,
    groupings.transition_6,
    groupings.transition_7,
    groupings.transition_8,
    groupings.transition_9,
    groupings.transition_10
FROM
    cep_water
JOIN
    groupings
ON
    cep_water.cep_id = groupings.cep_id;


SELECT * FROM "cep_grouped" LIMIT 5;