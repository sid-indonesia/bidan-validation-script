SELECT *
FROM
    sid3.identitas_ibu ii WHERE ii.first_name ILIKE '%yulan%'

SELECT
	DISTINCT ta.penyakitkronis 
FROM
	sid3.tambah_anc ta;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Tambah ANC';



SELECT
	DISTINCT ka.fe1fe3 
FROM
	sid3.kunjungan_anc ka;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Kunjungan ANC' ;



SELECT
	DISTINCT kalt.laboratoriumguladarah 
FROM
	sid3.kunjungan_anc_lab_test kalt;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Kunjungan ANC Lab Test' ;



SELECT
	DISTINCT rp.persediaanperlengkapanpersalinan 
FROM
	sid3.rencana_persalinan rp;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'rencana persalinan' ;



SELECT
	DISTINCT dp.komplikasilainlain 
FROM
	sid3.dokumentasi_persalinan dp;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Dokumentasi Persalinan' ;



SELECT
	DISTINCT kp.bleeding 
FROM
	sid3.kunjungan_pnc kp;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Kunjungan PNC' ;


SELECT
	DISTINCT kai.integrasiprogrampmtctarv 
FROM
	sid3.kunjungan_anc_integrasi kai;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Kunjungan ANC integrasi';


SELECT
	DISTINCT cr.desaanak 
FROM
	sid3.child_registration cr;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%highriskchildlowbirthweght%'
	AND e."json" ->> 'eventType' = 'Child Registration';


SELECT
	DISTINCT kn.village
FROM
	sid3.kunjungan_neonatal kn;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%lokasiperiksa%'
	AND e."json" ->> 'eventType' = 'Kunjungan neonatal';


SELECT
	DISTINCT kkbp.indikatorberatbedanbayi 
FROM
	sid3.kohort_kunjungan_bayi_perbulan kkbp;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%pemberianasieksklusif%'
	AND e."json" ->> 'eventType' = 'Kohort Kunjungan Bayi Perbulan';



SELECT
	DISTINCT ib.village
FROM
	sid3.imunisasi_bayi ib;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%campak%lanjutan%'
	AND e."json" ->> 'eventType' = 'Imunisasi Bayi';



SELECT
	DISTINCT kb.statuskesehatanbayi 
FROM
	sid3.kunjungan_balita kb;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%penyakit%'
	AND e."json" ->> 'eventType' = 'Kunjungan Balita';



SELECT
	DISTINCT tb.desa 
FROM
	sid3.tambah_bayi tb;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Tambah Bayi';



SELECT
	DISTINCT tk.existinglocation
FROM
	sid3.tambah_kb tk;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Tambah KB';



SELECT
	DISTINCT kpk.keteranganefeksamping
FROM
	sid3.kohort_pelayanan_kb kpk;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Kohort Pelayanan KB';



SELECT
	DISTINCT ppk.subvillage
FROM
	sid3.post_partum_kb ppk;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Post-partum KB';



SELECT
	DISTINCT pi.maternaldeathcause 
FROM
	sid3.penutupan_ibu pi;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Penutupan Ibu';



SELECT
	DISTINCT pa.referred
FROM
	sid3.penutupan_anc pa;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address%'
	AND e."json" ->> 'eventType' = 'Penutupan ANC';



SELECT
	DISTINCT pp.regdate
FROM
	sid3.penutupan_pnc pp;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Penutupan PNC';



SELECT
	DISTINCT pk.registrationdate
FROM
	sid3.penutupan_kb pk;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Penutupan KB';



SELECT
	DISTINCT pa.existingsubvillage
FROM
	sid3.penutupan_anak pa;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%referred%'
	AND e."json" ->> 'eventType' = 'Penutupan Anak';



SELECT
	DISTINCT ei.submissiondate 
FROM
	sid3.edit_ibu ei;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%nomortelponhp%'
	AND e."json" ->> 'eventType' = 'Edit Ibu';



SELECT
	DISTINCT eb.beratbadansaatlahir 
FROM
	sid3.edit_bayi eb;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%%'
	AND e."json" ->> 'eventType' = 'Edit Bayi';



SELECT
	DISTINCT etk.namalengkap
FROM
	sid3.edit_tambah_kb etk;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%address1%'
	AND e."json" ->> 'eventType' = 'Edit Tambah KB';



SELECT
	e."json" ->> 'providerId', e."json" ->> 'locationId'
FROM
	core."event" e
WHERE
	--	e.json ->> 'obs' ILIKE '%pembengkakan%'
	--	AND
 e.json ->> 'providerId' ILIKE '%batuyang.06%' 
ORDER BY 1;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%resikoterdeksipertamakali%'
	AND e."json" ->> 'eventType' = 'Kunjungan ANC' ;

SELECT
	e."json" ->> 'eventType',
	core.get_obs_element_value_by_form_submission_field('humanReadableValues',
		e."json"::core.core_event_json,
		'ancId'),
	e."json" ->> 'baseEntityId'
FROM
	core."event" e
WHERE
    e."json" ->> 'baseEntityId' = 'f1fd4846-4d53-40b2-9d43-cf4e846a1473';

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%other_facility_type%'
    AND
	e."json" ->> 'eventType' = 'patient_diagnostics';



SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%"end"%'
    AND
	e."json" ->> 'eventType' = 'Symptoms and Follow-up';

SELECT
	DISTINCT e."json" ->> 'eventType' AS event_type
FROM
	core."event" e
WHERE
	e."json" ->> 'baseEntityId' IN (
	SELECT
		c."json" ->> 'baseEntityId'
	FROM
		core.client c
	WHERE
		c."json" ->> 'firstName' != '-');



SELECT
	*
FROM
	core.client c
WHERE
    c.id = '3698'
	c."json" ->> 'baseEntityId' IN (
	'8326a168-d44b-4083-945f-adc83d0cb9bd',
	'86776d9f-4151-4076-b128-c73f7959ccf3'
	);

SELECT
	c.json ->> 'firstName',
	c.json ->> 'baseEntityId'
FROM
	core.client c
WHERE
	(c."json" ->> 'dateCreated' BETWEEN '2021-02-26T15:00:00+08:00' AND '2021-02-26T18:00:00+08:00'
	OR c."json" ->> 'dateCreated' BETWEEN '2021-02-27T15:00:00+08:00' AND '2021-02-27T18:00:00+08:00'
	OR c."json" ->> 'dateCreated' BETWEEN '2021-02-28T15:00:00+08:00' AND '2021-02-28T18:00:00+08:00')
--	AND c."json" -> 'relationships' ->> 'childId' IS NOT NULL
	AND c."json" ->> 'firstName' <> '-'
	AND c."json" ->> 'lastName' <> '-'
ORDER BY
	1;

CREATE INDEX event_json_eventtype_idx ON
core."event"((json->>'eventType'));