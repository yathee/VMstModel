#!/bin/sh 
##########
#
#########
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
log_file=/home/yathee/scripts/log/cpu_load_log

echo $current_time >> $log_file   
numcpu=$(shuf -i 1-7 -n 1)

echo "CPU burn called with number of cores $numcpu" >> $log_file 

./cpuburn -n $numcpu   

echo "CPUburn finished" >> $log_file

