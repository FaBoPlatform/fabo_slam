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
roslaunch ydlidar ydlidar_x4.launch &

if "${USE_IMU}"; then
  roslaunch razor_imu_9dof imu.launch&
  sleep 20 # wait until imu launch
  IMU="_imu"
else
  sleep 5 # wait until lidar launch
  IMU=""
fi
roslaunch ydlidar_x4 online_localization.launch load_state_filename:=${INPUT_PB} use_imu:=${IMU}

