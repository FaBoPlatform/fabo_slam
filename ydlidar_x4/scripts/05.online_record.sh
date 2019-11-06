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

if "${USE_IMU}"; then
  roslaunch razor_imu_9dof imu.launch &
  sleep 20 # wait until imu launch
  IMU="_imu"
else
  sleep 5 # wait until lidar launch
  IMU=""
fi

rosrun rosbag record -a -O $OUTPUT_BAG
