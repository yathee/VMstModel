#!/bin/sh 
##########
#
#########
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
log_file=/home/yathee/scripts/log/mem_load_log
echo $current_time >> $log_file 
echo "fillmem.py being stopped " >> $log_file 

pkill -f "fillmem.py"  

echo "fillmem.py has been terminated " >> $log_file
echo " " >> $log_file 


