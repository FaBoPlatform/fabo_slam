# usage:
# ./09.online_localization.sh input.bag.pbstream

case $1 in
    /*\.pbstream)
        INPUT_PB=$1
        ;;
    *.pbstream)
        INPUT_PB=$PWD/$1
esac
echo ${INPUT_PB}


source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

roscore &
sleep 5 # wait until roscore launch
#rosrun urg_node urg_node _ip_address:=$HOKUYO_UST_10LX &
roslaunch hokuyo_ust_10lx lidar.launch ip_address:=$HOKUYO_UST_10LX &
sleep 5 # wait until lidar launch
roslaunch hokuyo_ust_10lx online_localization.launch load_state_filename:=${INPUT_PB}

