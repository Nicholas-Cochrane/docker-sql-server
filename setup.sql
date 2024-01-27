CREATE DATABASE sensors;
\c sensors

CREATE TABLE devices(
	id TEXT NOT NULL,
	name TEXT NOT NULL,
	PRIMARY KEY(id)
);

INSERT INTO devices (id,name) VALUES ('000000000000',"Test ID");

CREATE TABLE readings(
	id TEXT NOT NULL,
	sensor TEXT NOT NULL,
	value NUMERIC, -- may change to float(4)
	time TIMESTAMP NOT NULL,
	PRIMARY KEY(id, sensor, time),
	CONSTRAINT fk_id
		FOREIGN KEY (id)
		REFERENCES devices(id)
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
