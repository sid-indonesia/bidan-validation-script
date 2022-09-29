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
        WHEN (
            the_mother.addresses ILIKE '%Jl%Mawar%Kembang%Mekar%Sari%'
            OR the_mother.addresses ILIKE '%Jl%Mawar%Mekar%Sari%Kembang%'
        )
        THEN 1
        ELSE 0
    END AS "1-address2_is_like_Jl_Mawar_Dusun_Kembang_Desa_Mekar_Sari",
    CASE
        -- Nomor HP ibu
        WHEN anc_registration."obs.phone_number.values" ILIKE '%087765420380%'
        THEN 1
        ELSE 0
    END AS "1-phone_number_value_is_equal_to_087765420380",
-- empty in newer version of APK
--    CASE
--        WHEN anc_registration."obs.reminders.humanReadableValues" ILIKE '%yes%'
--        THEN 1
--        ELSE 0
--    END AS "1-reminders_is_equal_to_yes",
-- empty
    CASE
        -- Nama kontak alternatif (suami)
        WHEN anc_registration."obs.alt_name.values" ILIKE '%Ahmad%'
        THEN 1
        ELSE 0
    END AS "1-alt_name_value_is_equal_to_Ahmad",
    CASE
        -- Nomor HP suami
        WHEN the_mother."attributes.alt_phone_number" ILIKE '%081917890344%'
        THEN 1
        ELSE 0
    END AS "1-attributes.alt_phone_number_value_is_equal_to_081917890344",
    CASE
        WHEN (
            (
                anc_registration."obs.cohabitants.values" ILIKE '%Orang tua%'
                AND anc_registration."obs.cohabitants.values" ILIKE '%Pasangan%'
            )
            OR
            (
                anc_registration."obs.cohabitants.values" ILIKE '%Parents%'
                AND anc_registration."obs.cohabitants.values" ILIKE '%Partner%'
            )
        )
        THEN 1
        ELSE 0
    END AS "1-cohabitants_values_are_equal_to_Orang tua, Pasangan",
-- empty in newer version of APK
--    CASE
--        WHEN quick_check_first_contact."obs.contact_reason.humanReadableValues" ILIKE '%first_contact%'
--        THEN 1
--        ELSE 0
--    END AS "2-contact_reason_humanReadableValues_is_equal_to_first_contact",
--    CASE
--        WHEN quick_check_first_contact."obs.danger_signs.humanReadableValues" ILIKE '%Tidak ada%'
--        THEN 1
--        ELSE 0
--    END AS "2-danger_signs_humanReadableValues_is_equal_to_Tidak ada",
--    CASE
--        WHEN (
--            latest_profile."obs.educ_level.humanReadableValues" ILIKE '%shs%'
--            OR latest_profile."obs.educ_level.humanReadableValues" ILIKE '%secondary%'
--        )
--        THEN 1
--        ELSE 0
--    END AS "3-educ_level_humanReadableValues_is_equal_to_shs_or_secondary",
--    CASE
--        WHEN latest_profile."obs.marital_status.humanReadableValues" ILIKE '%married%'
--        THEN 1
--        ELSE 0
--    END AS "3-marital_status_humanReadableValues_is_equal_to_married",
-- empty
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
-- empty in newer version of APK
--    CASE
--        WHEN latest_profile."obs.ultrasound_done.humanReadableValues" ILIKE '%no%'
--        THEN 1
--        ELSE 0
--    END AS "3-ultrasound_done_humanReadableValues_is_equal_to_no",
--    CASE
--        WHEN latest_profile."obs.lmp_gest_age_selection.humanReadableValues" ILIKE '%lmp%'
--        THEN 1
--        ELSE 0
--    END AS "3-lmp_gest_age_selection_humanReadableValues_is_lmp",
-- empty
    CASE
        WHEN latest_profile."obs.gravida.values" ILIKE '%3%'
        THEN 1
        ELSE 0
    END AS "3-gravida_value_is_3",
    CASE
        WHEN latest_profile."obs.parity.values" ILIKE '%1%'
        THEN 1
        ELSE 0
    END AS "3-parity_value_is_1",
    CASE
        WHEN latest_profile."obs.miscarriages_abortions.values" ILIKE '%1%'
        THEN 1
        ELSE 0
    END AS "3-abortus_or_miscarriages_abortions_value_is_1",
    CASE
        WHEN latest_profile."obs.live_births.values" ILIKE '%1%'
        THEN 1
        ELSE 0
    END AS "3-hidup_or_live_births_value_is_1",
