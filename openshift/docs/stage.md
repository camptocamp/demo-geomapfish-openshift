Provide edit access to the jenkins service account from the geomapfish-cicd project in the geomapfish-testing project.

```
oc policy add-role-to-user edit system:serviceaccount:geomapfish-cicd:jenkins -n geomapfish-testing
```

Then provide image-puller access, so that geomapfish-testing project can pull an image from the geomapfish-cicd project.

```
oc policy add-role-to-group system:image-puller system:serviceaccounts:geomapfish-testing -n geomapfish-cicd
```

Extend router timeout for integration tests

```
oc annotate route demo-geomapfish-wsgi --overwrite haproxy.router.openshift.io/timeout=120s
oc annotate route demo-geomapfish-mapserver --overwrite haproxy.router.openshift.io/timeout=120s
oc annotate route demo-geomapfish-print --overwrite haproxy.router.openshift.io/timeout=120s
```