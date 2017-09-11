FROM openshift/jenkins-slave-base-centos7

MAINTAINER Marc Sutter <marc.sutter@camptocamp.com>

LABEL name="jenkins-slave-skopeo" \
      architecture="x86_64" \
      io.k8s.display-name="Jenkins Slave Image Management" \
      io.k8s.description="Image management tools on top of the jenkins slave base image" \
      io.openshift.tags="openshift,skopeo,jenkins,slave,copy"
USER root

RUN yum repolist > /dev/null && \
    yum clean all && \
    INSTALL_PKGS="skopeo" && \
    yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all

USER 1001