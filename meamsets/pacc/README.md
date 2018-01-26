# Extending the mapr pacc 

This version of theconnector extends the mapr pacc client. 
Run as:

```
docker run -d \
--cap-add SYS_ADMIN \
--cap-add SYS_RESOURCE \
--device /dev/fuse \
-e MAPR_CLUSTER=lairfs \
-e MAPR_CLDB_HOSTS=nexus.evilcorp.internal,zerg.evilcorp.internal,letower.evilcorp.internal,ling1.evilcorp.internal,zerg.evilcorp.internal \
-e MAPR_CONTAINER_USER=thekat \
-e MAPR_CONTAINER_GROUP=pwner_dev \
-e MAPR_CONTAINER_UID=100100 \
-e MAPR_CONTAINER_GID=1475200006 \
-e MAPR_MOUNT_PATH=/mapr \
-p 18630:18630 \
--hostname=`hostname` \
--name meansets \
kapetre/meamsets:latest
```
