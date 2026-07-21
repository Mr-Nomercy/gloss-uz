-- Runs as the bootstrap superuser ("gloss"), before 01-app-role-nosuperuser.sql
-- creates the non-superuser app role.
--
-- Installed into template1, not just the "gloss" database: every new
-- database clones template1 by default, including the throwaway
-- `test_gloss` Django's test runner creates for `pytest`/`manage.py
-- test` — so that test DB gets PostGIS for free too. Without this,
-- gloss_app (CREATEDB but not superuser) could create the test
-- database but not the extension inside it.
\c template1
CREATE EXTENSION IF NOT EXISTS postgis;

\c gloss
CREATE EXTENSION IF NOT EXISTS postgis;
