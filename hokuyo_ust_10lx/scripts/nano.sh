source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

roscore &
sleep 5 # wait until roscore launch

if "${USE_IMU}"; then
  roslaunch hokuyo_ust_10lx nano_robot_imu.launch ip_address:=$HOKUYO_UST_10LX
else
  roslaunch hokuyo_ust_10lx nano_robot.launch ip_address:=$HOKUYO_UST_10LX
fi
