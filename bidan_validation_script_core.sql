DROP TYPE IF EXISTS core.core_event_json CASCADE;

CREATE TYPE core.core_event_json AS ( json jsonb );

CREATE OR REPLACE
FUNCTION core.check_obs_element_value(TEXT,
core.core_event_json,
TEXT,
TEXT ) RETURNS int AS $$
SELECT
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> $1 ->> 0
		FROM
			(
			SELECT
				jsonb_array_elements($2."json" #> '{obs}') AS obs_data ) sub_json
		WHERE
			sub_json.obs_data ->> 'formSubmissionField' = $3
		LIMIT 1) ILIKE $4 THEN 1
		ELSE 0
	END) $$ LANGUAGE SQL;

CREATE OR REPLACE
FUNCTION core.get_obs_element_value_by_form_submission_field(TEXT,
core.core_event_json,
TEXT) RETURNS TEXT AS $$
SELECT
	sub_json.obs_data -> $1 ->> 0
FROM
	(
	SELECT
		jsonb_array_elements($2."json" #> '{obs}') AS obs_data ) sub_json
WHERE
	sub_json.obs_data ->> 'formSubmissionField' = $3
LIMIT 1 $$ LANGUAGE SQL;

CREATE OR REPLACE
FUNCTION core.get_obs_element_value_by_form_submission_field_as_text(TEXT,
core.core_event_json,
TEXT) RETURNS TEXT AS $$
SELECT
	sub_json.obs_data ->> $1
FROM
	(
	SELECT
		jsonb_array_elements($2."json" #> '{obs}') AS obs_data ) sub_json
WHERE
	sub_json.obs_data ->> 'formSubmissionField' = $3
LIMIT 1 $$ LANGUAGE SQL;

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
		LIMIT 1) ILIKE '%rarang%' THEN 1
		ELSE 0
	END) AS "1-puskesmas_is_rarang",
	(CASE
		WHEN ibu."json" -> 'attributes' ->> 'NoIbu' = '234431' THEN 1
		ELSE 0
	END) AS "1-no_ibu_is_234431",
	(CASE
		WHEN ibu."json" -> 'attributes' ->> 'nik' = '5239018761921302' THEN 1
		ELSE 0
	END) AS "1-nik_is_5239018761921302",
	(CASE
		WHEN ibu."json" ->> 'lastName' ILIKE '%Joko%Prayitno%' THEN 1
		ELSE 0
	END) AS "1-husband_name_is_joko_prayitno",
	(CASE
		WHEN ibu."json" ->> 'birthdate' = '1994-03-04T08:00:00.000+08:00' THEN 1
		ELSE 0
	END) AS "1-birth_date_is_4_march_1994",
	(CASE
		WHEN ibu."json" -> 'addresses' -> 0 -> 'addressFields' ->> 'address3' ILIKE '%Dusun%Sayang%RT%1%RW%2%,%Desa%Rarang%Batas%' THEN 1
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
		LIMIT 1) ILIKE '%Sayang%' THEN 1
		ELSE 0
	END) AS "1-posyandu_is_sayang",
	(CASE
		WHEN ibu."json" -> 'attributes' ->> 'NamaKader' ILIKE '%Ratna%' THEN 1
		ELSE 0
	END) AS "1-nama_kader_is_ratna",
	(CASE
		WHEN ibu."json" -> 'attributes' ->> 'NamaDukun' ILIKE '%Sanah%' THEN 1
		ELSE 0
	END) AS "1-nama_dukun_is_sanah",
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
		LIMIT 1) ILIKE '%Asuransi%Kesehatan%' THEN 1
		ELSE 0
	END) AS "1-asuransi_is_BPJS",
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
		LIMIT 1) ILIKE 'O' THEN 1
		ELSE 0
	END) AS "1-golongan_darah_is_o",
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
		LIMIT 1) = '2019-02-05' THEN 1
		ELSE 0
	END) AS "2-tanggal_kunjungan_is_2019-02-05",
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
		LIMIT 1) ILIKE '%Puskesmas%' THEN 1
		ELSE 0
	END) AS "2-lokasi_periksa_is_puskesmas",
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
		LIMIT 1) = '2018-12-07' THEN 1
		ELSE 0
	END) AS "2-tanggal_HPHT_is_2018-12-07",
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
		LIMIT 1) ILIKE '%2019-02-05%' THEN 1
		ELSE 0
	END) AS "2-tanggal_memperoleh_buku_kia_is_2019-02-05",
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
		LIMIT 1) = '45' THEN 1
		ELSE 0
	END) AS "2-bb_in_kg_is_45",
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
		LIMIT 1) = '148' THEN 1
		ELSE 0
	END) AS "2-tb_in_cm_is_148",
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
		LIMIT 1) = '23.2' THEN 1
		ELSE 0
	END) AS "2-lila_in_cm_is_23.2",
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
		LIMIT 1) ILIKE '%asma%' THEN 1
		ELSE 0
	END) AS "2-penyakit_kronis_is_asma",
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
		LIMIT 1) ILIKE '%Udang%dan%Amoxilin%' THEN 1
		ELSE 0
	END) AS "2-alergi_is_udang_dan_amoxilin",
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
		LIMIT 1) ILIKE '%Puskesmas%' THEN 1
		ELSE 0
	END) AS "3-lokasi_periksa_is_puskesmas",
	(CASE
		WHEN (
		SELECT
			sub_json.obs_data -> 'humanReadableValues' ->> 0
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
		LIMIT 1) ILIKE '2019-02-05' THEN 1
		ELSE 0
	END) AS "3-tanggal_kunjungan_is_2019-02-05",
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
		LIMIT 1) ILIKE '45' THEN 1
		ELSE 0
	END) AS "3-bb_in_kg_is_45",
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
		LIMIT 1) ILIKE '100' THEN 1
		ELSE 0
	END) AS "3-td_sistolik_is_100",
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
		LIMIT 1) ILIKE '70' THEN 1
		ELSE 0
	END) AS "3-td_diastolik_is_70",
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
		LIMIT 1) ILIKE '23.2' THEN 1
		ELSE 0
	END) AS "3-lila_in_cm_is_23.2",
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
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_lab_test,
	'laboratoriumGulaDarah',
	'<_140_mg_dl') AS "3-gula_darah_in_mg_per_dl_is_below_140",
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
	e_kunjungan_anc_ke_3,
	'lokasiPeriksa',
	'%Puskesmas%') AS "4-lokasi_periksa_is_puskesmas",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'nomorHp',
	'081945456262') AS "4-nomor_hp_is_081945456262",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'ancDate',
	'2019-07-01') AS "4-tanggal_kunjungan_is_2019-07-01",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'kunjunganKe',
	'3') AS "4-kunjungan_ke_is_3",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'ancKe',
	'3') AS "4-anc_ke_is_3",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'KeteranganK1k4Who',
	'%Ya%') AS "4-is_WHO_standard_definition",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'Jamkesmas',
	'%jika%ya%') AS "4-is_jamkesmas",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'caraMasukTempatPelayanan',
	'%atas%permintaan%sendiri%') AS "4-cara_masuk_tempat_pelayanan_is_atas_permintaan_sendiri",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'anamnesisIbu',
	'%tidak%ada%keluhan%') AS "4-anamnesis_is_tidak_ada_keluhan",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'bbKg',
	'56.2') AS "4-bb_in_kg_is_56.2",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'tandaVitalTDSistolik',
	'120') AS "4-td_sistolik_is_120",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'tandaVitalTDDiastolik',
	'90') AS "4-td_diastolik_is_90",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'hasilPemeriksaanLILA',
	'23.6') AS "4-lila_in_cm_is_23.6",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'statusGiziibu',
	'normal') AS "4-status_gizi_ibu_is_normal",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'tfu',
	'28') AS "4-tfu_in_cm_is_28",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'refleksPatelaIbu',
	'ada') AS "4-refleks_patela_ibu_is_ada",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'djj',
	'138') AS "4-djj_is_138",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'kepalaJaninTerhadapPAP',
	'belum_masuk') AS "4-kepala_janin_terhadap_PAP_is_belum_masuk",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'persentasiJanin',
	'kepala') AS "4-presentasi_janin_is_kepala",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'jumlahJanin',
	'tunggal') AS "4-jumlah_janin_is_tunggal",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'pelayananInjeksitt',
	'jika_tidak_dilakukan') AS "4-injeksi_TT_is_tidak",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'statusImunisasitt',
	'tt_ke_3') AS "4-status_imunisasi_TT_is_tt_ke_3",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'pelayananCatatDiBukuKia',
	'jika_dilakukan') AS "4-is_pelayanan_catat_di_buku_kia_done",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'pelayananfe',
	'%Ya%') AS "4-is_pelayanan_fe",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'pelayananFe',
	'30') AS "4-jumlah_fe_is_30",
	core.check_obs_element_value('values',
	e_kunjungan_anc_ke_3,
	'fe1Fe3',
	'fe3') AS "4-jenis_fe_is_fe3",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'komplikasidalamKehamilan',
	'tidak_ada_komplikasi') AS "4-komplikasi_dalam_kehamilan_is_tidak_ada_komplikasi",
	CASE
		WHEN (core.get_obs_element_value_by_form_submission_field('humanReadableValues',
		e_kunjungan_anc_ke_3,
		'resikoTerdeksiPertamaKali')) IS NULL THEN 1
		ELSE 0
	END AS "4-resiko_terdeteksi_pertama_kali_is_null",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_anc_ke_3,
	'treatment',
	'%Tidak%') AS "4-penanganan_diberikan_is_tidak",
	CASE
		WHEN (core.get_obs_element_value_by_form_submission_field('humanReadableValues',
		e_kunjungan_anc_ke_3,
		'lokasiPeriksaOther')) IS NULL THEN 1
		ELSE 0
	END AS "4-merujuk_fasilitas_lain_is_tidak",
	core.check_obs_element_value('values',
	e_rencana_persalinan,
	'tanggalKunjunganRencanaPersalinan',
	'2019-08-20') AS "5-tanggal_kunjungan_is_2019-08-20",
	core.check_obs_element_value('humanReadableValues',
	e_rencana_persalinan,
	'lokasiPeriksa',
	'%Puskesmas%') AS "5-lokasi_periksa_is_puskesmas",
	core.check_obs_element_value('humanReadableValues',
	e_rencana_persalinan,
	'rencanaPenolongPersalinan',
	'bidan') AS "5-rencana_penolong_persalinan_is_bidan",
	core.check_obs_element_value('humanReadableValues',
	e_rencana_persalinan,
	'tempatRencanaPersalinan',
	'pusat_kesehatan_masyarakat') AS "5-tempat_rencana_persalinan_is_puskesmas",
	core.check_obs_element_value('humanReadableValues',
	e_rencana_persalinan,
	'rencanaPendampingPersalinan',
	'suami') AS "5-rencana_pendamping_persalinan_is_suami",
	core.check_obs_element_value('humanReadableValues',
	e_rencana_persalinan,
	'transportasi',
	'sepeda_motor') AS "5-transportasi_is_sepeda_motor",
	core.check_obs_element_value('humanReadableValues',
	e_rencana_persalinan,
	'pendonor',
	'keluarga') AS "5-pendonor_is_keluarga",
	core.check_obs_element_value('humanReadableValues',
	e_rencana_persalinan,
	'kondisiRumah',
	'permanen') AS "5-status_rumah_is_permanen",
	core.check_obs_element_value('humanReadableValues',
	e_rencana_persalinan,
	'kondisiRumah',
	'permanen') AS "5-status_rumah_is_permanen",
	core.check_obs_element_value('humanReadableValues',
	e_dokumentasi_persalinan,
	'keadaanIbu',
	'hidup') AS "6-keadaan_ibu_is_hidup",
	CASE
		WHEN core.get_obs_element_value_by_form_submission_field_as_text('humanReadableValues',
		e_dokumentasi_persalinan,
		'persalinan') ILIKE '%kalasatu%kaladua%kalatiga%kalaempat%' THEN 1
		ELSE 0
	END AS "6-persalinan_is_kalasatu_kaladua_kalatiga_kalaempat",
	core.check_obs_element_value('values',
	e_dokumentasi_persalinan,
	'tanggalKalaIAktif',
	'2019-09-15') AS "6-tanggal_kala_satu_aktif_is_2019-09-15",
	core.check_obs_element_value('values',
	e_dokumentasi_persalinan,
	'jamKalaIAktif',
	'21:00') AS "6-jam_kala_satu_aktif_is_21:00",
	core.check_obs_element_value('values',
	e_dokumentasi_persalinan,
	'tanggalKalaII',
	'2019-09-16') AS "6-tanggal_kala_dua_is_2019-09-16",
	core.check_obs_element_value('values',
	e_dokumentasi_persalinan,
	'jamKalaII',
	'01:00') AS "6-jam_kala_dua_is_01:00",
	core.check_obs_element_value('humanReadableValues',
	e_dokumentasi_persalinan,
	'persentasi',
	'belakang_kepala') AS "6-presentasi_is_belakang_kepala",
	core.check_obs_element_value('values',
	e_dokumentasi_persalinan,
	'tanggalPlasentaLahir',
	'2019-09-16') AS "6-tanggal_plasenta_lahir_is_2019-09-16",
	core.check_obs_element_value('values',
	e_dokumentasi_persalinan,
	'jamPlasentaLahir',
	'01:15') AS "6-jam_plasenta_lahir_is_01:15",
	core.check_obs_element_value('values',
	e_dokumentasi_persalinan,
	'perdarahanKalaIV2JamPostpartum',
	'250') AS "6-perdarahan_kala_empat_2_jam_postpartum_in_cc_is_250",
	core.check_obs_element_value('humanReadableValues',
	e_dokumentasi_persalinan,
	'tempatBersalin',
	'pusat_kesehatan_masyarakat') AS "6-tempat_bersalin_is_puskesmas",
	core.check_obs_element_value('humanReadableValues',
	e_dokumentasi_persalinan,
	'penolong',
	'bidan') AS "6-penolong_is_bidan",
	core.check_obs_element_value('humanReadableValues',
	e_dokumentasi_persalinan,
	'caraPersalinanIbu',
	'normal') AS "6-cara_persalinan_ibu_is_normal",
	CASE
		WHEN core.get_obs_element_value_by_form_submission_field_as_text('humanReadableValues',
		e_dokumentasi_persalinan,
		'manajemenAktifKalaIII') ILIKE '%injeksi_oksittosin%peregangan_tali_pusat%masase_fundus_uteri%' THEN 1
		ELSE 0
	END AS "6-manajemenAktifKalaIII_are_injeksi_oksittosin_peregangan_tali_",
	CASE
		WHEN core.get_obs_element_value_by_form_submission_field('humanReadableValues',
		e_dokumentasi_persalinan,
		'integrasiProgram') IS NULL THEN 1
		ELSE 0
	END AS "6-integrasi_program_is_null",
	core.check_obs_element_value('humanReadableValues',
	e_dokumentasi_persalinan,
	'komplikasi',
	'tidak_ada_komplikasi') AS "6-komplikasi_is_tidak_ada_komplikasi",
	core.check_obs_element_value('humanReadableValues',
	e_dokumentasi_persalinan,
	'treatment',
	'%Tidak%') AS "6-penanganan_diberikan_is_tidak",
	core.check_obs_element_value('humanReadableValues',
	e_dokumentasi_persalinan,
	'dirujukKe',
	'tidak_diujuk') AS "6-dirujuk_ke_is_tidak_dirujuk",
	CASE
		WHEN core.get_obs_element_value_by_form_submission_field('humanReadableValues',
		e_dokumentasi_persalinan,
		'alamatBersalin') IS NULL THEN 1
		ELSE 0
	END AS "6-alamat_bersalin_is_null",
	core.check_obs_element_value('humanReadableValues',
	e_dokumentasi_persalinan,
	'keadaanBayi',
	'hidup') AS "6-keadaan_bayi_is_hidup",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'lokasiPeriksa',
	'Rumah_Ibu') AS "7-lokasi_periksa_is_rumah_ibu",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'PNCDate',
	'2019-09-19') AS "7-tanggal_kunjungan_is_2019-09-19",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'hariKeKF',
	'1') AS "7-hari_ke/KF_is_1",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'keadaanUmum',
	'baik') AS "7-keadaan_umum_ibu_is_baik",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'tandaVitalTDSistolik',
	'110') AS "7-sistolik_is_110",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'tandaVitalTDDiastolik',
	'90') AS "7-diastolik_is_90",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'tandaVitalSuhu',
	'36.9') AS "7-suhu_in_celsius_is_36.9",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'tandaVitalNadi',
	'78') AS "7-nadi_in_bpm_is_78",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'tandaVitalPernafasan',
	'20') AS "7-pernafasan_per_minute_is_20",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_pnc,
	'lochia',
	'lochia_rubra') AS "7-lochia_is_rubra",
	core.check_obs_element_value('values',
	e_kunjungan_pnc,
	'bleeding',
	'25') AS "7-perdarahan_in_cc_is_25",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_pnc,
	'pelayananCatatDiBukuKia',
	'jika_dilakukan') AS "7-is_pelayanan_catat_di_buku_kia_done",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_pnc,
	'vitaminA2jamPP',
	'Ya') AS "7-vitamin_A_2_jam_PP_is_ya",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_pnc,
	'vitaminA24jamPP',
	'Ya') AS "7-vitamin_A_24_jam_PP_is_ya",
	CASE
		WHEN core.get_obs_element_value_by_form_submission_field('humanReadableValues',
		e_kunjungan_pnc,
		'integrasiProgram') IS NULL THEN 1
		ELSE 0
	END AS "7-integrasi_program_is_null",
	CASE
		WHEN core.get_obs_element_value_by_form_submission_field('humanReadableValues',
		e_kunjungan_pnc,
		'komplikasi') IS NULL THEN 1
		ELSE 0
	END AS "7-komplikasi_is_null",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_pnc,
	'treatment',
	'%Tidak%') AS "7-penanganan_diberikan_is_tidak",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_pnc,
	'rujukan',
	'Tidak') AS "7-rujukan_is_tidak",
	core.check_obs_element_value('humanReadableValues',
	e_kunjungan_neonatal,
	'lokasiPeriksa',
	'%Puskesmas%') AS "8-lokasi_periksa_is_puskesmas",
	ibu."json" ->> 'dateCreated' AS date_created
