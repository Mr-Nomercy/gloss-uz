from django.db import migrations

# Two bugs in the original 0002 policy, only found once tests ran against
# a genuinely non-superuser role (every prior test run used a superuser
# connection, which silently bypasses RLS regardless of policy content):
#
# 1. No WITH CHECK clause. Postgres reuses USING for INSERT/UPDATE checks
#    when WITH CHECK is omitted — but that's exactly wrong here: any write
#    made with no tenant context set (Celery tasks, platform_admin/system
#    operations, `all_tenants.create(...)` in tests) evaluates the USING
#    expression to false (NULL != anything) and gets rejected outright.
#
# 2. No "no context => full access" branch. TenantScopedManager already
#    makes `.objects` fail closed to empty at the Python level when there's
#    no tenant in context; `.all_tenants` is the deliberate, explicit
#    escape hatch for cross-tenant/system code (dispatch, platform_admin
#    endpoints). RLS should support that escape hatch — the actual thing
#    it needs to guard against is a request authenticated as tenant A
#    somehow touching tenant B's rows, not "no tenant context at all".
RLS_SQL = """
DROP POLICY IF EXISTS tenant_isolation_team ON workforce_team;
CREATE POLICY tenant_isolation_team ON workforce_team
    USING (
        COALESCE(current_setting('app.current_tenant_id', true), '') = ''
        OR tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer
    )
    WITH CHECK (
        COALESCE(current_setting('app.current_tenant_id', true), '') = ''
        OR tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer
    );

DROP POLICY IF EXISTS tenant_isolation_workerprofile ON workforce_workerprofile;
CREATE POLICY tenant_isolation_workerprofile ON workforce_workerprofile
    USING (
        COALESCE(current_setting('app.current_tenant_id', true), '') = ''
        OR tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer
    )
    WITH CHECK (
        COALESCE(current_setting('app.current_tenant_id', true), '') = ''
        OR tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer
    );

DROP POLICY IF EXISTS tenant_isolation_workerinvitecode ON workforce_workerinvitecode;
CREATE POLICY tenant_isolation_workerinvitecode ON workforce_workerinvitecode
    USING (
        COALESCE(current_setting('app.current_tenant_id', true), '') = ''
        OR tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer
    )
    WITH CHECK (
        COALESCE(current_setting('app.current_tenant_id', true), '') = ''
        OR tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer
    );
"""

REVERSE_SQL = """
DROP POLICY IF EXISTS tenant_isolation_team ON workforce_team;
CREATE POLICY tenant_isolation_team ON workforce_team
    USING (tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer);

DROP POLICY IF EXISTS tenant_isolation_workerprofile ON workforce_workerprofile;
CREATE POLICY tenant_isolation_workerprofile ON workforce_workerprofile
    USING (tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer);

DROP POLICY IF EXISTS tenant_isolation_workerinvitecode ON workforce_workerinvitecode;
CREATE POLICY tenant_isolation_workerinvitecode ON workforce_workerinvitecode
    USING (tenant_id = NULLIF(current_setting('app.current_tenant_id', true), '')::integer);
"""


def fix_rls(apps, schema_editor):
    if schema_editor.connection.vendor != "postgresql":
        return
    with schema_editor.connection.cursor() as cursor:
        cursor.execute(RLS_SQL)


def revert_rls(apps, schema_editor):
    if schema_editor.connection.vendor != "postgresql":
        return
    with schema_editor.connection.cursor() as cursor:
        cursor.execute(REVERSE_SQL)


class Migration(migrations.Migration):
    dependencies = [
        ("workforce", "0004_alter_team_options_alter_workerinvitecode_options_and_more")
    ]
    operations = [migrations.RunPython(fix_rls, revert_rls)]
