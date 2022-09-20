SELECT
    the_mother."firstName" || ' ' || the_mother."lastName" AS candidate_name,
    CASE
        WHEN anc_registration."obs.bpjs.values" ILIKE '%12312322200011%'
        THEN 1
        ELSE 0
    END AS "1-is_bpjs_value_equal_12312322200011"
FROM
    core.client_detailed_view the_mother
LEFT JOIN
    core."event_ANC Registration_view" anc_registration ON
    anc_registration."baseEntityId" = the_mother."baseEntityId"
LEFT JOIN
    core."event_Quick Check_view" quick_check ON
    quick_check."baseEntityId" = the_mother."baseEntityId"
    -- TODO be more selective, because there are duplicates
LEFT JOIN
    core."event_Profile_view" profile ON
    profile."baseEntityId" = the_mother."baseEntityId"
    -- TODO be more selective, because there are duplicates
LEFT JOIN
    core."event_Symptoms and Follow-up_view" symptoms_and_follow_up ON
    symptoms_and_follow_up."baseEntityId" = the_mother."baseEntityId"
    -- TODO be more selective, because there are duplicates
LEFT JOIN
    core."event_Physical Exam_view" physical_exam ON
    physical_exam."baseEntityId" = the_mother."baseEntityId"
    -- TODO be more selective, because there are duplicates
LEFT JOIN
    core."event_Tests_view" tests ON
    tests."baseEntityId" = the_mother."baseEntityId"
    -- TODO be more selective, because there are duplicates
LEFT JOIN
    core."event_Counselling and Treatment_view" counselling_and_treatment ON
    counselling_and_treatment."baseEntityId" = the_mother."baseEntityId"
    -- TODO be more selective, because there are duplicates
LEFT JOIN (
    SELECT
        a."baseEntityId",
        max(a.id) AS latest_id
    FROM
        core."event_Contact Visit detailed_view" a
    WHERE
        a."Contact" = 'Contact 3'
    GROUP BY
        a."baseEntityId"
    ) latest_id_of_contact_3 ON
    latest_id_of_contact_3."baseEntityId" = the_mother."baseEntityId"
LEFT JOIN
    core."event_Contact Visit detailed_view" contact_visit_3 ON
    contact_visit_3."baseEntityId" = the_mother."baseEntityId"
    AND contact_visit_3."Contact" = 'Contact 3'
    AND contact_visit_3.id = latest_id_of_contact_3.latest_id
LEFT JOIN
    core."event_Update ANC Registration_view" update_anc_registration ON
    update_anc_registration."baseEntityId" = the_mother."baseEntityId"
    -- TODO be more selective, because there are duplicates
LEFT JOIN
    core."event_ANC Close_view" anc_close ON
    anc_close."baseEntityId" = the_mother."baseEntityId"
    -- TODO be more selective, because there are duplicates
WHERE
    the_mother."baseEntityId" = '66ddf705-1dfa-4191-b26a-06ac843428ac'
;


-- Find out about duplication occurence(s)
SELECT
    a."baseEntityId",
    count(*)
FROM
    core."event_ANC Close_view" a
GROUP BY
    a."baseEntityId"
HAVING
    count(*) > 1;


-- Get latest ID of duplicates
SELECT
    a."baseEntityId",
    max(a.id) AS latest_id
FROM
    core."event_Contact Visit detailed_view" a
WHERE
    a."Contact" = 'Contact 3'
GROUP BY
    a."baseEntityId";