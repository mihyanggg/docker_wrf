#!/usr/bin/env bash

# /home/mimi/wk/docker_wrfucm/dkrun.sh

xhost +local:root; \
docker run --privileged -d \
--name wrf \
--hostname wrf \
--add-host wrf:127.0.0.1 \
--ulimit core=-1 \
-e DISPLAY=$DISPLAY \
-v /tmp/.X11-unix:/tmp/.X11-unix:rw \
-v /home/mimi/wk/WRF/:/home/myuser/WRF:rw \
-v /home/mimi/wk/container_cores:/tmp/cores:rw \
wrf-ucm:231213_seoul
#wrf-ucm:bk1208
#wrf-ucm:1.2
#--network host \
