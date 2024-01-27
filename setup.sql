




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
