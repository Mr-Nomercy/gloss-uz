-- POSTGRES_USER ("gloss") is initdb's bootstrap superuser — Postgres
-- refuses `ALTER ROLE gloss NOSUPERUSER` on it directly ("the bootstrap
-- user must have the SUPERUSER attribute"), so the app can't just strip
-- its own flag. Instead: a separate, genuinely non-superuser role that
-- Django actually connects as. Superusers always bypass Row-Level
-- Security, so this is what makes the tenant-isolation RLS policies
-- enforce anything at all for the app's real connection.
CREATE ROLE gloss_app WITH LOGIN PASSWORD 'gloss' NOSUPERUSER CREATEDB;
ALTER DATABASE gloss OWNER TO gloss_app;
ALTER SCHEMA public OWNER TO gloss_app;
GRANT ALL PRIVILEGES ON DATABASE gloss TO gloss_app;
