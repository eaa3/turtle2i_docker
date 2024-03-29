#!/bin/bash

# Description: starts container and opens an interactive bash shell using image tag passed as parameter
# Usage: ./bash.sh <docker-image-tag>
# Example: ./bash.sh dev:indigo-cuda

DOCKER_IMAGE=$1
WORK_DIR="${HOME}/Projects"
ROOT_DIR="$(cd $( dirname ${BASH_SOURCE[0]} ) && pwd)"
echo "ROOT_DIR: ${ROOT_DIR}"

#192.168.0.9:0
#192.168.0.9:0

if [ -z "$DOCKER_IMAGE" ]
then
      echo "usage: ./bash.sh <docker-image-tag>"
      echo "example: ./bash.sh dev:indigo-cuda"
      echo "to list built docker images run: docker images"
      exit 1
fi

shopt -s expand_aliases
source $HOME/.bashrc
source ${ROOT_DIR}/aml_aliases.sh

# Unsafe container execution with X11 access 
# xhost +
# xdocker run -it \
#        --env="DISPLAY" \
#        --env="QT_X11_NO_MITSHM=1" \
#        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#        --volume="${WORK_DIR}:/home/Projects" \
#        --workdir="/home/Projects/hp_ws/turtlebot2i" \
#        $DOCKER_IMAGE \
#        bash
# xhost - (don't ever forget this)

# Container execution with X11 access in OSX (requires osx_bridge_display.bash to be run beforehand)
# This does not support 3D rendering, i.e. we cannot run rviz (not hardware-accelerated)
# Display host ip
DISPLAY_IP=172.22.159.104 
xdocker run -it \
       --env="LIBGL_ALWAYS_SOFTWARE=1" \
       --env="LIBGL_ALWAYS_INDIRECT=1" \
       --env="DISPLAY=${DISPLAY_IP}:0" \
       --env="QT_X11_NO_MITSHM=1" \
       --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
       --volume="${WORK_DIR}:/home/Projects" \
       --workdir="/home/Projects/turtlebot2i" \
       $DOCKER_IMAGE \
       bash


