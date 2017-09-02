# Permissions

Add 
```
oc edit scc anyuid
```

Add projects default sa

```
...
users:
...
- system:serviceaccount:geomapfish-testing:default
- system:serviceaccount:geomapfish-staging:default
- system:serviceaccount:geomapfish-prod:default
...
```
