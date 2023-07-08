
for dir in . crazyswarm crazyswarm/ros_ws/src/crazyflie_tools/ crazyswarm/ros_ws/src/crazyswarm/externalDependencies/libmotioncapture/ ; do
    echo Cloning submodules at \"$dir\"...
    cd $dir
    git submodule init
    git submodule update --recursive
    cd -
    echo 
done

docker compose build
docker compose run crazyflie-ros bash -c "cd ros_ws/src/crazyswarm/scripts/pycrazyswarm/cfsim && make"
docker compose run crazyflie-ros bash -c "cd ros_ws && catkin_make -DCMAKE_BUILD_TYPE=RelWithDebInfo"