#!/bin/bash

# Check if the /mapr/clustername mountpoint is available
#if [ "$(sudo ls /mapr/ |wc -l)" -eq 0 ]; then
#  echo "MapR not running. exiting."
#  exit
#else
  # launch something
  echo "MapR running. Launching Minio"
  #sudo -u thekat -E /opt/streamsets-datacollector/bin/streamsets dc
  sudo -E /opt/streamsets-datacollector/bin/streamsets dc
#fi
