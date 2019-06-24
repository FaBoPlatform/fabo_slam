source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

roscore &
sleep 5 # wait until roscore launch

roslaunch hokuyo_ust_10lx nano_robot.launch ip_address:=10.0.0.10

