########################################
# Sample turtlebot3 navigation
########################################
cp turtlebot3_navigation_pbstream.launch ~/catkin_ws/install_isolated/share/turtlebot3_navigation/launch/
cp turtlebot3_navigation_rosmap.launch ~/catkin_ws/install_isolated/share/turtlebot3_navigation/launch/

########################################
# SparkFun 9DoF Razor IMU M0 (SEN-14001)
########################################
cp imu.launch ~/catkin_ws/install_isolated/share/razor_imu_9dof/launch/
sudo su
echo 'KERNEL=="ttyACM*", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9d0f", MODE:="0666", GROUP:="dialout",  SYMLINK+="sen-14001"' >/etc/udev/rules.d/sen-14001.rules

service udev reload
sleep 2
service udev restart
reboot
