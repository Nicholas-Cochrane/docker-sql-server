CREATE DATABASE sensors;
\c sensors

CREATE TABLE devices(
	id TEXT NOT NULL,
	name TEXT NOT NULL,
	PRIMARY KEY(id)
);

INSERT INTO devices (id,name) VALUES ('000000000000',"Test ID");

CREATE TABLE sensors(
	sensor_id TEXT NOT NULL,
	name TEXT NOT NULL,
	unit_abbreviation TEXT,
	unit_full TEXT,
	PRIMARY KEY(sensor_id)
);

INSERT INTO sensors (sensor_id, name, unit_abbreviation, unit_full) VALUES 
	('atmp','Temperature','C','Celsius'),
	('nox_index', 'NOx Index','NOx','24h rolling avg. Index of NOx from 1'),
	('pm01', 'Particulate Matter 1', 'PM01', 'Particulate matter with a diameter of fewer than 1 micron'),
	('pm02', 'Particulate Matter 2.5', 'PM2.5', 'Particulate matter with a diameter of less than 2.5 microns'),
	('pm10', 'Particulate Matter 10', 'PM10', 'Particulate matter with a diameter of less than 2.5 microns'),
	('rco2', 'Carbon Dioxide', 'ppm', 'Carbon dioxide parts per million'),
	('rhum', 'Humidity', '%', 'Relative humidity'),
	('tvoc_index', 'Total Volatile Organic Compound Index', 'TVOC', '24h rolling avg. Index of TVOCs from 100'),
	('wifi', 'Wifi Signal', 'RSSI', 'Received signal strength indicator'),
	('test','Test Entry', NULL, NULL)
	;

CREATE TABLE readings(
	id TEXT NOT NULL,
	sensor TEXT NOT NULL,
	value NUMERIC, -- may change to float(4)
	time TIMESTAMP NOT NULL,
	PRIMARY KEY(id, sensor, time),
	CONSTRAINT fk_id
		FOREIGN KEY (id)
		REFERENCES devices(id)
		ON DELETE NO ACTION,
	CONSTRAINT fk_sensor
		FOREIGN KEY (sensor)
		REFERENCES sensors(sensor_id)
		ON DELETE NO ACTION
);




--USERS
CREATE ROLE read_only_user WITH LOGIN PASSWORD 'changeme';

GRANT CONNECT ON DATABASE sensors TO read_only_user;
GRANT USAGE ON SCHEMA public TO read_only_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_only_user;

CREATE ROLE python_insert_only WITH LOGIN PASSWORD 'changeme';

GRANT CONNECT ON DATABASE sensors TO python_insert_only;
GRANT USAGE ON SCHEMA public TO python_insert_only;
GRANT INSERT ON TABLE readings TO python_insert_only;
GRANT INSERT ON TABLE test TO python_insert_only;
