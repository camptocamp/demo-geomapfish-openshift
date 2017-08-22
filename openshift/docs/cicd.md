# Create the cicd resources

First we had to generate an RSA key that is going to be uploaded to OpenShift.
This step is already done and you can find the keys in pass with:

```
pass c2c_mgmtsrv/github-c2c-admin-ci | jq -r '.ssh_private_key' > $HOME/.ssh/id_rsa_github_c2c_admin_ci
chmod 400 $HOME/.ssh/id_rsa_github_c2c_admin_ci
```

This secret will be used in following projects:

* geomapfish-cicd for cloning the source to get the Jenkinsfile
* geomapfish-dev for cloning the source to build
* geomapfish-stage for cloning the source to get the tests

```
oc secrets new-sshauth ssh-github-c2c-ci-secret --ssh-privatekey=$HOME/.ssh/id_rsa_github_c2c_admin_ci -n geomapfish-cicd
oc secrets new-sshauth ssh-github-c2c-ci-secret --ssh-privatekey=$HOME/.ssh/id_rsa_github_c2c_admin_ci -n geomapfish-dev
oc secrets new-sshauth ssh-github-c2c-ci-secret --ssh-privatekey=$HOME/.ssh/id_rsa_github_c2c_admin_ci -n geomapfish-stage
```

You can check and see the 3 secrets in each namespace:

```
oc get secrets --all-namespaces | grep ssh-github-c2c-ci-secret
geomapfish-cicd    ssh-github-c2c-ci-secret                                  kubernetes.io/ssh-auth                1         43s
geomapfish-dev     ssh-github-c2c-ci-secret                                  kubernetes.io/ssh-auth                1         42s
geomapfish-stage   ssh-github-c2c-ci-secret                                  kubernetes.io/ssh-auth                1         2m
```

You have to provide this key to the builder service accounts in all 3 namespaces:

```
oc secrets link builder ssh-github-c2c-ci-secret -n geomapfish-cicd
oc secrets link builder ssh-github-c2c-ci-secret -n geomapfish-dev
oc secrets link builder ssh-github-c2c-ci-secret -n geomapfish-stage
```

We can now build and deploy our custom jenkins.
A jenkins slave will also be build based on the 'camptocamp/geomapfish_build:jenkins' image from dockerhub.

Note that you can customize the jenkins plugins and initialization scripts under 'openshift/build/jenkins-custom'
before building.

```
oc create -f ./openshift/resources/jenkins
````
