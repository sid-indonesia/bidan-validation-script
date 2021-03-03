SELECT
	ta.riwayatkomplikasikebidanan
FROM
	sid3.tambah_anc ta;

SELECT
	ka.lokasiperiksaother
FROM
	sid3.kunjungan_anc ka;

SELECT
	kalt.laboratoriumguladarah
FROM
	sid3.kunjungan_anc_lab_test kalt;

SELECT
	*
FROM
	core."event" e
WHERE
	e.json ->> 'obs' ILIKE '%thala%'
	AND e.json ->> 'eventType' = 'Kunjungan ANC Lab Test';

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
ORDER BY
	1;