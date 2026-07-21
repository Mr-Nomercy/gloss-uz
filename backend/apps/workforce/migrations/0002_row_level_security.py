from django.db import migrations

RLS_SQL = """
ALTER TABLE workforce_team ENABLE ROW LEVEL SECURITY;
ALTER TABLE workforce_team FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_team ON workforce_team
    USING (tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer);

ALTER TABLE workforce_workerprofile ENABLE ROW LEVEL SECURITY;
ALTER TABLE workforce_workerprofile FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_workerprofile ON workforce_workerprofile
    USING (tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer);

ALTER TABLE workforce_workerinvitecode ENABLE ROW LEVEL SECURITY;
ALTER TABLE workforce_workerinvitecode FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_workerinvitecode ON workforce_workerinvitecode
    USING (tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer);
"""

REVERSE_SQL = """
DROP POLICY IF EXISTS tenant_isolation_team ON workforce_team;
ALTER TABLE workforce_team DISABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation_workerprofile ON workforce_workerprofile;
ALTER TABLE workforce_workerprofile DISABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS tenant_isolation_workerinvitecode ON workforce_workerinvitecode;
ALTER TABLE workforce_workerinvitecode DISABLE ROW LEVEL SECURITY;
"""


def enable_rls(apps, schema_editor):
    # RLS is Postgres-only; sqlite (used for fast local/unit tests) skips it.
    if schema_editor.connection.vendor != "postgresql":
        return
    with schema_editor.connection.cursor() as cursor:
        cursor.execute(RLS_SQL)


def disable_rls(apps, schema_editor):
    if schema_editor.connection.vendor != "postgresql":
        return
    with schema_editor.connection.cursor() as cursor:
        cursor.execute(REVERSE_SQL)


class Migration(migrations.Migration):
    dependencies = [("workforce", "0001_initial")]
    operations = [migrations.RunPython(enable_rls, disable_rls)]
