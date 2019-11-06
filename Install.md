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
[Install SparkFun 9DoF Razor IMU M0 (SEN-14001)](sen-14001.md)

