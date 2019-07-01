# Host machine requirements: setting up docker and (optional) nvidia-docker

1. Install Docker CE, see [installation instructions](https://docs.docker.com/engine/installation/).

  * Also perform the [post installation instructions](https://docs.docker.com/engine/installation/linux/linux-postinstall/), so that docker can be run without requiring root privileges by a non-root user. (this is optional, otherwise, scripts must be run as root)
2. (optional) If you have an NVIDIA graphic card, install the latest drivers.
  * Recommended method:

	```
	sudo add-apt-repository ppa:graphics-drivers/ppa
	sudo apt update
	```

	Then, on Ubuntu from the menu / Dash, click on the "Additional Drivers" and on the tab with the same name, select the driver you want to use, and "Apply changes". Wait until the driver is downloaded and installed, and reboot.


3. (optional) If you have an NVIDIA graphic card and Ubuntu 16.04, install nvidia-docker 1.0. See [installation instructions](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(version-1.0)). If you are on Ubuntu 14.04, you can install nvidia-docker following the instructions [here](https://github.com/NVIDIA/nvidia-docker/tree/1.0), see "Ubuntu distributions" instructions.

  * Also install nvidia-modprobe by running `sudo apt-get install nvidia-modprobe`, a reboot may be required.

# Building this docker image

0. `mkdir ~/Projects`
1. `cd ~/Projects`
1. `git clone https://github.com/eaa3/turtle2i_docker`
2. `cd turtle2i_docker`
3. `docker build . -t turtle`

# Setting up turtle2i packages

Outside docker (in the host machine), follow the steps:

0. `mkdir -p ~/Projects/turtlebot2i/src`

1. `cd ~/Projects/turtlebot2i/src`

2. `git clone https://github.com/eaa3/turtlebot2i .`

3. `git clone https://github.com/Interbotix/arbotix_ros.git -b turtlebot2i`

4. `git clone https://github.com/Interbotix/phantomx_pincher_arm.git`

5. `git clone https://github.com/Interbotix/ros_astra_camera -b filterlibrary`

6. `git clone https://github.com/Interbotix/ros_astra_launch`


# Building turtle2i packages

You must run the following commands inside the docker container with the pre-installed dependencies. To start the docker container you can run:



0. `cd ~/Projects/turtle2i_docker`
1. Run the container: `./bash turtle` 
2. Setup ROS: `source /opt/ros/kinetic/setup.bash`
3. `catkin_make`
4. Source the catkin workspace: `source devel/setup.bash`

(Step 1 will create a container, open a bash terminal with all required setup, including mapping turtlebot2i folder and the needed visualisation configuration inside the docker)

Ps.: You can open other terminals inside the same container by running the script inside turtle2i_docker `./exec_container $(./get_containerId.sh)` on a separate terminal.


# Example usage


After building successfully. Run the following command in a terminal inside the turtle docker container:

`roslaunch turtlebot2i_gazebo turtlebot_world.launch`

(don't forget to source devel/setup.bash beforehand in every terminal you open inside the turtle docker container)


### Manually Command the Arm (in a separate terminal inside the same docker container):

0. Example 1: rostopic pub -1 /turtlebot/arm_shoulder_pan_position_controller/command std_msgs/Float64 "data: 0.4"

1. Example 2: rostopic pub -1 /turtlebot/arm_elbow_flex_position_controller/command std_msgs/Float64 "data: 1.4"


The arm should move around in simulation.
