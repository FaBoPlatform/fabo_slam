source bash_export
source /home/ubuntu/catkin_ws/install_isolated/setup.bash

DATE=`date '+%Y%m%d%H%M%S'`

rosrun map_server map_saver -f rosmap_2d_${DATE}

