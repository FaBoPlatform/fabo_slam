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
#rosrun urg_node urg_node _ip_address:=$HOKUYO_UST_10LX &
roslaunch hokuyo_ust_10lx lidar.launch ip_address:=$HOKUYO_UST_10LX &
sleep 5 # wait until roscore launch

if [ -z ${OUTPUT_BAG} ]; then
    # ${OUTPUT_BAG} is empty.
    roslaunch hokuyo_ust_10lx online_slam.launch
else
    # Save to rosbag.
    roslaunch hokuyo_ust_10lx online_slam.launch &
    sleep 5
    rosrun rosbag record -a -O $OUTPUT_BAG
fi

