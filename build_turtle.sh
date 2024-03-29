#!/bin/bash

DOCKER_IMAGE=$1
WORK_DIR="${HOME}/Projects/"

#192.168.0.9:0
#192.168.0.9:0

if [ -z "$DOCKER_IMAGE" ]
then
      echo "usage: ./bash.sh <docker-image-tag>"
      echo "example: ./bash.sh dev:indigo-cuda"
      echo "to list built docker images run: docker images"
      exit 1
fi
#sudo nvidia-modprobe -u -c=0
# Running container and giving access to X11 in a safer way

docker run -it \
       --user=$(id -u) \
       --env="DISPLAY" \
       --env="QT_X11_NO_MITSHM=1" \
       --workdir="/home/Projects/turtlebot2i" \
       --volume="${WORK_DIR}:/home/Projects" \
       $DOCKER_IMAGE \
       bash -c "source /opt/ros/kinetic/setup.bash && catkin_make"