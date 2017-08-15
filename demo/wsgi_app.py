"""
Module used by c2cwsgiutils_run.sh to provide a WSGI application when starting gunicorn
"""


def create():  # pragma: no cover
    from demo import wsgi
    return wsgi.create_application()


application = create()  # pragma: no cover
