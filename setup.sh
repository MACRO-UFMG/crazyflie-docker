
git submodule update --init --recursive

docker compose build
docker compose run crazyswarm-ros bash -c "cd ros_ws/src/crazyswarm/scripts/pycrazyswarm/cfsim && make"
docker compose run crazyswarm-ros bash -c "cd ros_ws && catkin_make -DCMAKE_BUILD_TYPE=RelWithDebInfo"
# docker compose run crazyswarm2-ros2 bash -c "cd ros2_ws && colcon build --symlink-install"