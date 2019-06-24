# usage:
# ./03.online_save_pbstream.sh output.pbstream

# https://github.com/googlecartographer/cartographer_ros/blob/master/docs/source/assets_writer.rst

case $1 in
    /*\.pbstream)
        OUTPUT_PB=$1
        ;;
    *.pbstream)
        OUTPUT_PB=$PWD/$1
esac
echo ${OUTPUT_PB}

source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

rosservice call /finish_trajectory 0
rosservice call /write_state "{filename: '${OUTPUT_PB}', include_unfinished_submaps: true}"

