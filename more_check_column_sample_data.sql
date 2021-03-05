SELECT
	*
	--	e."json",
	--	e."json" ->> 'baseEntityId' AS base_entity_id,
	--	jsonb_array_elements(e."json" #> '{obs}') AS obs_data

	FROM core."event" e
WHERE
	--	e."json" ->> 'baseEntityId' = '6814a319-9f5c-427c-9d34-00cd9d8dd6b0'
	-- e."json" ->> 'baseEntityId' = '2f718be8-424e-400f-9ab7-af17b878ebf0'
	--	e."json" ->> 'baseEntityId' = 'a6f503e2-11f6-480c-a795-4a6599cc9d37'
	--	AND
	-- jsonb_pretty(e."json") ILIKE '%Child Regis%' AND 
 e."json" ->> 'baseEntityId' = '5dc5ef2e-2c65-4d51-ac41-c9c3e64fb127';

SELECT
	*
FROM
	core.client c
WHERE
	c."json" -> 'relationships' -> 'childId' ->> 1 IS NOT NULL;

SELECT
	*
FROM
	core.client c
WHERE
	c."json" ->> 'baseEntityId' = '6fcc8b61-cbc3-4c62-8081-3f2f254df647';

SELECT
	*
FROM
	core.client anak
WHERE
	anak."json" -> 'relationships' ->> 'ibuCaseId' IS NOT NULL;
-- criteria to get client anak

