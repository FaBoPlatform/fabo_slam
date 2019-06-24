# usage:
# ./10.offline_save_rosmap.sh input.bag

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
roslaunch hokuyo_ust_10lx offline_assets_writer_ros_map.launch bag_filenames:=${INPUT_BAG} pose_graph_filename:=${INPUT_BAG}.pbstream

