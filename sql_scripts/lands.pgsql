-- add up all the transition areas from transition_0 to transition_10 (use regex) in the table cep_water
WITH cep_area_all_land AS(
SELECT SUM(
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
    AS cep_area_all_land
    FROM cep_water
    WHERE is_marine = FALSE
),
cep_total_no_unassigned_land AS (
    SELECT SUM(
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
    AS cep_total_no_unassigned_land
    FROM cep_water
    WHERE is_marine = FALSE
    AND eco != 100001
)

SELECT * FROM cep_area_all_land, cep_total_no_unassigned_land
   