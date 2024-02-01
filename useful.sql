SELECT a.time AS newtime, a.value AS pm01, b.value AS pm02, c.value as pm10
FROM (((SELECT * FROM readings WHERE id = '84fce6076bd0' AND sensor = 'pm01')) AS a FULL OUTER JOIN
    (SELECT * FROM readings WHERE id = '84fce6076bd0' AND sensor = 'pm02') AS b ON (a.time = b.time)) FULL OUTER JOIN
    (SELECT * FROM readings WHERE id = '84fce6076bd0' AND sensor = 'pm10') AS c ON (a.time = c.time)
ORDER BY "newtime" DESC ;
