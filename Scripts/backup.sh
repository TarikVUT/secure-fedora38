#!/bin/bash
#
# Author: Tarik Alkanan
# 
# This script config rear to backup the system

nfs_server_ip=""
nfs_server_path=""
rear_path="/etc/rear/local.conf"
backup_rear_path="/root/secure_backup/local.conf.bkp"


backup(){

# Check if the config file exists
if [ -f "$backup_rear_path" ]; then
    echo "$backup_rear_path backup for $rear_path exist"
else
    echo "$backup_rear_path does not exist, the backup will be created for $rear_path"
    cp $rear_path $backup_rear_path
fi

}


check_command_success(){

command_run="$1"
true_message="$2"
fail_message="$3"

$command_run

if [ $? -eq 0 ]	
then
	echo -e "--->> $true_message <<---"
else
	echo -e "*** $fail_message ***"
	exit 0
fi
}
main(){

echo -e "
 ____  _____    _    ____  
|  _ \| ____|  / \  |  _ \ 
| |_) |  _|   / _ \ | |_) |
|  _ <| |___ / ___ \|  _ < 
|_| \_\_____/_/   \_\_| \_\
         
"


echo -e "Install rear"

check_command_success "dnf install -y rear" "----> The rear package was installed successfully <----" ">>>> Failed to install rear <<<<"


echo
# Status openSSH
echo "Sending logs via RELP..."
read -p "Enter the IP address for the nfs receiving server (in format 255.255.255.255): " nfs_server_ip
read -p "Enter the storage path for nfs server: " nfs_server_path

echo -e "

OUTPUT=ISO
OUTPUT_URL=nfs://$nfs_server_ip$nfs_server_path
BACKUP=NETFS
BACKUP_URL=nfs://$nfs_server_ip$nfs_server_path
NETFS_KEEP_OLD_BACKUP_COPY=y

" > $rear_path

# Create the script for nfs-server
echo

echo -e "The nfs_server_config file was created in /root/. Add the config on the server side:"

echo -e "
    Install the nfs-utils package: # dnf install nfs-utils
	Start and enable nfs
	# systemctl start nfs-server
    # systemctl enable nfs-server
 
	Add nfs service to firewall
	# firewall-cmd --permanent --add-service=nfs
    # firewall-cmd --reload 

	Create and export a directory on the NFS system.
	mkdir $nfs_server_path

	# cat /etc/exports
	$nfs_server_path       *(fsid=0,rw,sync,no_root_squash,no_subtree_check,crossmnt)

    Restart the nfs service: # systemctl restart nfs-server

    " >> /root/nfs_server_config.txt



}
main