#!/bin/sh 
########################################################################
# Network Load creator 
########################################################################
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
log_file=/home/yathee/scripts/log/network_load_$current_time 

echo $current_time >> $log_file  

### Choose bytes to be transmitted   
numbyt=$(shuf -n 1 -e 64M 128M 256M 512M 640M 768M 1024M )


echo "Iperf called with  $numbyt size " >> $log_file 

  
iperf -c 192.168.1.253 -d  -n $numbyt -t 420s >> $log_file

echo "Network traffic creator finished" >> $log_file
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
echo $current_time >> $log_file  
