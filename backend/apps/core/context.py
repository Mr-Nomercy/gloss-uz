import contextvars

_current_tenant_id = contextvars.ContextVar("current_tenant_id", default=None)
_current_actor_id = contextvars.ContextVar("current_actor_id", default=None)


def set_current_tenant_id(tenant_id):
    _current_tenant_id.set(tenant_id)


def get_current_tenant_id():
    return _current_tenant_id.get()


def set_current_actor_id(actor_id):
    _current_actor_id.set(actor_id)


def get_current_actor_id():
    return _current_actor_id.get()
