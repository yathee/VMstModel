#!/bin/sh 
##########
#
#########
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
log_file=./log/mem_load_log

echo $current_time >> $log_file   
amtmem=$(shuf -i 1-14336 -n 1)

echo "Fill memory called with amount of Memory $amtmem MB" >> $log_file 

python fillmem.py $amtmem

echo "fillmem finished" >> $log_file
echo "   " >> $log_file
