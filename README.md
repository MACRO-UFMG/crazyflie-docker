# crazyflie-docker
Easy setup Crazyflie development environment 

## Pre-requisites:
- Linux OS. We recommended Ubuntu 22.04 LTS
- Docker. [How to install](https://docs.docker.com/engine/install/ubuntu/)

> :warning: **Not tested in WSL**. You may find GUI, networking, and peripheral device mounting issues if you attempt to run on Windows.

## Setup Environment:
The environment can be easily set by running the following script:
```bash
./setup.sh
```
This script does the full bootstrap:
- initializes git submodules recursively
- builds all Docker images declared in `docker-compose.yaml`
- builds the CrazySwarm ROS workspace and simulation artifacts

## Docker utilities
This repository uses `docker compose` plus the helper script `setup.sh`.

### Utility commands
- Initialize/build everything (first-time setup):
```bash
./setup.sh
```

- Build all services:
```bash
docker compose build
```

- Build one service only:
```bash
docker compose build <service>
```

- Start a long-running service:
```bash
docker compose up <service>
```

- Start in detached mode:
```bash
docker compose up -d <service>
```

- Run a one-shot container command:
```bash
docker compose run --rm <service> <command>
```

- Open a shell in a running container:
```bash
docker exec -it <container_name> bash
```

- Follow logs:
```bash
docker compose logs -f <service>
```

- Stop and remove containers:
```bash
docker compose down
```

### Available services
- `cfclient`: GUI client to connect to a Crazyflie through radio/USB.
- `crazyswarm-ros`: ROS Noetic + CrazySwarm development/runtime container.
- `crazysim`: CrazySim + Gazebo + cfclient simulation container.
- `crazyswarm2-ros2` (WIP): defined in `Dockerfile`, currently commented out in `docker-compose.yaml`.

## Run
Run the desired service using `docker compose`:

```bash
docker compose up <service>
```

Services:
- cfclient
- crazyswarm-ros
- crazysim
- crazyswarm2-ros2 (WIP)

Remove stopped containers with
```bash
docker compose down
```

### cfclient
Make sure to plug the radio first:
```bash
xhost +local:root
docker compose run --rm cfclient
```
Then:
- edit the address to match your Crazyflie (example: `0xE7E7E7E703`)
- scan and connect
- use the Console tab for battery and propeller tests

### crazyswarm-ros
```bash
xhost +local:root
docker compose up crazyswarm-ros -d
docker exec -it crazyswarm-ros bash
roslaunch crazyswarm hover_swarm.launch
rosrun crazyswarm
```

### crazysim
```bash
xhost +local:root
docker compose run --rm crazysim
```
This starts the CrazySim Gazebo simulation and launches `cfclient`.
