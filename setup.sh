
for dir in . crazyswarm crazyswarm/ros_ws/src/crazyflie_tools/ crazyswarm/ros_ws/src/crazyswarm/externalDependencies/libmotioncapture/ crazyswarm2/ros2_ws/src/crazyswarm2/ crazyswarm2/ros2_ws/src/motion_capture_tracking; do
    echo Cloning submodules at \"$dir\"...
    cd $dir
    git submodule init
    git submodule update --recursive
    cd -
    echo 
done

docker compose build
docker compose run crazyswarm-ros bash -c "cd ros_ws/src/crazyswarm/scripts/pycrazyswarm/cfsim && make"
docker compose run crazyswarm-ros bash -c "cd ros_ws && catkin_make -DCMAKE_BUILD_TYPE=RelWithDebInfo"
docker compose run crazyswarm2-ros2 bash -c "cd ros2_ws && colcon build --symlink-install"