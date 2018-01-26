# Minio on MapR PACC
#
# VERSION 0.1 - not for production, use at own risk
#

#
# Using MapR PACC as the base image
# For specific versions check: https://hub.docker.com/r/maprtech/pacc/tags/
FROM maprtech/pacc

MAINTAINER thekat @mapr.com

# Install packages for SSSD (enabling user identity passthrough)
RUN yum install -y sssd-client sssd-krb5-common sudo libsss_idmap libsss_nss_idmap libsss_sudo sssd-common krb5-workstation krb5-lib 

# IPA DNS during docker build 
ADD resolv.conf /etc/resolv.conf 

# install streamsets datacollector
ARG SDC_VERSION=3.0.2.0
RUN wget https://archives.streamsets.com/datacollector/${SDC_VERSION}/rpm/el7/streamsets-datacollector-${SDC_VERSION}-el7-all-rpms.tar
RUN tar -xvf streamsets*tar
RUN yum install streamsets-datacollector-${SDC_VERSION}-el7-all-rpms/streamsets-*rpm -y

### MapR - Streamsets specific configuration ###
ENV SDC_HOME=/opt/streamsets-datacollector \
    SDC_CONF=/etc/sdc \
    MAPR_HOME=/opt/mapr \
    SDC_DIST=/opt/streamsets-datacollector \
    SDC_DATA=/mapr/lairfs/opt/streamsets/data \
    SDC_LOG=/mapr/lairfs/opt/streamsets/logs \
    MAPR_VERSION=6.0.0 \
    MAPR_MEP_VERSION=4 \
    SDC_JAVA_OPTS="-Dmaprlogin.password.enabled=true ${SDC_JAVA_OPTS}"
RUN /opt/streamsets-datacollector/bin/streamsets setup-mapr

# Expose the streamsets  server port
EXPOSE 18630

# Add the launch script which checks if the /mapr mountpoint is available in the container
ADD launch.sh /launch.sh
RUN sudo chmod +x /launch.sh
# Launch server as the container user
CMD /launch.sh
#CMD sudo -u thekat -E /opt/streamsets-datacollector/bin/streamsets dc
