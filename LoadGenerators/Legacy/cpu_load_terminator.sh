#!/bin/sh 
##########
#
#########
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
log_file=/home/yathee/scripts/log/cpu_load_log
echo $current_time >> $log_file 
echo "CPU burn is being stopped " >> $log_file 

pkill -f "cpuburn"  

echo "CPUburn has been terminated " >> $log_file


