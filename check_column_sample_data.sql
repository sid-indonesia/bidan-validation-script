SELECT
	ta.riwayatkomplikasikebidanan
FROM
	sid3.tambah_anc ta;

SELECT
	ka.lokasiperiksaother
FROM
	sid3.kunjungan_anc ka;

SELECT
	*
FROM
	core."event" e
WHERE
	e.json ->> 'obs' LIKE '%lokasiperiksaother%'
	AND e.json ->> 'eventType' = 'Kunjungan ANC';

SELECT
	c.json ->> 'firstName'
FROM
	core.client c
WHERE
	--	c."json" ->> 'dateCreated' BETWEEN '2021-02-28T00:00:00+08:00' AND '2021-02-28T23:59:59+08:00'
(c."json" ->> 'dateCreated' BETWEEN '2021-02-26T15:00:00+08:00' AND '2021-02-26T18:00:00+08:00'
	OR c."json" ->> 'dateCreated' BETWEEN '2021-02-27T15:00:00+08:00' AND '2021-02-27T18:00:00+08:00'
	OR c."json" ->> 'dateCreated' BETWEEN '2021-02-28T15:00:00+08:00' AND '2021-02-28T18:00:00+08:00')
	AND c."json" ->> 'firstName' <> '-'
	AND c."json" ->> 'lastName' <> '-'
ORDER BY 1;