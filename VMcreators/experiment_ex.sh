#!/bin/sh
## This script automates the creation of VMs and extracting the VM startup times
##
##
current_time=$(date "+%Y.%m.%d-%H.%M.%S")
log_file=/home/yathee/scripts/log/exe_log.$current_time 
### Source the access for the Openstack a
echo "$(date)" > $log_file 
### Setting the environment variables

export PYTHONPATH=/bin/python
source /home/yathee/openrc/vmst-openrc

echo $(date "+%Y.%m.%d-%H.%M.%S")  >> $log_file
### Call the python script
echo "calling the  python script nano" >> $log_file 
python /home/yathee/scripts/python/experiment_run_nano.py  >> $log_file  


echo $(date "+%Y.%m.%d-%H.%M.%S")  >> $log_file
### Call the python script
echo "calling the  python script tiny " >> $log_file
python /home/yathee/scripts/python/experiment_run_tiny.py  >> $log_file


echo $(date "+%Y.%m.%d-%H.%M.%S")  >> $log_file
### Call the python script
echo "calling the  python script small" >> $log_file
python /home/yathee/scripts/python/experiment_run_small.py  >> $log_file


echo $(date "+%Y.%m.%d-%H.%M.%S")  >> $log_file
### Call the python script
echo "calling the  python script medium" >> $log_file
python /home/yathee/scripts/python/experiment_run_medium.py  >> $log_file

### Call the python script
echo "finished the python script " >> $log_file 
echo "$(date)" >> $log_file 
