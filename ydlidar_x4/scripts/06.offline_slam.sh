# usage:
# ./06.offline_slam.sh input.bag

#https://www.ncnynl.com/archives/201811/2789.html

case $1 in
    /*\.bag)
        INPUT_BAG=$1
        ;;
    *.bag)
        INPUT_BAG=$PWD/$1
esac
echo ${INPUT_BAG}

source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

roscore &
sleep 5 # wait until roscore launch
roslaunch ydlidar_x4 offline_slam.launch bag_filenames:=${INPUT_BAG}

rosservice call /write_state ${INPUT_BAG}.pbstream

