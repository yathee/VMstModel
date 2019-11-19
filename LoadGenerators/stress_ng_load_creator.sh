#!/bin/sh 
########################################################################
# Stree-ng Load creator 
########################################################################
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
log_file=/home/yathee/scripts/log/stress_ng_load_$current_time

echo $current_time >> $log_file  

### Choose number of CPU to be loaded  
numcpu=$(shuf -i 1-5 -n 1)

### choose amount of memory , in multiples of 512M 
amtmem=$(shuf -i 1-20 -n 1)

echo "Stress-NG called with  $numcpu CPUs and $amtmem  fold of 512M " >> $log_file 

  
stress-ng --cpu $numcpu --vm $amtmem --vm-bytes 512M  --timeout=300s --metrics-brief >> $log_file

echo "Stress Test finished" >> $log_file
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
echo $current_time >> $log_file  