-- empty in newer version of APK
--    CASE
--        WHEN latest_profile."obs.last_live_birth_preterm.humanReadableValues" ILIKE '%yes%'
--        THEN 1
--        ELSE 0
--    END AS "3-last_live_birth_preterm_humanReadableValues_is_yes",
-- empty
    CASE
        WHEN (
            latest_profile."obs.prev_preg_comps.humanReadableValues" ILIKE '%Preeklam%sia%'
            OR latest_profile."obs.preeclampsia_risk.values" ILIKE '%1%'
        )
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
-- empty in newer version of APK
--    CASE
--        WHEN latest_profile."obs.covid_vaccine_status.values" ILIKE '%covid_none%'
--        THEN 1
--        ELSE 0
--    END AS "3-covid_vaccine_status_value_is_none",
--    CASE
--        WHEN latest_profile."obs.tt_immun_status.humanReadableValues" ILIKE '%ttcv_not_received%'
--        THEN 1
--        ELSE 0
--    END AS "3-tt_immun_status_humanReadableValues_is_ttcv_not_received",
-- empty
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
-- empty in newer version of APK
--    CASE
--        WHEN latest_profile."obs.tobacco_user.humanReadableValues" ILIKE '%no%'
--        THEN 1
--        ELSE 0
--    END AS "3-tobacco_user_humanReadableValues_is_no",
--    CASE
--        WHEN latest_profile."obs.condom_use.humanReadableValues" ILIKE '%no%'
--        THEN 1
--        ELSE 0
--    END AS "3-condom_use_humanReadableValues_is_no",
--    CASE
--        WHEN latest_profile."obs.alcohol_substance_enquiry.humanReadableValues" ILIKE '%yes%'
--        THEN 1
--        ELSE 0
--    END AS "3-alcohol_substance_enquiry_humanReadableValues_is_yes",
-- empty
    CASE
        WHEN latest_profile."obs.alcohol_substance_use.humanReadableValues" ILIKE '%Tidak%ada%'
        THEN 1
        ELSE 0
    END AS "3-alcohol_substance_use_humanReadableValues_is_Tidak ada",
-- empty in newer version of APK
--    CASE
--        WHEN latest_profile."obs.partner_hiv_status.humanReadableValues" ILIKE '%dont_know%'
--        THEN 1
--        ELSE 0
--    END AS "3-partner_hiv_status_humanReadableValues_is_dont_know",
-- empty
    CASE
        WHEN latest_symptoms_and_follow_up."obs.phys_symptoms.values" ILIKE '%Mual dan muntah%'
        THEN 1
        ELSE 0
    END AS "4-phys_symptoms_values_are_Mual dan muntah",
    CASE
        WHEN latest_physical_exam."obs.height.values" ILIKE '%150%'
        THEN 1
        ELSE 0
    END AS "5-height_value_is_150",
    CASE
        WHEN latest_physical_exam."obs.pregest_weight_unknown.humanReadableValues" ILIKE '%Berat badan pra-kehamilan tidak diketahui%'
        THEN 1
        ELSE 0
    END AS "5-pregest_weight_unknown_humanReadableValues_is_tidak_diketahui",
    CASE
        WHEN latest_physical_exam."obs.current_weight.values" ILIKE '%45%'
        THEN 1
        ELSE 0
    END AS "5-current_weight_value_is_45",
    CASE
        WHEN latest_physical_exam."obs.muac.values" ILIKE '%20.2%'
        THEN 1
        ELSE 0
    END AS "5-muac_value_is_20.2",
    CASE
        WHEN (
            latest_physical_exam."obs.bp_systolic.values" ILIKE '%140%'
            OR latest_physical_exam."obs.bp_systolic_manual.values" ILIKE '%140%'
        )
        THEN 1
        ELSE 0
    END AS "5-bp_systolic_manual_value_is_140",
    CASE
        WHEN (
            latest_physical_exam."obs.bp_diastolic.values" ILIKE '%90%'
            OR latest_physical_exam."obs.bp_diastolic_manual.values" ILIKE '%90%'
        )
        THEN 1
        ELSE 0
    END AS "5-bp_diastolic_manual_value_is_90",
    CASE
        WHEN latest_physical_exam."obs.body_temp.values" ILIKE '%36.5%'
        THEN 1
        ELSE 0
    END AS "5-body_temp_value_is_36.5",
    CASE
        WHEN latest_physical_exam."obs.pulse_rate.values" ILIKE '%78%'
        THEN 1
        ELSE 0
    END AS "5-pulse_rate_value_is_78",
