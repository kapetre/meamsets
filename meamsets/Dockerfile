FROM centos:7 

RUN yum update -y && \
yum install -y wget && \ 
yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel && \ 
yum clean all 

# Set environment variables.
ENV HOME /root 
WORKDIR /root 

# Create local mapr and streamsets users, to be dynamicallt reconfigured during setup script, 
# afer matching host uid/gid is deteremind from the host, through sss bindings. 
RUN groupadd -g 1005 mapr
RUN useradd -l -s /bin/bash mapr -u 1005 -g 1005
RUN groupadd -g 1475200006 pwner_dev
RUN useradd -l -s /bin/bash streamsets -u 1475200018 -g 1475200006

# Install packages for SSSD (enabling user identity passthrough)
RUN yum install -y sssd-client sssd-krb5-common sudo libsss_idmap libsss_nss_idmap libsss_sudo sssd-common krb5-workstation krb5-lib 

# IPA DNS during docker build 
ADD resolv.conf /etc/resolv.conf 

### MapR Setup ###

# import key explicitly to avoid ugly warnings
RUN rpm --import http://package.mapr.com/releases/pub/maprgpg.key

# setup repo and nstall mapr packages
ADD maprtech.repo /etc/yum.repos.d/maprtech.repo 
RUN yum install -y mapr-client mapr-kafka mapr-librdkafka mapr-posix-client-basic mapr-librdkafka mapr-spark
RUN yum -y install vim wget sudo which tar openssh-clients ntp git httpd python-setuptools python-setuptools-devel glibc-common gcc* python-devel 

# create mount path for fuse 
RUN mkdir /mapr

# Configure mapr filesysten
RUN /opt/mapr/server/configure.sh -N lairfs -c -C nexus.evilcorp.internal,zerg.evilcorp.internal,letower.evilcorp.internal,ling1.evilcorp.internal  

RUN systemctl enable mapr-posix-client-basic
#ADD mstreamsetup.sh /tmp/mstreamsetup.sh

### Streamsets Specific Steps (taken from streamsets docker examples) ###
ARG SDC_VERSION=3.0.2.0
ARG SDC_USER=streamsets

# install streamsets datacollector
RUN wget https://archives.streamsets.com/datacollector/${SDC_VERSION}/rpm/el7/streamsets-datacollector-${SDC_VERSION}-el7-all-rpms.tar
RUN tar -xvf streamsets*tar
RUN yum install streamsets-datacollector-${SDC_VERSION}-el7-all-rpms/streamsets-*rpm -y

### MapR - Streamsets specific configuration ###
ENV SDC_HOME=/opt/streamsets-datacollector \
    SDC_CONF=/etc/sdc \
    MAPR_HOME=/opt/mapr \
    SDC_DIST="/opt/streamsets-datacollector" \
    MAPR_VERSION=6.0.0 \
    MAPR_MEP_VERSION=4

# Run the SDC configuration script.
COPY sdc-configure.sh /
RUN /sdc-configure.sh && rm /sdc-configure.sh

RUN /opt/streamsets-datacollector/bin/streamsets setup-mapr

#USER ${SDC_USER}
EXPOSE 18630
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dc", "-exec"]
