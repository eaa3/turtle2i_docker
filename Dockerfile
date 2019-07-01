# [SSH IGNORE]

FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu16.04
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},display
MAINTAINER Jim Mainprice <jim.mainprice@ipvs.uni-stuttgart.de>

###################################################################################
# This Dockerfile is also used to generate the official image install ssh 
# script. (see desktop_update folder in amd-clmc/official_images)
# The [SSH IGNORE*]  [/SSH IGNORE*] ; [SSH ONLY*] [/SSH ONLY*] tags are here to indicate
# what will go in the official ssh install script and what will not
###################################################################################

# [/SSH IGNORE]

###############################################################################
# We add all other repositories.
###############################################################################
RUN apt-get update && \
    apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    software-properties-common \
    apt-transport-https

RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    wget http://packages.ros.org/ros.key -O - | apt-key add -

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

# Install sublimetext
RUN wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | apt-key add - && \
    echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list && \
    apt-get update && \
    apt-get install -y sublime-text

RUN apt-get install -y \
    python-pip \
    python-catkin-tools \
    python-rosdep \
    python-rosinstall \
    python-rospkg \
    python-wstool 


RUN apt-get install -y \
    ros-kinetic-desktop-full \
    ros-kinetic-turtlebot-* \
    libudev-dev \
    ros-kinetic-controller-manager \
    python-wxgtk3.0 \
    ros-kinetic-manipulation-msgs \
    ros-kinetic-xacro  

ENV ROS_DISTRO kinetic

# TURTLEBOT_3D_SENSOR=(astra, kinect, asus_xtion_pro, etc)
ENV TURTLEBOT_3D_SENSOR=astra
ENV TURTLEBOT_3D_SENSOR2=sr300
ENV TURTLEBOT_BATTERY=None
ENV TURTLEBOT_STACKS=interbotix
ENV TURTLEBOT_ARM=pincher
# TODO
# ros-kinetic-fcl \ NOT ON KINETIC
# ros-kinetic-keyboard \ NOT ON KINETIC

RUN rosdep init && rosdep update


###############################################################################
# PINOCCHIO
###############################################################################
RUN cd /tmp && \
    git clone --recursive https://github.com/stack-of-tasks/eigenpy && \
    cd eigenpy && mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/pinocchio/ && \
    make install && rm -rf /tmp/eigenpy
RUN cd /tmp && \
    git clone --recursive https://github.com/stack-of-tasks/pinocchio && \
    cd pinocchio && mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr/local/pinocchio/ && \
    make install && rm -rf /tmp/pinocchio

###############################################################################
# PYTHON MODULES
###############################################################################

# RUN pip install --upgrade pip
# RUN pip install pyopenssl
# RUN pip install --upgrade \
#     colorama \
#     matplotlib \
#     ndg-httpsclient \
#     numpy \
#     pyasn1 \
#     schedule \
#     scipy \
#     sklearn \
#     virtualenv \
#     appdirs \
#     h5py \
#     keras \
#     ipython \
#     ipdb \
#     graphviz \
#     zmq
# RUN pip install pydot==1.0.28
# RUN pip install pyparsing==2.0.1
# RUN pip install --upgrade six --target="/usr/lib/python2.7/dist-packages"
# RUN pip install appdirs
# RUN pip install --upgrade protobuf

#[SSH IGNORE]
#########################################
# for convenience, to map workspace in it
#########################################
# RUN mkdir /workspace
# RUN mkdir /ssh
# RUN mkdir /hrmdock
#[/SSH IGNORE]

########################
# start ssh agent
########################
# RUN eval `ssh-agent -s`