FROM
	client ibu
LEFT JOIN (
	SELECT
		e."json"
	FROM
		"event" e
	WHERE
		e."json" ->> 'eventType' = 'Identitas Ibu') e_identitas_ibu ON
	ibu."json" ->> 'baseEntityId' = e_identitas_ibu."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		e."json"
	FROM
		"event" e
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
			"event" e
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
		"event" e
	WHERE
		e."json" ->> 'eventType' = 'Kunjungan ANC Lab Test') e_kunjungan_anc_lab_test ON
	ibu."json" ->> 'baseEntityId' = e_kunjungan_anc_lab_test."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		DISTINCT sub_json."json"
	FROM
		(
		SELECT
			e."json",
			jsonb_array_elements(e."json" #> '{obs}') AS obs_data
		FROM
			"event" e
		WHERE
			e."json" ->> 'eventType' = 'Kunjungan ANC') sub_json
	WHERE
		sub_json.obs_data ->> 'formSubmissionField' = 'kunjunganKe'
		AND sub_json.obs_data -> 'values' ->> 0 = '3') e_kunjungan_anc_ke_3 ON
	ibu."json" ->> 'baseEntityId' = e_kunjungan_anc_ke_3."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		e."json"
	FROM
		"event" e
	WHERE
		e."json" ->> 'eventType' = 'rencana persalinan') e_rencana_persalinan ON
	ibu."json" ->> 'baseEntityId' = e_rencana_persalinan."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		e."json"
	FROM
		"event" e
	WHERE
		e."json" ->> 'eventType' = 'Dokumentasi Persalinan') e_dokumentasi_persalinan ON
	ibu."json" ->> 'baseEntityId' = e_dokumentasi_persalinan."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		e."json"
	FROM
		"event" e
	WHERE
		e."json" ->> 'eventType' = 'Kunjungan PNC') e_kunjungan_pnc ON
	ibu."json" ->> 'baseEntityId' = e_kunjungan_pnc."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		anak."json" -> 'relationships' -> 'ibuCaseId' ->> 0 AS ibu_case_id,
		MAX(anak."json" ->> 'dateEdited') AS date_edited
	FROM
		client anak
	GROUP BY
		1) latest_anak ON
	ibu."json" ->> 'baseEntityId' = latest_anak.ibu_case_id
