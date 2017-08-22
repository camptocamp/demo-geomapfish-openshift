# Installing Minishift

First Install addons

```bash


```

start minishift
```
minishift start --openshift-version=v3.6.0 --cpus=2 --memory=8192
```

Configure the shell

```
eval $(minishift oc-env)
```

login as system:admin and you should see the default projects

```
oc login -u system:admin

Logged into "https://x.x.x.x:8443" as "system:admin" using existing credentials.

You have access to the following projects and can switch between them with 'oc project <projectname>':

    default
    kube-public
    kube-system
  * myproject
    openshift
    openshift-infra

Using project "myproject".
```