-- empty in newer version of APK
--    CASE
--        WHEN latest_physical_exam."obs.pallor.humanReadableValues" ILIKE '%yes%'
--        THEN 1
--        ELSE 0
--    END AS "5-pallor_humanReadableValues_is_yes",
-- empty
    CASE
        WHEN latest_physical_exam."obs.respiratory_rate.values" ILIKE '%18%'
        THEN 1
        ELSE 0
    END AS "5-respiratory_rate_value_is_18",
-- empty in newer version of APK
--    CASE
--        WHEN latest_physical_exam."obs.cardiac_exam.humanReadableValues" ILIKE '%2%'
--        THEN 1
--        ELSE 0
--    END AS "5-cardiac_exam_humanReadableValues_is_normal_or_2",
--    CASE
--        WHEN latest_physical_exam."obs.breast_exam.humanReadableValues" ILIKE '%1%'
--        THEN 1
--        ELSE 0
--    END AS "5-breast_exam_humanReadableValues_is_not_done_or_1",
--    CASE
--        WHEN latest_physical_exam."obs.abdominal_exam.humanReadableValues" ILIKE '%1%'
--        THEN 1
--        ELSE 0
--    END AS "5-abdominal_exam_humanReadableValues_is_not_done_or_1",
--    CASE
--        WHEN latest_physical_exam."obs.pelvic_exam.humanReadableValues" ILIKE '%1%'
--        THEN 1
--        ELSE 0
--    END AS "5-pelvic_exam_humanReadableValues_is_not_done_or_1",
--    CASE
--        WHEN latest_physical_exam."obs.cervical_exam.humanReadableValues" ILIKE '%1%'
--        THEN 1
--        ELSE 0
--    END AS "5-cervical_exam_humanReadableValues_is_not_done_or_1",
--    CASE
--        WHEN latest_physical_exam."obs.oedema.humanReadableValues" ILIKE '%no%'
--        THEN 1
--        ELSE 0
--    END AS "5-oedema_humanReadableValues_is_no",
-- empty
    CASE
        WHEN latest_physical_exam."obs.sfh.values" ILIKE '%16%'
        THEN 1
        ELSE 0
    END AS "5-sfh_value_is_16",
    CASE
        WHEN latest_physical_exam."obs.fetal_heart_rate.values" ILIKE '%138%'
        THEN 1
        ELSE 0
    END AS "5-fetal_heart_rate_value_is_138",
    CASE
        WHEN latest_physical_exam."obs.no_of_fetuses_unknown.humanReadableValues" ILIKE '%tidak diketahui%'
        THEN 1
        ELSE 0
    END AS "5-no_of_fetuses_unknown_humanReadableValues_is_tidak diketahui",
    CASE
        WHEN (
            latest_tests."obs.hb_gmeter.values" ILIKE '%9.8%'
            OR latest_tests."obs.hb_result.values" ILIKE '%9.8%'
        )
        THEN 1
        ELSE 0
    END AS "6-hb_gmeter_value_is_9.8",
    CASE
        WHEN (
            latest_tests."obs.blood_type.values" ILIKE '%AB%'
            OR latest_tests."obs.blood_type.values" ILIKE '%163117AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA%'
        )
        THEN 1
        ELSE 0
    END AS "6-blood_type_value_is_AB_or_163117AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
    CASE
        WHEN (
            latest_tests."obs.rh_factor.values" ILIKE '%Positif%'
            OR latest_tests."obs.rh_factor.values" ILIKE '%703AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA%'
        )
        THEN 1
        ELSE 0
    END AS "6-rh_factor_value_is_positif_or_703AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
