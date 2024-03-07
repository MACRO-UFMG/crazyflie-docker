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

## Usage
Run the desired services `docker compose` CLI.

```bash
docker compose up <service>
```

Services:
- crazyswarm-ros

Rremove stopped containers with
```bash
docker compose down
```
