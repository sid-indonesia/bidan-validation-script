SELECT
	DISTINCT ta.riwayatkomplikasikebidanan
FROM
	sid3.tambah_anc ta;

SELECT
	DISTINCT ka.resikoterdeksipertamakali
FROM
	sid3.kunjungan_anc ka;

SELECT
	DISTINCT kalt.laboratoriumguladarah
FROM
	sid3.kunjungan_anc_lab_test kalt;

SELECT
	DISTINCT rp.rencanapenolongpersalinan
FROM
	sid3.rencana_persalinan rp;

SELECT
	DISTINCT dp.persalinan
FROM
	sid3.dokumentasi_persalinan dp;

SELECT
	DISTINCT kp.rujukan
FROM
	sid3.kunjungan_pnc kp;

SELECT
	*
FROM
	core."event" e
WHERE
	--	e.json ->> 'obs' ILIKE '%pembengkakan%'
	--	AND
 e.json ->> 'eventType' ILIKE '%Neonatal%' ;

SELECT
	*
FROM
	core."event" e
WHERE
	jsonb_pretty(e."json") ILIKE '%Imunisasi%';

SELECT
	c.json ->> 'firstName',
	c.json ->> 'baseEntityId'
FROM
	core.client c
WHERE
	(c."json" ->> 'dateCreated' BETWEEN '2021-02-26T15:00:00+08:00' AND '2021-02-26T18:00:00+08:00'
	OR c."json" ->> 'dateCreated' BETWEEN '2021-02-27T15:00:00+08:00' AND '2021-02-27T18:00:00+08:00'
	OR c."json" ->> 'dateCreated' BETWEEN '2021-02-28T15:00:00+08:00' AND '2021-02-28T18:00:00+08:00')
	AND c."json" ->> 'firstName' <> '-'
	AND c."json" ->> 'lastName' <> '-'
	AND c."json" -> 'relationships' -> 'childId' ->> 1 IS NOT NULL
ORDER BY
	1;

CREATE INDEX event_json_eventtype_idx ON
core."event"((json->>'eventType'));