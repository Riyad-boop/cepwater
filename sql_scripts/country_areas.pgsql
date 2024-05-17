SELECT 
    country_name,
    SUM(
    transition_0 + 
    + transition_1 
    + transition_2 
    + transition_3
    + transition_4
    + transition_5
    + transition_6
    + transition_7
    + transition_8
    + transition_9
    + transition_10
    ) / 1000000 
    AS calculated_area_km2
    FROM cep_water
    WHERE is_marine = FALSE
    AND eco != 100001
    GROUP BY country_name
    ORDER BY country_name
LIMIT 10;

