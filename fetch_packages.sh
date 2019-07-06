#!/bin/bash

mkdir -p ~/Projects/turtlebot2i/src
cd ~/Projects/turtlebot2i/src
git clone https://github.com/eaa3/turtlebot2i .
git clone https://github.com/Interbotix/arbotix_ros.git -b turtlebot2i
git clone https://github.com/Interbotix/phantomx_pincher_arm.git
git clone https://github.com/Interbotix/ros_astra_camera -b filterlibrary
git clone https://github.com/Interbotix/ros_astra_launch