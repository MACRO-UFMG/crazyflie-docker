# crazyflie-docker
Easy setup Crazyflie development environment 

## Pre-requisites:
- Linux OS. We recommended Ubuntu 22.04 LTS
- Docker. [How to install](https://docs.docker.com/engine/install/ubuntu/)

> :warning: **Not tested in WSL**. You may find GUI, networking, and periphels devices mounting issues if attempt to run on Windows.

## Setup Environment:
The environment can be easily set by running the following script:
```bash
./setup.sh
```
In just a few lines, it essentially clones the git submodules, build the docker images, and compiles the crazyswarm ros workspace.

## Run
Run the desired services `docker compose` CLI.

```bash
docker compose up <service>
```

Services:
- cfclient
- crazyswarm-ros
- crazyswarm2-ros2 (WIP)

Rremove stopped containers with
```bash
docker compose down
```

### cfclient
Make sure to plug the radio first
```bash
xhost +local:root
docker compose run cfclient
```
Edit the address to contain the crazyflie's address. Example: 0xE7E7E7E703
Then scan and connect to the crazyflie
On Console tab you can run battery and propeler test

### crazyswarm-ros
```bash
xhost +local:root
docker compose up crazyswarm-ros -d
docker exec -it crazyswarm-ros bash
roslaunch crazyswarm hover_swarm.launch
rosrun crazyswarm
```
