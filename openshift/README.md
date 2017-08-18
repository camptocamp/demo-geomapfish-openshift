OpenShift will not be able to download the source code as it will not have the credentials to authenticate itself against the git repository.

We will upload a private key to OpenShift and authorize its public counterpart at the git hosting, and with those in place, OpenShift will be able to access our private git repository.

First we had to generate an RSA key that is going to be uploaded to OpenShift.
This step is already done and you can find the keys in pass with:

```
pass c2c_mgmtsrv/github-c2c-admin-ci | jq -r '.ssh_private_key' > $HOME/.ssh/id_rsa_github_c2c_admin_ci
chmod 400 $HOME/.ssh/id_rsa_github_c2c_admin_ci
```

Then, upload the key to OpenShift:
```
oc secrets new-sshauth ssh-github-c2c-ci-secret --ssh-privatekey=$HOME/.ssh/id_rsa_github_c2c_admin_ci
```

You have to provide this key to the builder service account:

```
oc secrets link builder ssh-github-c2c-ci-secret
```

We will update our build configuration with this secret later as it does not yet exist.