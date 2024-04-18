DROP VIEW IF EXISTS "seasonal_perma_groupings";
CREATE VIEW seasonal_perma_groupings AS
WITH groupings AS (
    SELECT 
		cep_grouped.cep_id,
        -- (0)  No change 
        -- (1)  Unchanging permanent water surfaces
        -- (2)	New permanent water surfaces (i.e. conversion of a no water place into a permanent water place.)
        -- (3)	Lost permanent water surfaces (i.e. conversion of a permanent water place into a no water place)
        -- (4)	Unchanging seasonal water surfaces
        -- (5)	New seasonal water surfaces (i.e. conversion of a no water place into a seasonal water place)
        -- (6)	Lost seasonal water surfaces (i.e. conversion of a seasonal water place into a no water place)
        -- (7)	Conversion of seasonal water into permanent water
        -- (8)	Conversion of permanent water into seasonal water
        -- (9)	Ephemeral permanent water (i.e. no water (land) places replaced by permanent water that subsequently disappeared within the observation period)
        -- (10)	Ephemeral seasonal water (i.e. no water (land) places replaced by seasonal water that subsequently disappeared within the observation period)

        -- SUM and convert FROM M2 to KM2 
        SUM(transition_4 + transition_6 + transition_7) / 1000000 AS seasonal_1985, 
        SUM(transition_1 + transition_3 + transition_8) / 1000000 AS seasonal_2015, 
        SUM(transition_4 + transition_5 + transition_8) / 1000000 AS permanent_1985, 
        SUM(transition_1 + transition_2 + transition_7) / 1000000 AS permanent_2015
	FROM 
		cep_grouped 
	GROUP BY 
		cep_grouped.cep_id
)
-- join temp groupings table with cep_water table, but don't select transition columns
SELECT 
    cep_grouped.cep_id,
    country,
    country_name,
    iso3,
    eco,
    eco_name,
    is_marine,
    pa,
    pa_name,
    is_protected,
    groupings.seasonal_1985,
    groupings.seasonal_2015,
    groupings.permanent_1985,
    groupings.permanent_2015,
    groupings.seasonal_2015 - groupings.seasonal_1985 AS net_seasonal_change,
    groupings.permanent_2015 - groupings.permanent_1985 AS net_permanent_change,
    -- case where seasonal_1985 is not 0 to avoid division by 0
    CASE
        WHEN groupings.seasonal_1985 = 0 THEN NULL
        ELSE ((groupings.seasonal_2015 - groupings.seasonal_1985) / (groupings.seasonal_1985 + groupings.seasonal_2015)) * 100
    END AS seasonal_change_percent,
    -- case where permanent_1985 is not 0 to avoid division by 0
    CASE
        WHEN groupings.permanent_1985 = 0 THEN NULL
        ELSE ((groupings.permanent_2015 - groupings.permanent_1985) / (groupings.permanent_1985 + groupings.permanent_2015)) * 100
    END AS permanent_change_percent

FROM
    cep_grouped
JOIN
    groupings
ON
    cep_grouped.cep_id = groupings.cep_id;


SELECT * FROM "seasonal_perma_groupings" LIMIT 5;