source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

# ~/catkin_ws/src/turtlebot3/turtlebot3_navigation/param/costmap_common_params_burger.yaml
export TURTLEBOT3_MODEL=burger # burger, waffle, waffle_pi


case $1 in
    /*\.pbstream)
        INPUT_PBSTREAM=$1
        ;;
    *.pbstream)
        INPUT_PBSTREAM=$PWD/$1
        ;;
    /*\.yaml)
        INPUT_YAML=$1
        ;;
    *.yaml)
        INPUT_YAML=$PWD/$1
esac

if "${USE_IMU}"; then
  IMU="_imu"
else
  IMU=""
fi


if [ ! -z $INPUT_YAML ]; then
  # map_server version. need imu.
  roslaunch turtlebot3_navigation turtlebot3_navigation_rosmap.launch map_file:=$INPUT_YAML
elif [ ! -z $INPUT_PBSTREAM ]; then
  # cartgrapher version
  roslaunch turtlebot3_navigation turtlebot3_navigation_pbstream.launch load_state_filename:=$INPUT_PBSTREAM use_imu:=${IMU}
fi
