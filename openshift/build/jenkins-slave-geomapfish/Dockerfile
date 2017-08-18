FROM camptocamp/geomapfish_build:jenkins

MAINTAINER Marc Sutter <marc.sutter@camptocamp.com>

ENV HOME=/home/jenkins-slave \
    JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    PATH=$JAVA_HOME/bin:$PATH \
    JENKINS_SWARM_VERSION=3.4 \
    OPENSHIFT_CLIENT_VERSION=v1.5.0 \
    OPENSHIFT_CLIENT_VERSION_TAG=031cbe4 \
    KOMPOSE_VERSION=v1.0.0 \
    HELM_VERSION=v2.5.1 \
    HELM_TEMPLATE_VERSION=2.5.1.2

# Update
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install software-properties-common && \
    apt-get clean

# Install headless Java (amd64 & i386)
RUN echo "deb http://http.debian.net/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list && \
    dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y -t jessie-backports openjdk-8-jre-headless openjdk-8-jre-headless:i386 && \
    apt-get clean

# Install tools
RUN apt-get update && \
    apt-get install -y wget curl git gettext lsof ca-certificates && \
    apt-get clean

# Create jenkins-user
RUN useradd -c "Jenkins Slave user" -d $HOME -m jenkins-slave

# Install openshift client
RUN curl -sSLO https://github.com/openshift/origin/releases/download/$OPENSHIFT_CLIENT_VERSION/openshift-origin-client-tools-$OPENSHIFT_CLIENT_VERSION-$OPENSHIFT_CLIENT_VERSION_TAG-linux-64bit.tar.gz \
  && tar --strip-components=1 -xvf openshift-origin-client-tools-$OPENSHIFT_CLIENT_VERSION-$OPENSHIFT_CLIENT_VERSION_TAG-linux-64bit.tar.gz -C /usr/local/bin \
  && chmod +x /usr/local/bin/oc \
  && rm -f openshift-origin-client-tools-$OPENSHIFT_CLIENT_VERSION-$OPENSHIFT_CLIENT_VERSION_TAG-linux-64bit.tar.gz

# Install kompose client
RUN curl -sSLO https://github.com/kubernetes/kompose/releases/download/$KOMPOSE_VERSION/kompose-linux-amd64.tar.gz \
  && tar -xvf kompose-linux-amd64.tar.gz \
  && mv ./kompose-linux-amd64 /usr/local/bin/kompose \
  && chmod +x /usr/local/bin/kompose \
  && rm -f kompose-linux-amd64.tar.gz

# Install helm client
RUN curl -sSLO https://storage.googleapis.com/kubernetes-helm/helm-$HELM_VERSION-linux-amd64.tar.gz \
  && tar -xvf helm-$HELM_VERSION-linux-amd64.tar.gz \
  && mv linux-amd64/helm /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm \
  && mkdir -p $HOME/.helm/plugins \
  && chown jenkins-slave:jenkins-slave $HOME/.helm \
  && rm -rf linux-amd64 \
  && rm -f helm-$HELM_VERSION-linux-amd64.tar.gz

# Install helm template plugin
RUN helm plugin install https://github.com/technosophos/helm-template

# Modify access to needed resource as this will run as user jenkins-slave
RUN chmod 660 /etc/passwd && \
    chown :jenkins-slave /etc/passwd && \
    chmod -R 770 /etc/alternatives && \
    chown -R :jenkins-slave /etc/alternatives && \
    chmod -R 770 /var/lib/dpkg/alternatives && \
    chown -R :jenkins-slave /var/lib/dpkg/alternatives && \
    chmod -R 770 /usr/lib/jvm && \
    chown -R :jenkins-slave /usr/lib/jvm && \
    chmod 770 /usr/bin && \
    chown :jenkins-slave /usr/bin && \
    chmod 770 /usr/share/man/man1 && \
    chown :jenkins-slave /usr/share/man/man1 && \
    chown -R jenkins-slave: /usr/lib/node_modules

# Copy the entrypoint
ADD contrib/bin/* /usr/local/bin/

# Run as jenkins-slave
USER jenkins-slave

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/local/bin/run-jnlp-client"]