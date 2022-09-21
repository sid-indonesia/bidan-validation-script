SELECT
    the_mother."firstName" || ' ' || the_mother."lastName" AS candidate_name,
    CASE
        WHEN anc_registration."obs.nik.values" ILIKE '%5203079868900084%'
        THEN 1
        ELSE 0
    END AS "1-nik_value_is_equal_to_5203079868900084",
    CASE
        WHEN anc_registration."obs.bpjs.values" ILIKE '%0261789%'
        THEN 1
        ELSE 0
    END AS "1-bpjs_value_is_equal_to_0261789",
    CASE
        WHEN the_mother.birthdate::date = '1992-09-12'
        THEN 1
        ELSE 0
    END AS "1-birthdate_is_equal_to_1992-09-12",
    CASE
        WHEN the_mother.addresses ILIKE '%Jl%Mawar%Desa%Kembang%Dusun%Mekar%Sari%'
        THEN 1
        ELSE 0
    END AS "1-address2_is_equal_to_Jl_Mawar_Desa_Kembang_Dusun_Mekar_Sari",
    CASE
        -- Nomor HP ibu
        WHEN anc_registration."obs.phone_number.values" ILIKE '%087765420380%'
        THEN 1
        ELSE 0
    END AS "1-phone_number_value_is_equal_to_087765420380",
    CASE
        WHEN anc_registration."obs.reminders.humanReadableValues" ILIKE '%yes%'
        THEN 1
        ELSE 0
    END AS "1-reminders_is_equal_to_yes",
    CASE
        -- Nama kontak alternatif (suami)
        WHEN anc_registration."obs.alt_name.values" ILIKE '%Ahmad%'
        THEN 1
        ELSE 0
    END AS "1-alt_name_value_is_equal_to_Ahmad",
    CASE
        -- Nomor HP suami
        WHEN anc_registration."obs.alt_phone_number.values" ILIKE '%081917890344%'
        THEN 1
        ELSE 0
    END AS "1-alt_phone_number_value_is_equal_to_081917890344",
    CASE
        WHEN anc_registration."obs.cohabitants.values" ILIKE '%Orang tua%Pasangan%'
        THEN 1
        ELSE 0
    END AS "1-cohabitants_values_are_equal_to_Orang tua_Pasangan",
    CASE
        WHEN quick_check_first_contact."obs.contact_reason.humanReadableValues" ILIKE '%first_contact%'
        THEN 1
        ELSE 0
    END AS "2-contact_reason_humanReadableValues_is_equal_to_first_contact",
    CASE
        WHEN quick_check_first_contact."obs.danger_signs.humanReadableValues" ILIKE '%Tidak ada%'
        THEN 1
        ELSE 0
    END AS "2-danger_signs_humanReadableValues_is_equal_to_Tidak ada",
    CASE
        WHEN (
            latest_profile."obs.educ_level.humanReadableValues" ILIKE '%shs%'
            OR latest_profile."obs.educ_level.humanReadableValues" ILIKE '%secondary%'
        )
        THEN 1
        ELSE 0
    END AS "3-educ_level_humanReadableValues_is_equal_to_shs_or_secondary",
    CASE
        WHEN latest_profile."obs.marital_status.humanReadableValues" ILIKE '%married%'
        THEN 1
        ELSE 0
    END AS "3-marital_status_humanReadableValues_is_equal_to_married",
    CASE
        WHEN (
            latest_profile."obs.occupation.values" ILIKE '%housewife%'
            OR latest_profile."obs.occupation.humanReadableValues" ILIKE '%Ibu Rumah Tangga%'
        )
        THEN 1
        ELSE 0
    END AS "3-occupation_value_is_equal_to_housewife",
    CASE
        WHEN latest_profile."obs.lmp_known_date.values" ILIKE '%03-06-2022%'
        THEN 1
        ELSE 0
    END AS "3-lmp_known_date_value_is_equal_to_03-06-2022",
    CASE
        WHEN latest_profile."obs.ultrasound_done.humanReadableValues" ILIKE '%no%'
        THEN 1
        ELSE 0
    END AS "3-ultrasound_done_humanReadableValues_is_equal_to_no",
    CASE
        WHEN latest_profile."obs.lmp_gest_age.values" ILIKE '%15 minggu 5 hari%'
        THEN 1
        ELSE 0
    END AS "3-lmp_gest_age_value_is_15 minggu 5 hari",
    CASE
        WHEN latest_profile."obs.gravida.values" ILIKE '%3%'
        THEN 1
        ELSE 0
    END AS "3-gravida_value_is_3",
    CASE
        WHEN latest_profile."obs.stillbirths.values" ILIKE '%1%'
        THEN 1
        ELSE 0
    END AS "3-partus_or_stillbirths_value_is_1",
    CASE
        WHEN latest_profile."obs.miscarriages_abortions.values" ILIKE '%0%'
        THEN 1
        ELSE 0
    END AS "3-abortus_or_miscarriages_abortions_value_is_0",
    CASE
        WHEN latest_profile."obs.live_births.values" ILIKE '%1%'
        THEN 1
        ELSE 0
    END AS "3-hidup_or_live_births_value_is_1",
    CASE
        WHEN latest_profile."obs.prev_preg_comps_other.values" ILIKE '%Premature%Hidup%SC%'
        THEN 1
        ELSE 0
    END AS "3-prev_preg_comps_other_value_is_Premature_Hidup_SC",
    CASE
        WHEN latest_profile."obs.prev_preg_comps.humanReadableValues" ILIKE '%Preeklam%sia%'
        THEN 1
        ELSE 0
    END AS "3-prev_preg_comps_humanReadableValues_is_Preeklamsia",
    CASE
        WHEN latest_profile."obs.allergies.humanReadableValues" ILIKE '%Tidak%ada%'
        THEN 1
        ELSE 0
    END AS "3-allergies_humanReadableValues_is_Tidak ada",
    CASE
        WHEN latest_profile."obs.surgeries_other.values" ILIKE '%SC%'
        THEN 1
        ELSE 0
    END AS "3-surgeries_other_value_is_SC",
    CASE
        WHEN latest_profile."obs.health_conditions.humanReadableValues" ILIKE '%Hipertensi%'
        THEN 1
        ELSE 0
    END AS "3-health_conditions_humanReadableValues_is_Hipertensi",
    CASE
        WHEN latest_profile."obs.covid_vaccine_status.values" ILIKE '%covid_none%'
        THEN 1
        ELSE 0
    END AS "3-covid_vaccine_status_value_is_none",
    CASE
        WHEN latest_profile."obs.tt_immun_status.humanReadableValues" ILIKE '%ttcv_not_received%'
        THEN 1
        ELSE 0
    END AS "3-tt_immun_status_humanReadableValues_is_ttcv_not_received",
    CASE
        WHEN latest_profile."obs.medications.humanReadableValues" ILIKE '%Tidak%ada%'
        THEN 1
        ELSE 0
    END AS "3-medications_humanReadableValues_is_Tidak ada",
    CASE
        WHEN latest_profile."obs.caffeine_intake.humanReadableValues" ILIKE '%Lebih%dari%2%cangkir%'
        THEN 1
        ELSE 0
    END AS "3-caffeine_intake_humanReadableValues_is_Lebih_dari_2_cangkir",
    CASE
        WHEN latest_profile."obs.tobacco_user.humanReadableValues" ILIKE '%no%'
        THEN 1
        ELSE 0
    END AS "3-tobacco_user_humanReadableValues_is_no",
    CASE
        WHEN latest_profile."obs.condom_use.humanReadableValues" ILIKE '%no%'
        THEN 1
        ELSE 0
    END AS "3-condom_use_humanReadableValues_is_no",
    CASE
        WHEN latest_profile."obs.alcohol_substance_enquiry.humanReadableValues" ILIKE '%yes%'
        THEN 1
        ELSE 0
    END AS "3-alcohol_substance_enquiry_humanReadableValues_is_yes",
    CASE
        WHEN latest_profile."obs.alcohol_substance_use.humanReadableValues" ILIKE '%Tidak%ada%'
        THEN 1
        ELSE 0
    END AS "3-alcohol_substance_use_humanReadableValues_is_Tidak ada",
    CASE
        WHEN latest_profile."obs.partner_hiv_status.humanReadableValues" ILIKE '%dont_know%'
        THEN 1
        ELSE 0
    END AS "3-partner_hiv_status_humanReadableValues_is_dont_know"
