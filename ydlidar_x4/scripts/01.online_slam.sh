source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

case $1 in
    /*\.bag)
        OUTPUT_BAG=$1
        ;;
    *.bag)
        OUTPUT_BAG=$PWD/$1
esac

roscore &
sleep 5 # wait until roscore launch
roslaunch ydlidar ydlidar_x4.launch &
sleep 5 # wait until roscore launch

if [ -z ${OUTPUT_BAG} ]; then
    # ${OUTPUT_BAG} is empty.
    roslaunch ydlidar_x4 online_slam.launch
else
    # Save to rosbag.
    roslaunch ydlidar_x4 online_slam.launch &
    sleep 5
    rosrun rosbag record -a -O $OUTPUT_BAG
fi

