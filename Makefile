DOCKER = TRUE
DOCKER_BASE = camptocamp/demo-geomapfish
DEVELOPMENT = TRUE
CGXP_INTERFACES =
NGEO_INTERFACES = desktop
CGXP_API = FALSE
VARS_FILE = vars_docker.yaml
VISIBLE_WEB_HOST ?= demo-geomapfish-wsgi-geomapfish-testing.cloudapp.openshift-poc.camptocamp.com

include demo.mk
