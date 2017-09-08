# -*- coding: utf-8 -*-

from pyramid.config import Configurator
#from c2cgeoportal.pyramid_ import locale_negotiator, add_interface, INTERFACE_TYPE_NGEO
from c2cgeoportal.pyramid_ import locale_negotiator, add_interface, add_interface_ngeo, INTERFACE_TYPE_NGEO
from c2cgeoportal.lib.authentication import create_authentication
from demo.resources import Root


def main(global_config, **settings):
    """ This function returns a Pyramid WSGI application.
    """
    config = Configurator(
        root_factory=Root, settings=settings,
        locale_negotiator=locale_negotiator,
        authentication_policy=create_authentication(settings)
    )

    config.include("c2cgeoportal")

    config.add_translation_dirs("demo:locale/")

    # scan view decorator for adding routes
    config.scan()

    # add the interfaces
    add_interface_ngeo(config, interface_name="desktop", route_name="desktop", route="/", renderer="/desktop.html")
    #add_interface(config, "desktop", INTERFACE_TYPE_NGEO)
    add_interface(config, "mobile", INTERFACE_TYPE_NGEO)
    add_interface(config, "edit")
    add_interface(config, "routing")

    return config.make_wsgi_app()
