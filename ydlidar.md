# Install YDLIDAR ROS Driver
Use the FaBoPlatform repository with YDRIDAR X4 added to the original repository.
## Download
```
cd ~/catkin_ws/src
git clone https://github.com/FaBoPlatform/ydlidar
cd ..
```

## CUSTOMIZED INFO
You can skip here.<br>
This is the information of the change point from the original repository.

### ydlidar_node.cpp
According to the [https://github.com/EAIBOT/ydlidar/issues/14](https://github.com/EAIBOT/ydlidar/issues/14), scan_msg.scan_time and scan_msg.time_increment have different time format.<br>
Therefore, fix the code.<br>
```
vi ~/catkin_ws/src/ydlidar/src/ydlidar_node.cpp

--- /home/ubuntu/catkin_ws/src/ydlidar/src/ydlidar_node.cpp.org	2019-04-17 11:52:17.775006029 +0900
+++ /home/ubuntu/catkin_ws/src/ydlidar/src/ydlidar_node.cpp	2019-04-17 11:52:32.206993273 +0900
@@ -131,8 +131,8 @@
             scan_msg.angle_min = scan.config.min_angle;
             scan_msg.angle_max = scan.config.max_angle;
             scan_msg.angle_increment = scan.config.ang_increment;
-            scan_msg.scan_time = scan.config.scan_time;
-            scan_msg.time_increment = scan.config.time_increment;
+            scan_msg.scan_time = scan.config.scan_time/1000000000.0;
+            scan_msg.time_increment = scan.config.time_increment/1000000000.0;
             scan_msg.range_min = scan.config.min_range;
             scan_msg.range_max = scan.config.max_range;
```

### ydlidar_x4.launch
YDLIDAR X4 datasheet：[http://www.ydlidar.com/download](http://www.ydlidar.com/download)<br>

| Item | Min. | Typical Value | Max. | Unit | Remark |
|--:|--:|--:|--:|--:|--:|
| Range Frequency | - | 5000 | - | Hz | 5000 range sampling per second |
| Scanning Frequency | 6 | - | 12 | Hz | Configurable by software |
| Range | 0.12 | - | >10 | m | Indoor |
| Scanning Angle | - | 0-360 | - | Deg | - |
| Range resolution | - | <0.5 | - | mm | Range<2m |
| Range resolution | - | <1% of actual distance | - | mm | Range>2m |
| Angle resolution | 0.48 | 0.50 | 0.52 | Deg | Scanning Frequency 7Hz|
| Working life | - | 1500 | - | h | Continuous working life |
| Supply voltage | 4.8 | 5 | 5.2 | V | Excessive voltage can damage the device. Low voltage can affect performance. |
| Voltage ripple | 0 | 50 | 100 | mV | High ripple affects performance and can even cause Lidar to fail to range |
| Starting current | 400 | 450 | 480 | mA | High current startup |
| Working current | 330 | 350 | 380 | mA | System work, motor rotates |
| Baud rate | - | 128000 | - | bps | 8 data bits, 1 stop bit, no parity |
| Signal high | 1.8 | 3.3 | 3.5 | V | When the signal voltage is >1.8V, it is high level |
| Signal low | 0 | 0 | 0.5 | V | When the signal voltage is <0.5V, it is low level |
| PWM frequency | - | 10 | - | KHz | PWM is a square wave signal |
| Duty cycle range | 50% | 85% | 100% | The shorter the duty cycle, the faster the speed |
| Laser wavelength | 775 | 785 | 795 | nm | Infrared band |
| Laser power | - | 3 | 5 | mW |
| Working temperature | 0 | 20 | 40 | ℃ | Long-term work in high temperature environment will reduce the working life |
| Lighing environment | 0 | 550 | 2200 | Lux | For reference only |
| N.W. | - | 180 | - | g | - |

| parameter | value | consideration |
|--:|--:|--:|
| baudrate | 12800 | bps. Datasheet: Baud rate. |
| range_min | 0.12 | m. Datasheet: Range. |
| range_max | 10.0 | m. Datasheet: Range. It is >10, but I don't know the correct value. Therefore, set 10.0. |
| samp_rate | 4 | K. Datasheet: Range Frequency. It is 5000, but there is no 5k parameter in the driver. Driver has 4K,8K,9K,10K parameters. |
| frequency | 7 | Hz. Datasheet: Scanning Frequency. |

About `x` `y` `z` `yaw` `pitch` `roll` `frame_id` `child_frame_id` `period_in_ms` in the node type `static_transform_publisher`:<br>
`x` `y` `z` `yaw` `pitch` `roll` are installation position of YDLIDAR X4. Therefore, set to all `0`.<br>
`period_in_ms` is in milliseconds, specifies how often to send a transform. 100ms (10hz) is a good value.<br>

See also:<br>
YDLIDAR X4 datasheet：[http://www.ydlidar.com/download](http://www.ydlidar.com/download)<br>
YDLIDAR X4 Driver doc: ~/catkin_ws/src/ydlidar/sdk/doc/html/classydlidar_1_1_y_dlidar_driver.html<br>
static_transform_publisher：[http://wiki.ros.org/tf#static_transform_publisher](http://wiki.ros.org/tf#static_transform_publisher)<br>
[https://github.com/EAIBOT/ydlidar](https://github.com/EAIBOT/ydlidar)<br>

```
cp ~/catkin_ws/src/ydlidar/launch/lidar.launch ~/catkin_ws/src/ydlidar/launch/ydlidar_x4.launch
vi ~/catkin_ws/src/ydlidar/launch/ydlidar_x4.launch

--- /home/ubuntu/catkin_ws/src/ydlidar/launch/lidar.launch	2019-04-23 12:03:31.620454277 +0900
+++ /home/ubuntu/catkin_ws/src/ydlidar/launch/ydlidar_x4.launch	2019-04-26 14:39:02.769743117 +0900
@@ -1,20 +1,20 @@
 <launch>
   <node name="ydlidar_node"  pkg="ydlidar"  type="ydlidar_node" output="screen" respawn="false" >
     <param name="port"         type="string" value="/dev/ydlidar"/>  
-    <param name="baudrate"     type="int"    value="115200"/>
-    <param name="frame_id"     type="string" value="laser_frame"/>
+    <param name="baudrate"     type="int"    value="128000"/>
+    <param name="frame_id"     type="string" value="base_laser_link"/>
     <param name="low_exposure"  type="bool"   value="false"/>
     <param name="resolution_fixed"    type="bool"   value="true"/>
     <param name="auto_reconnect"    type="bool"   value="true"/>
     <param name="reversion"    type="bool"   value="false"/>
     <param name="angle_min"    type="double" value="-180" />
     <param name="angle_max"    type="double" value="180" />
-    <param name="range_min"    type="double" value="0.1" />
-    <param name="range_max"    type="double" value="16.0" />
+    <param name="range_min"    type="double" value="0.12" />
+    <param name="range_max"    type="double" value="10.0" />
     <param name="ignore_array" type="string" value="" />
-    <param name="samp_rate"    type="int"    value="9"/>
+    <param name="samp_rate"    type="int"    value="4"/>
     <param name="frequency"    type="double" value="7"/>
   </node>
-  <node pkg="tf" type="static_transform_publisher" name="base_link_to_laser4"
-    args="0.2245 0.0 0.2 0.0 0.0  0.0 /base_footprint /laser_frame 40" />
+  <node pkg="tf" type="static_transform_publisher" name="odom_to_base_footprint"
+    args="0.0 0.0 0.0  0.0 0.0 0.0 /odom /base_footprint 100" />
+  <node pkg="tf" type="static_transform_publisher" name="base_footprint_to_base_link"
+    args="0.0 0.0 0.0  0.0 0.0 0.0 /base_footprint /base_link 100" />
+  <node pkg="tf" type="static_transform_publisher" name="base_link_to_base_laser_link"
+    args="0.0 0.0 0.0  0.0 0.0 0.0 /base_link /base_laser_link 100" />

 </launch>
```

## Build
```
cd ~/catkin_ws
catkin_make_isolated --install --use-ninja
```

## Setup Device
```
sudo ~/catkin_ws/src/ydlidar/startup/initenv.sh
sudo reboot
```
