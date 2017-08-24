Provide edit access to the jenkins service account from the geomapfish-cicd project in the geomapfish-stage project.

```
oc policy add-role-to-user edit system:serviceaccount:geomapfish-cicd:jenkins -n geomapfish-stage
```

Then provide image-puller access, so that geomapfish-stage project can pull an image from the geomapfish-cicd project.

```
oc policy add-role-to-group system:image-puller system:serviceaccounts:geomapfish-stage -n geomapfish-cicd
```

```
oc policy add-role-to-user \
    system:image-puller system:serviceaccount:geomapfish-cicd:default \
    --namespace=geomapfish-stage
```