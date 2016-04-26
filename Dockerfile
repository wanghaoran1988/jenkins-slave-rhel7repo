# The FROM will be replaced when building in OpenShift
FROM openshift/base-rhel7

# Install headless Java
USER root
RUN ls -l /var/log/yum.log && \
    chmod 644 /var/log/yum.log
RUN yum repolist all 
RUN export INSTALL_PKGS="java-1.8.0-openjdk nss_wrapper" && \
    #yum-config-manager --enable oso-rhui-rhel-server-releases && \
   # yum install -y --enablerepo=rhel-7-server-ose-3.1-rpms $INSTALL_PKGS && \
#RUN subscription-manager refresh 
    yum install -y  $INSTALL_PKGS 
RUN rpm -V $INSTALL_PKGS
RUN yum clean all
    mkdir -p /opt/app-root/jenkins && \
    chown -R 1001:0 /opt/app-root/jenkins && \
    chmod -R g+w /opt/app-root/jenkins

# Copy the entrypoint
COPY contrib/openshift/* /opt/app-root/jenkins/
USER 1001

# Run the JNLP client by default
# To use swarm client, specify "/opt/app-root/jenkins/run-swarm-client" as Command
ENTRYPOINT ["/opt/app-root/jenkins/run-jnlp-client"]
