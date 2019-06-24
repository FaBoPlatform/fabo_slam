source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

roscore &
sleep 5 # wait until roscore launch

roslaunch ydlidar_x4 nano_robot.launch

