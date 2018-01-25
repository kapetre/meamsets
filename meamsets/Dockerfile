FROM centos:7 

RUN yum update -y && \
yum install -y wget && \ 
yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel && \ 
yum clean all 

# Set environment variables.
ENV HOME /root 

# Define working directory.
WORKDIR /root 

# Define default command.
CMD ["bash"] 

# install streamsets datacollector

RUN yum install -y https://archives.streamsets.com/datacollector/1.2.1.0/rpm/streamsets-datacollector-1.2.1.0-1.noarch.rpm; 

# create links to config files
RUN mkdir /opt/streamsets-datacollector/etc && ln -s /etc/sdc/sdc-security.policy /opt/streamsets-datacollector/etc/sdc-security.policy && ln -s /etc/sdc/sdc.properties /opt/streamsets-datacollector/etc/sdc.properties 

# Disable authentication by default, override with custom sdc.properties
RUN sed -i 's|\(http.authentication=\).*|\1none|' "/etc/sdc/sdc.properties"

EXPOSE 18630

COPY start-sdc.sh /tmp/start-sdc.sh 

# make start script executable
RUN chmod 0755 /tmp/start-sdc.sh 


#export SDC_HOME=/opt/streamsets-datacollector
#export SDC_CONF=/etc/sdc
#export MAPR_HOME=/opt/mapr
#export MAPR_VERSION=6.0.0
#export MAPR_MEP_VERSION=4

# SSS Pipes ( enabling user identity passthrough )
RUN yum install -y sssd-client sssd-krb5-common sudo libsss_idmap libsss_nss_idmap libsss_sudo sssd-common krb5-workstation krb5-lib 


### MapR Setup

# mapr and streamsets users, to be dynamicallt reconfigured during setup script, afer matching host uid/gid is deteremind from the host, through sss bindings. 
RUN groupadd -g 5000 mapr
RUN useradd -l -s /bin/bash mapr -u 5000 -g 5000
RUN groupadd -g 6000 pwner_dev
RUN useradd -l -s /bin/bash streamsets -u 5001 -g 6000

# import key explicitly to avoid ugly warnings
RUN rpm --import http://package.mapr.com/releases/pub/maprgpg.key

# install mapr packages
ADD maprtech.repo /etc/yum.repos.d/maprtech.repo 

RUN yum install -y mapr-client mapr-kafka mapr-librdkafka mapr-posix-client-container mapr-librdkafka mapr-spark
RUN yum -y install vim wget sudo which tar openssh-clients ntp git httpd python-setuptools python-setuptools-devel glibc-common gcc* python-devel 

# IPA DNS during docker build
ADD resolv.conf /etc/resolv.conf 

# Configure mapr
USER root 
RUN /opt/mapr/server/configure.sh -N lairfs -c -C nexus.evilcorp.internal,zerg.evilcorp.internal,letower.evilcorp.internal,ling1.evilcorp.internal -Z nexus.evilcorp.internal,zerg.evilcorp.internal,letower.evilcorp.internal 

ADD mstreamsetup.sh /tmp/mstreamsetup.sh

ENTRYPOINT [ "/tmp/start-sdc.sh" ]
