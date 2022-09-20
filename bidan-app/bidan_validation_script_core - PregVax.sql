--CREATE TYPE core.core_event_json AS ( json jsonb );
--
--CREATE 
--FUNCTION core.check_obs_element_value(TEXT,
--core.core_event_json,
--TEXT,
--TEXT ) RETURNS int AS $$
--SELECT
--	(CASE
--		WHEN (
--		SELECT
--			sub_json.obs_data -> $1 ->> 0
--		FROM
--			(
--			SELECT
--				jsonb_array_elements($2."json" #> '{obs}') AS obs_data ) sub_json
--		WHERE
--			sub_json.obs_data ->> 'formSubmissionField' = $3
--		LIMIT 1) ILIKE $4 THEN 1
--		ELSE 0
--	END) $$ LANGUAGE SQL;
--
--CREATE 
--FUNCTION core.get_obs_element_value_by_form_submission_field(TEXT,
--core.core_event_json,
--TEXT) RETURNS TEXT AS $$
--SELECT
--	sub_json.obs_data -> $1 ->> 0
--FROM
--	(
--	SELECT
--		jsonb_array_elements($2."json" #> '{obs}') AS obs_data ) sub_json
--WHERE
--	sub_json.obs_data ->> 'formSubmissionField' = $3
--LIMIT 1 $$ LANGUAGE SQL;
--
--CREATE 
--FUNCTION core.get_obs_element_value_by_form_submission_field_as_text(TEXT,
--core.core_event_json,
--TEXT) RETURNS TEXT AS $$
--SELECT
--	sub_json.obs_data ->> $1
--FROM
--	(
--	SELECT
--		jsonb_array_elements($2."json" #> '{obs}') AS obs_data ) sub_json
--WHERE
--	sub_json.obs_data ->> 'formSubmissionField' = $3
--LIMIT 1 $$ LANGUAGE SQL;

SELECT
	ibu."json" ->> 'firstName' AS candidate_name,
	(CASE
		WHEN ibu."json" -> 'addresses' -> 0 -> 'addressFields' ->> 'gps' IS NOT NULL THEN 1
		ELSE 0
	END) AS "1-is_gps_has_value",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'pasienWilayah'
		LIMIT 1) = 'pasien_wilayah_desa' THEN 1
		ELSE 0
	END) AS "1-is_pasien_wilayah_bidan",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'pasienPindahan'
		LIMIT 1) ILIKE 'no' THEN 1
		ELSE 0
	END) AS "1-bukan_pindahan_dari_desa_lain",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'puskesmas'
		LIMIT 1) ILIKE '%aikmel%' THEN 1
		ELSE 0
	END) AS "1-puskesmas_is_aikmel",
	(CASE
		WHEN ibu."json" -> 'attributes' ->> 'NoIbu' = '234' THEN 1
		ELSE 0
	END) AS "1-no_ibu_is_234",
	(CASE
		WHEN ibu."json" -> 'attributes' ->> 'nik' = '5239018761921302' THEN 1
		ELSE 0
	END) AS "1-nik_is_5239018761921302",
	(CASE
		WHEN ibu."json" ->> 'lastName' ILIKE '%Abdullah%' THEN 1
		ELSE 0
	END) AS "1-husband_name_is_Abdullah",
	(CASE
		WHEN (ibu."json" ->> 'birthdate')::date = '1993-08-25' THEN 1
		ELSE 0
	END) AS "1-birth_date_is_25_August_1993",
	(CASE
		WHEN ibu."json" -> 'addresses' -> 0 -> 'addressFields' ->> 'address3' ILIKE '%Dusun%Sayang%RT%1%RW%2%Desa%Kembang%Kerang%' THEN 1
		ELSE 0
	END) AS "1-is_alamat_domisili_correct",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'pendidikan'
		LIMIT 1) ILIKE '%Sekolah%Menengah%Atas%' THEN 1
		ELSE 0
	END) AS "1-pendidikan_terakhir_is_SMA",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'agama'
		LIMIT 1) ILIKE '%Islam%' THEN 1
		ELSE 0
	END) AS "1-agama_is_islam",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'pekerjaan'
		LIMIT 1) ILIKE '%Ibu%Rumah%Tangga%' THEN 1
		ELSE 0
	END) AS "1-pekerjaan_is_ibu_rumah_tangga",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'gakinTidak'
		LIMIT 1) ILIKE '%Yes%' THEN 1
		ELSE 0
	END) AS "1-is_gakin",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'posyandu'
		LIMIT 1) ILIKE '%Sejahtera%' THEN 1
		ELSE 0
	END) AS "1-posyandu_is_Sejahtera",
	(CASE
		WHEN ibu."json" -> 'attributes' ->> 'NamaKader' ILIKE '%Nurul%' THEN 1
		ELSE 0
	END) AS "1-nama_kader_is_Nurul",
	(CASE
		WHEN ibu."json" -> 'attributes' ->> 'NamaDukun' ILIKE '%Saknah%' THEN 1
		ELSE 0
	END) AS "1-nama_dukun_is_Saknah",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'asuransiJiwa'
		LIMIT 1) ILIKE '%Jaminan%Kesehatan%Masyarakat%' THEN 1
		ELSE 0
	END) AS "1-asuransi_is_Jaminan_Kesehatan_Masyarakat",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'golonganDarah'
		LIMIT 1) ILIKE 'A' THEN 1
		ELSE 0
	END) AS "1-golongan_darah_is_A",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_identitas_ibu."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'NomorTelponHp'
		LIMIT 1) = '081945456262' THEN 1
		ELSE 0
	END) AS "1-nomor_hp_is_081945456262",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'referenceDate'
		LIMIT 1) = '2022-08-10' THEN 1
		ELSE 0
	END) AS "2-tanggal_kunjungan_is_2022-08-10",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'lokasiPeriksa'
		LIMIT 1) ILIKE '%Polindes%' THEN 1
		ELSE 0
	END) AS "2-lokasi_periksa_is_Polindes",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'pptest'
		LIMIT 1) ILIKE '%Positive%' THEN 1
		ELSE 0
	END) AS "2-pp_test_is_positive",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'jamkesmas'
		LIMIT 1) ILIKE '%Ya%' THEN 1
		ELSE 0
	END) AS "2-is_jamkesmas",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'gravida'
		LIMIT 1) ILIKE '1' THEN 1
		ELSE 0
	END) AS "2-gravida_is_1",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'partus'
		LIMIT 1) ILIKE '0' THEN 1
		ELSE 0
	END) AS "2-partus_is_0",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'abortus'
		LIMIT 1) ILIKE '0' THEN 1
		ELSE 0
	END) AS "2-abortus_is_0",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'hidup'
		LIMIT 1) ILIKE '0' THEN 1
		ELSE 0
	END) AS "2-hidup_is_0",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'tanggalLahirAnakSebelumnya'
		LIMIT 1) IS NULL THEN 1
		ELSE 0
	END) AS "2-tanggal_lahir_anak_sebelumnya_is_null",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'tanggalHPHT'
		LIMIT 1) = '2022-06-08' THEN 1
		ELSE 0
	END) AS "2-tanggal_HPHT_is_2022-06-08",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'tanggalMemperolehBukuKia'
		LIMIT 1) ILIKE '%2022-08-10%' THEN 1
		ELSE 0
	END) AS "2-tanggal_memperoleh_buku_kia_is_2022-08-10",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'bbKg'
		LIMIT 1) = '43' THEN 1
		ELSE 0
	END) AS "2-bb_in_kg_is_43",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'tbCM'
		LIMIT 1) = '155' THEN 1
		ELSE 0
	END) AS "2-tb_in_cm_is_155",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'hasilPemeriksaanLILA'
		LIMIT 1) = '22.5' THEN 1
		ELSE 0
	END) AS "2-lila_in_cm_is_22.5",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'persalinanSebelumnya'
		LIMIT 1) IS NULL THEN 1
		ELSE 0
	END) AS "2-persalinan_sebelumnya_is_null",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'riwayatKomplikasiKebidanan'
		LIMIT 1) IS NULL THEN 1
		ELSE 0
	END) AS "2-riwayat_komplikasi_kebidanan_is_null",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'penyakitKronis'
		LIMIT 1) IS NULL THEN 1
		ELSE 0
	END) AS "2-penyakit_kronis_is_NULL",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_tambah_anc."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'Alergi'
		LIMIT 1) IS NULL THEN 1
		ELSE 0
	END) AS "2-alergi_is_NULL",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'lokasiPeriksa'
		LIMIT 1) ILIKE '%Polindes%' THEN 1
		ELSE 0
	END) AS "3-lokasi_periksa_is_Polindes",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'nomorTelpon'
		LIMIT 1) ILIKE '%Ya%' THEN 1
		ELSE 0
	END) AS "3-is_client_have_phone_number",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'nomorHp'
		LIMIT 1) ILIKE '081945456262' THEN 1
		ELSE 0
	END) AS "3-phone_number_is_081945456262",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'ancDate'
		LIMIT 1) ILIKE '2022-08-10' THEN 1
		ELSE 0
	END) AS "3-tanggal_kunjungan_is_2022-08-10",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'kunjunganKe'
		LIMIT 1) ILIKE '1' THEN 1
		ELSE 0
	END) AS "3-kunjungan_anc_ke_is_1",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'ancKe'
		LIMIT 1) ILIKE '1' THEN 1
		ELSE 0
	END) AS "3-anc_ke_is_1",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'KeteranganK1k4Who'
		LIMIT 1) ILIKE '%Ya%' THEN 1
		ELSE 0
	END) AS "3-is_WHO_standard_definition",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'Jamkesmas'
		LIMIT 1) ILIKE '%jika%ya%' THEN 1
		ELSE 0
	END) AS "3-is_jamkesmas",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'caraMasukTempatPelayanan'
		LIMIT 1) ILIKE '%atas%permintaan%sendiri%' THEN 1
		ELSE 0
	END) AS "3-cara_masuk_tempat_pelayanan_is_atas_permintaan_sendiri",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'anamnesisIbu'
		LIMIT 1) ILIKE '%Mual%muntah%dan%lemas%' THEN 1
		ELSE 0
	END) AS "3-anamnesis_is_mual_muntah_dan_lemas",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'bbKg'
		LIMIT 1) ILIKE '50' THEN 1
		ELSE 0
	END) AS "3-bb_in_kg_is_50",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'tandaVitalTDSistolik'
		LIMIT 1) ILIKE '90' THEN 1
		ELSE 0
	END) AS "3-td_sistolik_is_90",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'tandaVitalTDDiastolik'
		LIMIT 1) ILIKE '80' THEN 1
		ELSE 0
	END) AS "3-td_diastolik_is_80",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'hasilPemeriksaanLILA'
		LIMIT 1) ILIKE '22.5' THEN 1
		ELSE 0
	END) AS "3-lila_in_cm_is_22.5",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'statusGiziibu'
		LIMIT 1) ILIKE '%kekurangan%energi%kronis%' THEN 1
		ELSE 0
	END) AS "3-status_gizi_ibu_is_kekurangan_energi_kronis",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'persentasiJanin'
		LIMIT 1) IS NULL THEN 1
		ELSE 0
	END) AS "3-presentasi_janin_is_null",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'jumlahJanin'
		LIMIT 1) IS NULL THEN 1
		ELSE 0
	END) AS "3-jumlah_janin_is_null",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'pelayananInjeksitt'
		LIMIT 1) ILIKE '%jika_dilakukan%' THEN 1
		ELSE 0
	END) AS "3-is_TT_injection_done",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'statusImunisasitt'
		LIMIT 1) ILIKE '%tt_ke_3%' THEN 1
		ELSE 0
	END) AS "3-status_imunisasi_TT_is_tt_ke_3",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'pelayananCatatDiBukuKia'
		LIMIT 1) ILIKE '%jika_dilakukan%' THEN 1
		ELSE 0
	END) AS "3-is_pelayanan_catat_di_buku_kia_done",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'pelayananfe'
		LIMIT 1) ILIKE '%Ya%' THEN 1
		ELSE 0
	END) AS "3-is_pelayanan_fe",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'values' ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements(e_kunjungan_anc_ke_1."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = 'pelayananFe'
		LIMIT 1) ILIKE '30' THEN 1
		ELSE 0
	END) AS "3-jumlah_fe_is_30",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_1,
	'komplikasidalamKehamilan',
	'%tidak_ada_komplikasi%') AS "3-komplikasi_dalam_kehamilan_is_tidak_ada_komplikasi",
	CASE
		WHEN (core.get_obs_element_value_by_form_submission_field('humanReadableValues',
		e_kunjungan_anc_ke_1,
		'resikoTerdeksiPertamaKali')) IS NULL THEN 1
		ELSE 0
	END AS "3-resiko_terdeteksi_pertama_kali_is_null",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_1,
	'treatment',
	'%Tidak%') AS "3-penanganan_diberikan_is_tidak",
	CASE
		WHEN (core.get_obs_element_value_by_form_submission_field('humanReadableValues',
		e_kunjungan_anc_ke_1,
		'lokasiPeriksaOther')) IS NULL THEN 1
		ELSE 0
	END AS "3-merujuk_fasilitas_lain_is_tidak",
	core.check_obs_element_value('values',
	e_kunjungan_anc_lab_test,
	'laboratoriumPeriksaHbHasil',
	'10') AS "3-hb_in_gr_per_dl_is_10",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_lab_test,
	'laboratoriumPeriksaHbAnemia',
	'%positif%') AS "3-anemia_is_positif",
	core.check_obs_element_value('values',
	e_kunjungan_anc_lab_test,
	'treatmentAnemiaTxt',
	'%Pemberian%suplemen%zat%besi%') AS "3-penanganan_yang_diberikan_is_pemberian_suplemen_zat_besi",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_lab_test,
	'laboratoriumProteinUria',
	'%Tidak%') AS "3-proteinuria_is_tidak",
	core.check_obs_element_value('values',
	e_kunjungan_anc_lab_test,
	'laboratoriumGulaDarah',
	'104') AS "3-gula_darah_in_mg_per_dl_is_104",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_lab_test,
	'laboratoriumThalasemia',
	'%negatif%') AS "3-thalasemia_is_negative",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_lab_test,
	'laboratoriumSifilis',
	'%negatif%') AS "3-sifilis_is_negative",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_lab_test,
	'laboratoriumHbsAg',
	'%negatif%') AS "3-hbs_ag_is_negative",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_lab_test,
	'laboratoriumHiv',
	'%negatif%') AS "3-hiv_is_negative",
	ibu."json" ->> 'dateCreated' AS date_created,
	e_identitas_ibu."json" ->> 'providerId' AS provider_id
