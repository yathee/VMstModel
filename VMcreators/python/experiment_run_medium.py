#'''
#Created on Apr 29, 2018
#
#@author: Yathee
#'''

if __name__ == '__main__':
    pass

import os,sys
import time,random,csv
import os_client_config
import logging
from datetime import datetime
from credentials import get_nova_credentials_v2

def verify_env (nclient):
    serverlist = nclient.servers.list()
    if len(serverlist) == 0 :
        logger.info("No other VMs running in the VMST project space ")
    else :
        logger.info("VMST project space have active VMs. All those VMs will be deleted")
        delete_servers(serverlist)
        logger.info("Exiting the python run")
        sys.exit(0)


def get_flavor_id ( nclient, strFlavorName):
    flvList =  nclient.flavors.list()
    for flv in flvList :
        flvDict = vars(flv)
        if strFlavorName == flvDict['name']:
            return flvDict['id']

def get_images_constant(imname):
    
# +--------------------------------------+----------+--------+
# | ID                                   | Name     | Status |
# +--------------------------------------+----------+--------+
# | 421ee602-59c5-4703-8065-da84cefc9862 | CentOs   | active |
# | 355773cc-14df-4460-b219-f1d5b970a2be | Debian   | active |
# | 6333699f-7db1-4899-8bab-41b1207a653c | Ubuntu   | active |
# | 783abff5-2535-40f2-a57a-5542f5e1e5fe | cirros   | active |
# +--------------------------------------+----------+--------+

    if imname == 'cirros':
        return '783abff5-2535-40f2-a57a-5542f5e1e5fe'
    elif imname == 'CentOs' :
        return '421ee602-59c5-4703-8065-da84cefc9862'
    elif imname == 'Debian' :
        return '355773cc-14df-4460-b219-f1d5b970a2be'
    elif imname == 'Ubuntu' :
        return '6333699f-7db1-4899-8bab-41b1207a653c'

def write_to_file(vmlist):
    keys = vmlist[0].keys()
    logger.info("Writing in to file")
    with open('/home/yathee/scripts/log/consolidated_log_'+timestr+'.csv', 'a') as csv_file:
        dict_writer = csv.DictWriter(csv_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(vmlist)
    logger.info("written in to file")
    csv_file.close()

def delete_servers(server_list):
    # Delete all the created servers
    for vms in server_list :
        try:
            vms.delete()
            logger.info('Deleted '+ str(vms))
        except Exception, e:
            logger.error('Failed to create connection object', exc_info=True)

# Create Logger for this program

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

timestr = time.strftime("%Y%m%d-%H%M%S")

# create a file handler
handler = logging.FileHandler('/home/yathee/scripts/log/run_'+timestr+'.log')
handler.setLevel(logging.INFO)

# create a logging format
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)

# add the handlers to the logger
logger.addHandler(handler)


logger.info("Create the connection object")

try:
      creds = get_nova_credentials_v2()
#      logger.info (creds)
      nclient=os_client_config.make_client(
      'compute',
      auth_url=creds['auth_url'],
      username=creds['username'],
      password=creds['password'],
      project_name=creds['project_id'],
      region_name='RegionOne'
      )

except Exception, e:
    logger.error('Failed to create connection object', exc_info=True)

# Verify environment
#
verify_env(nclient)

vmreqNum = random.randint(1,5)
vmlist = []
flavorid = get_flavor_id (nclient,'m1.medium')
imageid = get_images_constant('CentOs')
server_list = []

reqCurrTime = str(datetime.now())
logger.info("Create " + str(vmreqNum) + "servers with medium flavor at : " + reqCurrTime)

try:
    nclient.servers.create("test",flavor=flavorid,image=imageid,availability_zone='VMstZone1',min_count=vmreqNum)
except Exception, e:
        logger.error('Failed to create servers ', exc_info=True)
logger.info("waiting for 480 seconds " )
time.sleep(480)
logger.info("Done waiting, start data collection  " )

server_list = nclient.servers.list()

logger.info(server_list)

for vms in server_list :
    vmdet = vars(vms)
    vmdetails = {}
    vmname= vmdet['name']
    vmhost= vmdet['OS-EXT-SRV-ATTR:host']
    vmstatus= vmdet['status']
    if "ACTIVE" in vmstatus :
        try:
            textobj = vms.get_console_output()
            lines = textobj.split('\n')
            for l in lines :
                if l.find('Cloud-init v. 0.7.9 finished') != -1 :
                    dataline=l.split(" ")
                    posVMst = len(dataline) - 2
                    vmst = dataline[posVMst]
                    logger.info("processed : " + vmname)
        except Exception, e:
            logger.error('Failed to retrieve log file '+vmname, exc_info=True)

    elif "ERROR" in vmstatus :
        logger.error('VM in error state :  '+vmname, exc_info=True)
        logger.info("Deleteing servers with medium flavor and exiting")
        delete_servers(server_list)
        time.sleep(60)
        sys.exit(0)
    else :
        logger.error('VM in improper state :  '+vmname, exc_info=True)
        logger.info("Deleteing servers with medium flavor and exiting")
        delete_servers(server_list)
        time.sleep(60)
        sys.exit(0)

    vmdetails.update({'name' : vmname ,'host' : vmhost, 'VMST' : vmst, 'reqTime' : reqCurrTime,  'flavor' : 'medium', 'noVMreq' : vmreqNum})
    vmlist.append(vmdetails)

logger.info("Deleteing " + str(vmreqNum) + " servers with medium flavor")
# Delete all the created servers
delete_servers(server_list)
logger.info("Collected data for medium VMs")
logger.info(vmlist)
timestr = time.strftime("%Y%m%d-%H%M%S")
write_to_file(vmlist)


logger.info("Run Completed")
