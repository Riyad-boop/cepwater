-- -- check if there are duplicates (eco,eco_name,is_marine)
-- SELECT eco,eco_name,is_marine, COUNT(*) 
-- FROM cep_grouped
-- GROUP BY eco,eco_name, is_marine

check if any ecoregion is flagged as is_marine true and false
SELECT eco,eco_name, COUNT(*)
FROM cep_grouped
GROUP BY eco,eco_name
HAVING COUNT(*) > 1
LIMIT 10

