# Install

1. Install ROS<br>
2. Install Cartographer-ROS (use master branch. not v1.0.0)<br>
3. Install FaBo SLAM<br>
4. Install LIDAR Drivers<br>
5. Install Turtlebot3 (Optional)<br>
6. Install SparkFun 9DoF Razor IMU M0 (SEN-14001) (Optional)<br>

## 1. Install ROS Melodic
[http://wiki.ros.org/melodic/Installation/Ubuntu](http://wiki.ros.org/melodic/Installation/Ubuntu)
```
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

sudo apt-get update
sudo apt install -y ros-melodic-desktop-full ros-melodic-map-server
```
```
sudo rosdep init
rosdep update
echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc
```
```
sudo apt-get install -y python-rosinstall python-rosinstall-generator python-wstool build-essential
```
### Install Packages
```
sudo apt-get install -y cmake python-catkin-pkg python-empy python-nose python-setuptools libgtest-dev python-rosinstall python-rosinstall-generator python-wstool build-essential git
```
### Make catkin workspace
```
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws
catkin_make
```

## 2. Install Cartographer-ros
[https://google-cartographer-ros.readthedocs.io/en/latest/compilation.html#building-installation](https://google-cartographer-ros.readthedocs.io/en/latest/compilation.html#building-installation)<br>
The official documentation is how to build cartographer-ros v1.0.0.<br>
But, I need to build with `master` branch for pure localization.<br>

### Install Packages
```
sudo apt-get install -y python-wstool python-rosdep ninja-build
```

### Download rosinstall list
```
cd ~/catkin_ws
wstool init src
wstool merge -t src https://raw.githubusercontent.com/googlecartographer/cartographer_ros/master/cartographer_ros.rosinstall
```

### Edit install parameter
Edit it from `version: 1.0.0` to `version: master`<br>
```
vi /home/ubuntu/catkin_ws/src/.rosinstall
```
diff: <br>
```
--- /home/ubuntu/catkin_ws/src/.rosinstall.org	2019-04-22 06:01:15.018463519 +0000
+++ /home/ubuntu/catkin_ws/src/.rosinstall	2019-04-22 06:01:29.370431975 +0000
@@ -2,11 +2,11 @@
 - git:
     local-name: cartographer
     uri: https://github.com/googlecartographer/cartographer.git
-    version: 1.0.0
+    version: master
 - git:
     local-name: cartographer_ros
     uri: https://github.com/googlecartographer/cartographer_ros.git
-    version: 1.0.0
+    version: master
 - git:
     local-name: ceres-solver
     uri: https://ceres-solver.googlesource.com/ceres-solver.git
```
You can use `hash` instead of `branch`.<br>
`version: 1.0.0`<br>
`version: master`<br>
`version: 51df4afcba2dbb83e57ff34e04e8f01015f59625`<br>

### Download source code
```
cd ~/catkin_ws
wstool update -t src
```

### Install Protobuf
```
cd ~/catkin_ws
src/cartographer/scripts/install_proto3.sh
rosdep update
rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y
```
### Build cartographer
```
cd ~/catkin_ws
catkin_make_isolated --install --use-ninja
```

### About commit version
Check the commit version of the cartographer used this time.
```
cd ~/catkin_ws/src/cartographer
git rev-parse HEAD
51df4afcba2dbb83e57ff34e04e8f01015f59625
```
```
cd ~/catkin_ws/src/cartographer_ros
git rev-parse HEAD
92a8b81a8489dd71a73c6d838c560712311b1da5
```
```
cd ~/catkin_ws/src/ceres-solver
git rev-parse HEAD
19333b0f55c8462381038e70d42af43b52941128
```


## 3. Install FaBo SLAM
### Download
```
cd ~/catkin_ws/src
git clone https://github.com/FaBoPlatform/fabo_slam
cd ..
```

### Install
```
cd ~/catkin_ws
catkin_make_isolated --install --use-ninja
```


## 4. Install LIDAR Drivers
### YDLIDAR X4
[Install YDLIDAR ROS Driver](ydlidar.md)
### Hokuyo UST-10LX
[Install Hokuyo ROS Driver](hokuyo.md)


## 5. Install Turtlebot3
Optional.

* Not required. Only when using Turtlebot3's navigation.

```
cd ~/catkin_ws/src/
git clone https://github.com/ROBOTIS-GIT/turtlebot3_msgs.git
git clone https://github.com/ROBOTIS-GIT/turtlebot3.git
cd ~/catkin_ws && catkin_make_isolated --install --use-ninja
```

### Install on PC. (RViz execution PC.)
If you run RViz on TX2, you will also need these packages on TX2.
```
sudo apt-get install ros-melodic-map-server ros-melodic-amcl ros-melodic-move-base ros-melodic-dwa-local-planner
```

```
cd ~/catkin_ws/src/fabo_slam
cp hokuyo_ust_10lx/extras/turtlebot3_navigation_pbstream.launch ~/catkin_ws/install_isolated/share/turtlebot3_navigation/launch/
cp hokuyo_ust_10lx/extras/turtlebot3_navigation_rosmap.launch ~/catkin_ws/install_isolated/share/turtlebot3_navigation/launch/
```

## 6. Install SparkFun 9DoF Razor IMU M0 (SEN-14001)
Optional.

Without IMU is better for 2d slam.<br>
At localization time, using IMU is a little better.<br>

* Firmware update (on Linux PC)
* ROS Driver Install (on TX2)

### Firmware update
on Linux PC

SEN-14001 cannot use with ROS. It needs firmware update.<br>
* Download Arduino IDE
* Download Firmware
* Download Arduino Libraries
* Write Firmware

#### Download Arduino IDE
Install Arduino IDE on Linux PC.<br>
[https://www.arduino.cc/en/Main/Software](https://www.arduino.cc/en/Main/Software)

```
tar fx arduino-1.8.9-linux64.tar.xz
cd arduino-1.8.9
./install.sh
```

#### Download Firmware
```
cd ~/github
git clone https://github.com/KristofRobot/razor_imu_9dof
```

#### Download Arduino Libraries
```
mkdir ~/Arduino/libraries
cd Arduino/libraries
git clone https://github.com/lebarsfa/SparkFun_MPU-9250-DMP_Arduino_Library
wget https://cdn.sparkfun.com/assets/learn_tutorials/5/6/7/FlashStorage.zip
unzip FlashStorage.zip
rm FlashStorage.zip
```

#### Write Firmware
SparkFun official document:<br>
[https://learn.sparkfun.com/tutorials/9dof-razor-imu-m0-hookup-guide](https://learn.sparkfun.com/tutorials/9dof-razor-imu-m0-hookup-guide)

##### Launch Arduino IDE
Connect SEN-14001 and PC with micro USB cable.
```
arduino
```

##### Settings
(Arduino IDE)File->Preferences->Additional Boards Manager URLs:
```
https://raw.githubusercontent.com/sparkfun/Arduino_Boards/master/IDE_Board_Manager/package_sparkfun_index.json
```
(Arduino IDE)Tools->Boads Manager:
```
Arduino AVR Boards Built-in by Arduino version 1.6.23
Arduino SAMD Boards (32-bits ARM Coretex-M0+) by Arduino version 1.8.2
SparkFun SAMD Boards (dependency: Arduino SAMD Boards 1.8.1) by SparkFun Electronics version 1.6.2
```
(Arduino IDE)Tools->Board:
```
SparkFun 9DoF Razor IMU M0
```
(Arduino IDE)Tools->Port:
```
/dev/ttyACM0(SparkFun 9DoF Razor IMU M0)
```
Tools->Programmer:
```
Atmel SAM-ICE
```
##### Open Firmware
Edit Firmware

```
vi ~/github/razor_imu_9dof/src/Razor_AHRS/Razor_AHRS.ino
```
Uncomment:
```
// HARDWARE OPTIONS
/*****************************************************************/
// Select your hardware here by uncommenting one line!
//#define HW__VERSION_CODE 10125 // SparkFun "9DOF Razor IMU" version "SEN-10125" (HMC5843 magnetometer)
//#define HW__VERSION_CODE 10736 // SparkFun "9DOF Razor IMU" version "SEN-10736" (HMC5883L magnetometer)
#define HW__VERSION_CODE 14001 // SparkFun "9DoF Razor IMU M0" version "SEN-14001"
//#define HW__VERSION_CODE 10183 // SparkFun "9DOF Sensor Stick" version "SEN-10183" (HMC5843 magnetometer)
//#define HW__VERSION_CODE 10321 // SparkFun "9DOF Sensor Stick" version "SEN-10321" (HMC5843 magnetometer)
//#define HW__VERSION_CODE 10724 // SparkFun "9DOF Sensor Stick" version "SEN-10724" (HMC5883L magnetometer)
```

(Arduino IDE)File->Open:
```
~/github/razor_imu_9dof/src/Razor_AHRS/Razor_AHRS.ino
```


##### Quit Arduino IDE and bug fix
If you try to write the firmware, an error occurs.
```
java.io.IOException: Cannot run program "{runtime.tools.openocd-0.9.0-arduino6-static.path}/bin/openocd": error=2, No such file or directory
```
Avoid this bug first.

```
vi ~/.arduino15/packages/SparkFun/hardware/samd/1.6.2/platform.txt
```
before:
```
tools.openocd.path={runtime.tools.openocd-0.9.0-arduino6-static.path}
```
after:
```
tools.openocd.path={runtime.tools.openocd-0.10.0-arduino7.path}
```

Hint:
```
less ~/.arduino15/packages/arduino/hardware/samd/1.8.2/platform.txt
```

##### Write Firmware
Launch Arduino IDE
```
arduino
```
(Arduino IDE)Sketch->Upload

If you get error, please retry Sketch->Upload.


### ROS Driver Install
on TX2

```
cd ~/catkin_ws/src
git clone https://github.com/KristofRobot/razor_imu_9dof
cp ~/catkin_ws/src/razor_imu_9dof/cfg/imu.cfg ~/catkin_ws/src/razor_imu_9dof/cfg/razor_imu_9dof.cfg
cp ~/catkin_ws/src/razor_imu_9dof/config/razor.yaml ~/catkin_ws/src/razor_imu_9dof/config/my_razor.yaml
vi ~/catkin_ws/src/razor_imu_9dof/config/my_razor.yaml
```
before:
```
port: /dev/ttyUSB0
```
after:
```
#port: /dev/ttyUSB0
port: /dev/ttyACM0
```
```
cd ~/catkin_ws
catkin_make_isolated --install --use-ninja
cd ~/catkin_ws/src/fabo_slam/hokuyo_ust_10lx/extras/
cp imu.launch ~/catkin_ws/install_isolated/share/razor_imu_9dof/launch/
```

Make executable by user permission.
```
sudo su
echo 'KERNEL=="ttyACM*", ATTRS{idVendor}=="1b4f", ATTRS{idProduct}=="9d0f", MODE:="0666", GROUP:="dialout",  SYMLINK+="sen-14001"' >/etc/udev/rules.d/sen-14001.rules

service udev reload
sleep 2
service udev restart
reboot
```

IMU check:
Terminal 1:
```
roslaunch razor_imu_9dof imu.launch
```
wait 20 sec.<br>
Terminal 2:
```
rostopic echo /imu
```

