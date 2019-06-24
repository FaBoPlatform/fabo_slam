# usage:
# ./05.online_record.sh output.bag
source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

case $1 in
    /*\.bag)
        OUTPUT_BAG=$1
        ;;
    *.bag)
        OUTPUT_BAG=$PWD/$1
esac
echo ${OUTPUT_BAG}

roscore &
sleep 5 # wait until roscore launch
roslaunch ydlidar ydlidar_x4.launch &
sleep 5 # wait until lidar launch
rosrun rosbag record -a -O $OUTPUT_BAG

