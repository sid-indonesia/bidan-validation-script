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

SELECT
	c."json" ->> 'firstName' AS candidate_name,
	(CASE
		WHEN c."json" -> 'addresses' -> 0 -> 'addressFields' ->> 'gps' IS NOT NULL THEN 1
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
		WHEN c."json" -> 'attributes' ->> 'NoIbu' = '234431' THEN 1
		ELSE 0
	END) AS "1-no_ibu_is_234431",
	(CASE
		WHEN c."json" -> 'attributes' ->> 'nik' = '5239018761921302' THEN 1
		ELSE 0
	END) AS "1-nik_is_5239018761921302",
	(CASE
		WHEN c."json" ->> 'lastName' ILIKE '%Joko%Prayitno%' THEN 1
		ELSE 0
	END) AS "1-husband_name_is_joko_prayitno",
	(CASE
		WHEN c."json" ->> 'birthdate' = '1994-03-04T08:00:00.000+08:00' THEN 1
		ELSE 0
	END) AS "1-birth_date_is_4_march_1994",
	(CASE
		WHEN c."json" -> 'addresses' -> 0 -> 'addressFields' ->> 'address3' ILIKE '%Dusun%Sayang%RT%1%RW%2%,%Desa%Rarang%Batas%' THEN 1
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
		WHEN c."json" -> 'attributes' ->> 'NamaKader' ILIKE '%Ratna%' THEN 1
		ELSE 0
	END) AS "1-nama_kader_is_ratna",
	(CASE
		WHEN c."json" -> 'attributes' ->> 'NamaDukun' ILIKE '%Sanah%' THEN 1
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
	c."json" ->> 'dateCreated' AS date_created
FROM
	client c
LEFT JOIN (
	SELECT
		e."json"
	FROM
		"event" e
	WHERE
		e."json" ->> 'eventType' = 'Identitas Ibu') e_identitas_ibu ON
	c."json" ->> 'baseEntityId' = e_identitas_ibu."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		e."json"
	FROM
		"event" e
	WHERE
		e."json" ->> 'eventType' = 'Tambah ANC') e_tambah_anc ON
	c."json" ->> 'baseEntityId' = e_tambah_anc."json" ->> 'baseEntityId'
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
	c."json" ->> 'baseEntityId' = e_kunjungan_anc_ke_1."json" ->> 'baseEntityId'
LEFT JOIN (
	SELECT
		e."json"
	FROM
		"event" e
	WHERE
		e."json" ->> 'eventType' = 'Kunjungan ANC Lab Test') e_kunjungan_anc_lab_test ON
	c."json" ->> 'baseEntityId' = e_kunjungan_anc_lab_test."json" ->> 'baseEntityId'
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
	c."json" ->> 'baseEntityId' = e_kunjungan_anc_ke_3."json" ->> 'baseEntityId'
WHERE
	(c."json" ->> 'dateCreated' BETWEEN '2021-02-26T15:00:00+08:00' AND '2021-02-26T18:00:00+08:00'
	OR c."json" ->> 'dateCreated' BETWEEN '2021-02-27T15:00:00+08:00' AND '2021-02-27T18:00:00+08:00'
	OR c."json" ->> 'dateCreated' BETWEEN '2021-02-28T15:00:00+08:00' AND '2021-02-28T18:00:00+08:00')
	AND c."json" ->> 'firstName' <> '-'
	AND c."json" ->> 'lastName' <> '-'
ORDER BY
	1;
-- client_anak having firstName
-- and lastName as '-'
-- total client is 104 in East Lombok by above criteria
-- TODO refactor use user-defined function `check_obs_element_value`
-- or `get_obs_element_value_by_form_submission_field` instead of duplicating them
-- TODO joins are duplicative, need more specific criteria of each event