provide image-puller access, so that geomapfish-xxx projects can pull an image from the geomapfish-cicd project.

```
oc policy add-role-to-group system:image-puller system:serviceaccounts:geomapfish-testing -n geomapfish-cicd
oc policy add-role-to-group system:image-puller system:serviceaccounts:geomapfish-staging -n geomapfish-cicd
oc policy add-role-to-group system:image-puller system:serviceaccounts:geomapfish-prod -n geomapfish-cicd
```

Provide edit access to the tiller service account from the kube-system project in the geomapfish-xxx project.

```
oc policy add-role-to-user edit system:serviceaccount:kube-system:tiller -n geomapfish-testing
oc policy add-role-to-user edit system:serviceaccount:kube-system:tiller -n geomapfish-staging
oc policy add-role-to-user edit system:serviceaccount:kube-system:tiller -n geomapfish-prod
```


