-- POSTGRES_USER is created as a superuser by the official postgres/postgis
-- image, and superusers always bypass Row-Level Security. Stripping that
-- flag is what makes the tenant-isolation RLS policies actually enforce
-- anything for the app's own connection.
ALTER ROLE gloss NOSUPERUSER;