FROM
	core.client ibu
LEFT JOIN (
	SELECT
		e."json"
	FROM
		core."event" e
	WHERE
		e."json" ->> 'eventType' = 'Identitas Ibu') e_identitas_ibu ON
	ibu."json" ->> 'baseEntityId' = e_identitas_ibu."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		e."json"
	FROM
		core."event" e
	WHERE
		e."json" ->> 'eventType' = 'Tambah ANC') e_tambah_anc ON
	ibu."json" ->> 'baseEntityId' = e_tambah_anc."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		DISTINCT sub_json."json"
	FROM
		(
		SELECT
			e."json",
			jsonb_array_elements(e."json" #> '{obs}') AS obs_data
		FROM
			core."event" e
		WHERE
			e."json" ->> 'eventType' = 'Kunjungan ANC') sub_json
	WHERE
		sub_json.obs_data ->> 'formSubmissionField' = 'kunjunganKe'
		AND sub_json.obs_data -> 'values' ->> 0 = '1') e_kunjungan_anc_ke_1 ON
	ibu."json" ->> 'baseEntityId' = e_kunjungan_anc_ke_1."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		e."json"
	FROM
		core."event" e
	WHERE
		e."json" ->> 'eventType' = 'Kunjungan ANC Lab Test') e_kunjungan_anc_lab_test ON
	ibu."json" ->> 'baseEntityId' = e_kunjungan_anc_lab_test."json" ->> 'baseEntityId'
