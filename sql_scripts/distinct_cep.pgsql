wITH "distinct_cep" AS(
    SELECT DISTINCT cep_id,
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
    FROM cep_grouped
    -- WHERE is_marine = FALSE
    -- AND eco != 100001
    GROUP BY cep_id
)
SELECT SUM(calculated_area_km2) FROM distinct_cep 
WHERE cep_id >= 350156
AND cep_id <= 353740

-- SELECT SUM(calculated_area_km2) FROM distinct_cep
-- WHERE cep_id >= 350156
-- AND cep_id <= 353740
-- LIMIT 10;

-- SELECT country_name, SUM(calculated_area_km2) 
-- FROM distinct_cep
-- WHERE country_name = 'Slovenia'
-- GROUP BY country_name
-- ORDER BY country_name
-- LIMIT 10;


--check for duplicates
-- SELECT cep_id, COUNT(*) as count
-- FROM cep_grouped
-- -- WHERE cep_id = 8
-- GROUP BY cep_id
-- HAVING COUNT(*) > 1
-- LIMIT 10;

-- SELECT a.country_name, b.calculated_area_km2
-- FROM cep_water a
-- JOIN distinct_cep b
-- ON a.cep_id = b.cep_id
-- LIMIT 10;


-- SELECT * FROM distinct_cep LIMIT 10
-- SELECT 
--     country_name,
--     SUM(
--     transition_0 + 
--     + transition_1 
--     + transition_2 
--     + transition_3
--     + transition_4
--     + transition_5
--     + transition_6
--     + transition_7
--     + transition_8
--     + transition_9
--     + transition_10
--     ) / 1000000 
--     AS calculated_area_km2
--     FROM cep_water
--     WHERE is_marine = FALSE
--     AND eco != 100001
--     GROUP BY country_name
--     ORDER BY country_name

