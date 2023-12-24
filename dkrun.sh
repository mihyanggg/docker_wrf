#!/usr/bin/env bash

# /home/mimi/wk/docker_wrfucm/dkrun.sh

xhost +local:root; \
docker run --privileged -d \
--name wrf \
--hostname wrf \
--ulimit core=-1 \
--add-host wrf:127.0.0.1 \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
-v /home/mimi/wk/container_cores:/tmp/cores:rw \
wrf-ucm:1.3

# --ulimit core=-1 # Allow Coredump Creation
#--network host \
#-v /home/mimi/wk/WRF/:/home/myuser/WRF:rw \
