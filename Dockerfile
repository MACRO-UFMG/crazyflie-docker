# ROS desktop full base image with additional linux utils
FROM osrf/ros:noetic-desktop-full AS ros-base
ENV DEBIAN_FRONTEND noninteractive
RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /root/.bashrc
RUN apt-get update
RUN apt-get install -y \
    git \
    x11vnc \
    wget \
    unzip \
    xvfb \
    icewm \
    tree \
    dos2unix \
    vim \
    net-tools \
    iputils-ping \
    iproute2 \
    iptables \
    tcpdump \
    nano \
    tmux

# Crazyswarm ros image for development
FROM ros-base AS crazyswarm-ros
ENV CSW_PYTHON=python3
RUN apt-get update
RUN apt install -y \
    swig \
    lib${CSW_PYTHON}-dev \
    ${CSW_PYTHON}-pip \
    ros-${ROS_DISTRO}-tf \
    ros-${ROS_DISTRO}-tf-conversions \
    ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-mocap-optitrack \
    libpcl-dev \
    libusb-1.0-0-dev \
    ffmpeg \
    libxcb-xinerama0 \
    usbutils \
    ${CSW_PYTHON}-tk 
RUN ${CSW_PYTHON} -m pip install --upgrade pip
RUN ${CSW_PYTHON} -m pip install numpy>=1.19.5
RUN ${CSW_PYTHON} -m pip install \
    pytest \
    PyYAML \
    scipy \
    vispy \
    matplotlib \
    ffmpeg-python \
    tk \
    pipdeptree
RUN echo "source /crazyswarm/ros_ws/devel/setup.bash" >> /root/.bashrc 
WORKDIR crazyswarm
CMD stdbuf -o L roscore

# ROS2 desktop full base image with additional linux utils
FROM osrf/ros:humble-desktop AS ros2-base
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y \
    git \
    x11vnc \
    wget \
    unzip \
    xvfb \
    icewm \
    tree \
    dos2unix \
    vim \
    net-tools \
    iputils-ping \
    iproute2 \
    iptables \
    tcpdump \
    nano \
    tmux

# Crazyswarm2 ros2 image for development
FROM ros2-base AS crazyswarm2-ros2
RUN apt-get update
RUN apt install -y \
    libboost-program-options-dev \
    libusb-1.0-0-dev
RUN apt-get install -y \
    ros-${ROS_DISTRO}-tf-transformations \
    python3-pip
RUN pip3 install rowan cflib transforms3d
WORKDIR crazyswarm2 
CMD tail -f /dev/null

# Cfclient docker image
FROM python:3.8 as cfclient
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y \
    git \
    tree \
    dos2unix \
    vim \
    ffmpeg 
RUN apt install -y \
    libqt5x11extras5 \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    usbutils \
    python3-pip 
RUN pip3 install --upgrade pip
RUN pip3 install cfclient
CMD cfclient

# Docker image for crazysim
FROM ros2-base AS crazysim
ENV DEBIAN_FRONTEND noninteractive
# Debian dependencies for Crazyflie Firmware, cfclient and others
RUN apt-get update
RUN apt-get install -y \
    git \
    tree \
    dos2unix \
    vim \
    cmake \
    build-essential \
    lsb-release \
    curl \
    gnupg \
    libqt5x11extras5 \
    libxcb-xinerama0 \
    libxcb-cursor0 \
    usbutils \
    python3-pip 
RUN pip3 install --upgrade pip
RUN pip3 install Jinja2
RUN ln -sf /usr/bin/python3 /usr/bin/python
# Install Gazebo
RUN curl https://packages.osrfoundation.org/gazebo.gpg --output /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] https://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null 
RUN apt-get update
RUN apt-get install -y gz-garden
# Clone CrazySim
RUN git clone https://github.com/gtfactslab/CrazySim.git --recursive
WORKDIR CrazySim
RUN apt remove -y \
    python3-packaging \
    python3-numpy
RUN cd crazyflie-lib-python && \
    SETUPTOOLS_SCM_PRETEND_VERSION=0.1.31 pip install -e .
RUN mkdir -p crazyflie-firmware/sitl_make/build
RUN cd crazyflie-firmware/sitl_make/build && \
    cmake ..
RUN cd crazyflie-firmware/sitl_make/build && \
    make all
WORKDIR /
# Install cfclient
RUN git clone https://github.com/llanesc/crazyflie-clients-python
WORKDIR crazyflie-clients-python
RUN pip3 install -e .
WORKDIR /

CMD  cd /CrazySim/crazyflie-firmware && \
    bash tools/crazyflie-simulation/simulator_files/gazebo/launch/sitl_singleagent.sh -m crazyflie -x 0 -y 0 & \
    cfclient