FROM
    core.client_detailed_view the_mother
LEFT JOIN
    core."event_ANC Registration_view" anc_registration ON
    anc_registration."baseEntityId" = the_mother."baseEntityId"
LEFT JOIN (
    SELECT
        a."baseEntityId",
        max(a.id) AS latest_id
    FROM
        core."event_Quick Check_view" a
    WHERE
        a."obs.contact_reason.humanReadableValues" = '["first_contact"]'
    GROUP BY
        a."baseEntityId"
    ) latest_id_of_quick_check_first_contact ON
    latest_id_of_quick_check_first_contact."baseEntityId" = the_mother."baseEntityId"
LEFT JOIN
    core."event_Quick Check_view" quick_check_first_contact ON
    quick_check_first_contact.id = latest_id_of_quick_check_first_contact.latest_id
LEFT JOIN (
    SELECT
        a."baseEntityId",
        max(a.id) AS latest_id
    FROM
        core."event_Profile_view" a
    GROUP BY
        a."baseEntityId"
    ) latest_id_of_profile ON
    latest_id_of_profile."baseEntityId" = the_mother."baseEntityId"
LEFT JOIN
    core."event_Profile_view" latest_profile ON
    latest_profile.id = latest_id_of_profile.latest_id
--LEFT JOIN
--    core."event_Symptoms and Follow-up_view" symptoms_and_follow_up ON
--    symptoms_and_follow_up."baseEntityId" = the_mother."baseEntityId"
--    -- TODO be more selective, because there are duplicates
--LEFT JOIN
--    core."event_Physical Exam_view" physical_exam ON
--    physical_exam."baseEntityId" = the_mother."baseEntityId"
--    -- TODO be more selective, because there are duplicates
--LEFT JOIN
--    core."event_Tests_view" tests ON
--    tests."baseEntityId" = the_mother."baseEntityId"
--    -- TODO be more selective, because there are duplicates
--LEFT JOIN
--    core."event_Counselling and Treatment_view" counselling_and_treatment ON
--    counselling_and_treatment."baseEntityId" = the_mother."baseEntityId"
--    -- TODO be more selective, because there are duplicates
--LEFT JOIN (
--    SELECT
--        a."baseEntityId",
--        max(a.id) AS latest_id
--    FROM
--        core."event_Contact Visit detailed_view" a
--    WHERE
--        a."Contact" = 'Contact 3'
--    GROUP BY
--        a."baseEntityId"
--    ) latest_id_of_contact_3 ON
--    latest_id_of_contact_3."baseEntityId" = the_mother."baseEntityId"
--LEFT JOIN
--    core."event_Contact Visit detailed_view" contact_visit_3 ON
--    contact_visit_3."baseEntityId" = the_mother."baseEntityId"
--    AND contact_visit_3."Contact" = 'Contact 3'
--    AND contact_visit_3.id = latest_id_of_contact_3.latest_id
--LEFT JOIN
--    core."event_Update ANC Registration_view" update_anc_registration ON
--    update_anc_registration."baseEntityId" = the_mother."baseEntityId"
--    -- TODO be more selective, because there are duplicates
--LEFT JOIN
--    core."event_ANC Close_view" anc_close ON
--    anc_close."baseEntityId" = the_mother."baseEntityId"
--    -- TODO be more selective, because there are duplicates
--WHERE
--    the_mother."baseEntityId" = '66ddf705-1dfa-4191-b26a-06ac843428ac'
;


-- Find out about duplication occurence(s)
SELECT
    a."baseEntityId",
    count(*)
FROM
    core."event_Quick Check_view" a
WHERE
    a."obs.contact_reason.humanReadableValues" = '["first_contact"]'
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