LEFT JOIN (
	SELECT
		anak."json"
	FROM
		client anak
	WHERE
		anak."json" -> 'relationships' ->> 'ibuCaseId' IS NOT NULL) anak ON
	((ibu."json" -> 'relationships' -> 'childId' ->> 0 = anak."json" ->> 'baseEntityId'
	OR ibu."json" -> 'relationships' -> 'childId' ->> 1 = anak."json" ->> 'baseEntityId')
	AND latest_anak.date_edited = anak."json" ->> 'dateEdited')
LEFT JOIN (
	SELECT
		e."json"
	FROM
		"event" e
	WHERE
		e."json" ->> 'eventType' = 'Kunjungan neonatal') e_kunjungan_neonatal ON
	anak."json" ->> 'baseEntityId' = e_kunjungan_neonatal."json" ->> 'baseEntityId'
WHERE
	(ibu."json" ->> 'dateCreated' BETWEEN '2021-02-26T15:00:00+08:00' AND '2021-02-26T18:00:00+08:00'
	OR ibu."json" ->> 'dateCreated' BETWEEN '2021-02-27T15:00:00+08:00' AND '2021-02-27T18:00:00+08:00'
	OR ibu."json" ->> 'dateCreated' BETWEEN '2021-02-28T15:00:00+08:00' AND '2021-02-28T18:00:00+08:00')
	AND ibu."json" ->> 'firstName' <> '-'
	AND ibu."json" ->> 'lastName' <> '-'
ORDER BY
	1;
-- TODO join latest child
-- client_anak having firstName
-- and lastName as '-'
-- total client is 104 in East Lombok by above criteria
-- TODO refactor use user-defined function `check_obs_element_value`
-- or `get_obs_element_value_by_form_submission_field` instead of duplicating them
-- TODO joins are duplicative, need more specific criteria of each event