WHERE
--	(ibu."json" ->> 'dateCreated' BETWEEN '2021-02-26T15:00:00+08:00' AND '2021-02-26T18:00:00+08:00'
--	OR ibu."json" ->> 'dateCreated' BETWEEN '2021-02-27T15:00:00+08:00' AND '2021-02-27T18:00:00+08:00'
--	OR ibu."json" ->> 'dateCreated' BETWEEN '2021-02-28T15:00:00+08:00' AND '2021-02-28T18:00:00+08:00')
--	AND
	ibu."json" ->> 'dateCreated' BETWEEN '2022-08-24T00:00:00' AND '2022-08-24T23:00:00'
	AND ibu."json" -> 'relationships' ->> 'ibuCaseId' IS NULL
--	AND ibu."json" ->> 'firstName' <> '-'
--	AND ibu."json" ->> 'lastName' <> '-'
	AND e_identitas_ibu."json" ->> 'providerId' ILIKE 'demo_lotim'
ORDER BY
	1;
-- client_anak having firstName
-- and lastName as '-'
-- total client is 104 in East Lombok by above criteria
-- TODO refactor use user-defined function `check_obs_element_value`
-- or `get_obs_element_value_by_form_submission_field` instead of duplicating them
-- TODO joins are duplicative, need more specific criteria of each event
-- or need cleaner data of each ibu (some ibu submit the same form with same details more than once)
-- or filter them (get only newest or oldest one) before join them