#!/bin/bash
#
# Author: Tarik Alkanan
# Date: 10.04.2024
#
#    NOTE, THIS CODE IS NOT COMPLETED YET.
#
#This script secure openSSH
# 1- Enable and start openSSH
# 2- Mitigation CVE-2020-15778
# 3- Mitigation CVE-2023-48795/ HMAC (SHA1)
###########################################

## /etc/ssh/sshd_config.d/00-secure.conf
# Set  RequiredRSASize 2048
# Set  PermitRootLogin no
# Set  PermitEmptyPasswords no

########################################

##/etc/systemd/logind.conf

## Set SSH Client Alive Interval 900 
# /etc/systemd/logind.conf


cve_file_path="/etc/crypto-policies/policies/modules/CVE-2023-48795.pmod"
ssh_file_path="/etc/ssh/sshd_config.d/00-secure.conf"
logind_path="/etc/systemd/logind.conf"

logind_path_backup="/root/secure_backup/logind.conf.bkp"


CVE_2023_48795="#Disable CHACHA20-POLY1305
cipher@SSH = -CHACHA20-POLY1305
#Disable MACs SHA1
mac@ssh = -*-SHA1
#Disable all etm MACs
ssh_etm = 0"

ssh_config="RequiredRSASize 2048
PermitRootLogin no
PermitEmptyPasswords no"

backup(){

# Check if the config file exists
if [ -f "$logind_path_backup" ]; then
    echo "$logind_path_backup backup for $logind_path exist"
else
    echo "$logind_path_backup does not exist, the backup will be created for $logind_path"
    cp $logind_path $logind_path_backup
fi

}

check_command_success(){

command_run="$1"
true_message="$2"
fail_message="$3"

$command_run

if [ $? -eq 0 ]	
then
	echo "--->> $true_message <<---"
else
	echo "*** $fail_message ***"
	exit 0
fi
}
main(){

echo -e "
 ____                              ___                   ____ ____  _   _ 
/ ___|  ___  ___ _   _ _ __ ___   / _ \ _ __   ___ _ __ / ___/ ___|| | | |
\___ \ / _ \/ __| | | | '__/ _ \ | | | | '_ \ / _ \ '_ \\___ \___ \| |_| |
 ___) |  __/ (__| |_| | | |  __/ | |_| | |_) |  __/ | | |___) |__) |  _  |
|____/ \___|\___|\__,_|_|  \___|  \___/| .__/ \___|_| |_|____/____/|_| |_|
                                       |_|                                

"

echo -e "Install openssh"

check_command_success "dnf install -y openssh" "----> The openssh was installed successfully <----" ">>>> Failed to install openssh <<<<"

# Enable openSSH
echo -e "Enable openSSH"
check_command_success "systemctl enable sshd" "----> The sshd was enabled successfully <----" ">>>> Failed to enable sshd <<<<"
echo
# Start openSSH
echo -e "Start openSSH"
check_command_success "systemctl start sshd" "----> The sshd started successfully <----" ">>>> Failed to start sshd, Check systemctl status sshd <<<<"
echo
# Status openSSH
systemctl status sshd
echo 
echo -e "Mitigation CVE-2020-15778"
# Mitigation CVE-2020-15778
check_command_success "chmod 0000 /usr/bin/scp" "----> The scp was disabled successfully <----" ">>>> Failed to disable scp <<<<"

echo

echo -e "Mitigation CVE-2023-48795/ HMAC (SHA1)"
# Mitigation CVE-2023-48795/ HMAC (SHA1)


if [ -e "$cve_file_path" ]; then
  echo "File $cve_file_path exists."
else
  echo "File $cve_file_path does not exist. Creating the file and entering text."

  # Create the file and enter text
  echo -e "$CVE_2023_48795" > "$cve_file_path"

  echo -e "File $file_path created with the text\n \"$CVE_2023_48795\"."
fi

if update-crypto-policies --show | grep -q "CVE-2023-48795"; 
  
  then

    echo "CVE-2023-48795 is present in the crypto-policy."

  else

    echo "CVE-2023-48795 is not present in the output."
    check_command_success "update-crypto-policies --set $(update-crypto-policies --show):CVE-2023-48795" "----> The CVE_2023_48795 sub-policy was applied successfully <----" ">>>> Failed to apply CVE_2023_48795 sub-policy <<<<"
    echo

    echo -e "The applied crypto-policy: " 
    update-crypto-policies --show

fi


#################################################
echo -e "4th phase"
# set  RequiredRSASize 2048
# set  PermitRootLogin no
# set  PermitEmptyPasswords no

if [ -e "$ssh_file_path" ]; then
  echo "File $ssh_file_path exists."
else
  echo "File $ssh_file_path does not exist. Creating the file and entering text."

  # Create the file and enter text
  echo -e "$ssh_config" >> "$ssh_file_path"

  echo "File $ssh_file_path created with the text \"$ssh_config\"."
fi

###################################################
#Set SSH Client Alive Interval 
echo -e "5th phase"


if grep -q '^StopIdleSessionSec' $logind_path; then
  echo "The config exists"
  existing_config=$(grep -i '^StopIdleSessionSec' $logind_path) 
  
  echo $existing_config
  read -p "Do you want to change the interval? (y/n): " answer

if [ "$answer" == "y" ]; then
  read -p "Enter the interval " interval
  sed -i "s/^${existing_config}/StopIdleSessionSec=$interval/" "$logind_path"
  
else
  echo "The interval will not change."
fi
  
else
  echo "The config does not exist"
  read -p "Do you want to set the interval? (y/n): " answer

if [ "$answer" == "y" ]; then

  backup

  read -p "Enter the interval " interval
  echo "StopIdleSessionSec=$interval" >> $logind_path
  echo -e "The interval( $interval ) was set in $logind_path "
else
  echo "The interval will not change."
fi
fi
}

main




