#!/bin/sh
########################################################################
# Iperf server creator for Network Load scripts
########################################################################
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
log_file=/home/yathee/scripts/log/network_iperf_$current_time

echo $current_time >> $log_file


echo "Iperf server started " >> $log_file


iperf -s -p 5201 -t 540s >> $log_file

echo "NetworkServer ended " >> $log_file
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
echo $current_time >> $log_file

