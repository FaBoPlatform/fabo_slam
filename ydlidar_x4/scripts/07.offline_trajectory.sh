# usage:
# ./07.offline_trajectory.sh input.bag input.bag.pbstream

case $1 in
    /*\.bag)
        INPUT_BAG=$1
        ;;
    *.bag)
        INPUT_BAG=$PWD/$1
esac
echo ${INPUT_BAG}

case $2 in
    /*\.pbstream)
        INPUT_PB=$2
        ;;
    *.pbstream)
        INPUT_PB=$PWD/$2
esac
echo ${INPUT_PB}


source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

roscore &
sleep 5 # wait until roscore launch
roslaunch ydlidar_x4 offline_assets_writer.launch \
    bag_filenames:=${INPUT_BAG} \
    pose_graph_filename:=${INPUT_PB}

