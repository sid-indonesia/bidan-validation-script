SELECT
    CASE
        WHEN earv."obs.bpjs.values" ILIKE '%12312322200011%'
        THEN 1
        ELSE 0
    END AS "1-is_bpjs_value_equal_12312322200011"
FROM
    core."event_ANC Registration_view" earv;