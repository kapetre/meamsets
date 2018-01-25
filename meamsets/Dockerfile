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


# Configure mapr filesysten
RUN /opt/mapr/server/configure.sh -N lairfs -c -C nexus.evilcorp.internal,zerg.evilcorp.internal,letower.evilcorp.internal,ling1.evilcorp.internal -Z nexus.evilcorp.internal,zerg.evilcorp.internal,letower.evilcorp.internal 

ADD mstreamsetup.sh /tmp/mstreamsetup.sh

# install streamsets datacollector
RUN wget https://archives.streamsets.com/datacollector/3.0.2.0/rpm/el7/streamsets-datacollector-3.0.2.0-el7-all-rpms.tar
RUN tar -xvf streamsets*tar
RUN yum install streamsets-datacollector-3.0.2.0-el7-all-rpms/streamsets-*rpm -y

### Streamsets Specific Steps (taken from streamsets docker examples) ###
ARG SDC_USER=streamsets

# The paths below should generally be attached to a VOLUME for persistence.
# SDC_CONF is where configuration files are stored. This can be shared.
# SDC_DATA is a volume for storing collector state. Do not share this between containers.
# SDC_LOG is an optional volume for file based logs.
# SDC_RESOURCES is where resource files such as runtime:conf resources and Hadoop configuration can be placed.
# STREAMSETS_LIBRARIES_EXTRA_DIR is where extra libraries such as JDBC drivers should go.
# USER_LIBRARIES_DIR is where custom stage libraries are installed.
ENV SDC_CONF=/etc/sdc \
    SDC_DATA=/data \
    SDC_DIST="/opt/streamsets-datacollector-${SDC_VERSION}" \
    SDC_LOG=/logs \
    SDC_RESOURCES=/resources \
    USER_LIBRARIES_DIR=/opt/streamsets-datacollector-user-libs
ENV STREAMSETS_LIBRARIES_EXTRA_DIR="${SDC_DIST}/streamsets-libs-extras"

### MapR - Streamsets specific configuration ###
ENV SDC_HOME=/opt/streamsets-datacollector \
    SDC_CONF=/etc/sdc
    MAPR_HOME=/opt/mapr
    MAPR_VERSION=6.0.0
    MAPR_MEP_VERSION=4

# Run the SDC configuration script.
COPY sdc-configure.sh /
RUN /sdc-configure.sh && rm /sdc-configure.sh

USER ${SDC_USER}
EXPOSE 18630
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["dc", "-exec"]
