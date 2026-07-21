from .dev import *  # noqa: F401,F403

# Tests need deterministic, synchronous task execution — real dev/demo
# runs (runserver + curl) must NOT use this, since eager mode ignores
# `countdown` and would collapse the 15s offer window to zero.
CELERY_TASK_ALWAYS_EAGER = True
CELERY_TASK_EAGER_PROPAGATES = True