-- empty in newer version of APK
--    CASE
--        WHEN latest_counselling_and_treatment."obs.caffeine_counsel.humanReadableValues" ILIKE '%["done"]%'
--        THEN 1
--        ELSE 0
--    END AS "7-caffeine_counsel_humanReadableValues_is_done",
---- no field in newer version of APK
--    CASE
--        WHEN latest_counselling_and_treatment."obs.tobacco_counsel.humanReadableValues" ILIKE '%["done"]%'
--        THEN 1
--        ELSE 0
--    END AS "7-tobacco_counsel_humanReadableValues_is_done",
---- no field
--    CASE
--        WHEN latest_counselling_and_treatment."obs.eat_exercise_counsel.humanReadableValues" ILIKE '%["done"]%'
--        THEN 1
--        ELSE 0
--    END AS "7-eat_exercise_counsel_humanReadableValues_is_done",
--    CASE
--        WHEN latest_counselling_and_treatment."obs.family_planning_type.humanReadableValues" ILIKE '%lng_iud%'
--        THEN 1
--        ELSE 0
--    END AS "7-family_planning_type_humanReadableValues_is_lng_iud",
--    CASE
--        WHEN latest_counselling_and_treatment."obs.calcium_supp.humanReadableValues" ILIKE '%["done"]%'
--        THEN 1
--        ELSE 0
--    END AS "7-calcium_supp_humanReadableValues_is_done",
--    CASE
--        WHEN latest_counselling_and_treatment."obs.vita_supp.humanReadableValues" ILIKE '%["done"]%'
--        THEN 1
--        ELSE 0
--    END AS "7-vita_supp_humanReadableValues_is_done",
-- empty
    the_mother."dateCreated",
    anc_registration."providerId",
    the_mother."baseEntityId"
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
LEFT JOIN (
    SELECT
        a."baseEntityId",
        max(a.id) AS latest_id
    FROM
        core."event_Symptoms and Follow-up_view" a
    GROUP BY
        a."baseEntityId"
    ) latest_id_of_symptoms_and_follow_up ON
    latest_id_of_symptoms_and_follow_up."baseEntityId" = the_mother."baseEntityId"
LEFT JOIN
    core."event_Symptoms and Follow-up_view" latest_symptoms_and_follow_up ON
    latest_symptoms_and_follow_up.id = latest_id_of_symptoms_and_follow_up.latest_id
LEFT JOIN (
    SELECT
        a."baseEntityId",
        max(a.id) AS latest_id
    FROM
        core."event_Physical Exam_view" a
    GROUP BY
        a."baseEntityId"
    ) latest_id_of_physical_exam ON
    latest_id_of_physical_exam."baseEntityId" = the_mother."baseEntityId"
LEFT JOIN
    core."event_Physical Exam_view" latest_physical_exam ON
    latest_physical_exam.id = latest_id_of_physical_exam.latest_id
LEFT JOIN (
    SELECT
        a."baseEntityId",
        max(a.id) AS latest_id
    FROM
        core."event_Tests_view" a
    GROUP BY
        a."baseEntityId"
    ) latest_id_of_tests ON
    latest_id_of_tests."baseEntityId" = the_mother."baseEntityId"
LEFT JOIN
    core."event_Tests_view" latest_tests ON
    latest_tests.id = latest_id_of_tests.latest_id
LEFT JOIN (
    SELECT
        a."baseEntityId",
        max(a.id) AS latest_id
    FROM
        core."event_Counselling and Treatment_view" a
    GROUP BY
        a."baseEntityId"
    ) latest_id_of_counselling_and_treatment ON
    latest_id_of_counselling_and_treatment."baseEntityId" = the_mother."baseEntityId"
LEFT JOIN
    core."event_Counselling and Treatment_view" latest_counselling_and_treatment ON
    latest_counselling_and_treatment.id = latest_id_of_counselling_and_treatment.latest_id
WHERE
    the_mother."dateCreated" BETWEEN '2022-09-24T00:00:00' AND '2022-09-29T23:00:00'
    AND anc_registration."providerId" ILIKE 'bidankediri'
    AND (
        CASE
            WHEN (
                EXISTS (
                    SELECT
                        1
                    FROM
                        core."event_ANC Close_view" eacv
                    WHERE
                        eacv."baseEntityId"= the_mother."baseEntityId"
                )
            ) THEN FALSE
            ELSE TRUE
        END
    )
ORDER BY
    1
;

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



-- -- Find out about duplication occurence(s)
-- SELECT
--     a."baseEntityId",
--     count(*)
-- FROM
--     core."event_ANC Close_view" a
-- --WHERE
-- --    a."obs.contact_reason.humanReadableValues" = '["first_contact"]'
-- GROUP BY
--     a."baseEntityId"
-- HAVING
--     count(*) > 1;


-- -- Get latest ID of duplicates
-- SELECT
--     a."baseEntityId",
--     max(a.id) AS latest_id
-- FROM
--     core."event_Contact Visit detailed_view" a
-- WHERE
--     a."Contact" = 'Contact 3'
-- GROUP BY
--     a."baseEntityId";
