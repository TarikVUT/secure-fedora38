#!/bin/bash
#
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




#cve_file_path="/etc/crypto-policies/policies/modules/CVE-2023-48795.pmod"
#ssh_file_path="/etc/ssh/sshd_config.d/00-secure.conf"
#logind_path="/etc/systemd/logind.conf"
cve_file_path="/home/student/Desktop/tmp/CVE-2023-48795.pmod"
ssh_file_path="/home/student/Desktop/tmp/00-secure.conf"
logind_path="/home/student/Desktop/tmp/logind.conf"


CVE_2023_48795="#Disable CHACHA20-POLY1305
cipher@SSH = -CHACHA20-POLY1305
#Disable MACs SHA1
mac@ssh = -SHA1
#Disable all etm MACs
ssh_etm = 0"

ssh_config="RequiredRSASize 2048
PermitRootLogin no
PermitEmptyPasswords no"


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
echo -e "1th phase"
# Enable openSSH
##check_command_success "systemctl enable sshd" "----> The sshd was enabled successfully <----" ">>>> Failed to enable sshd <<<<"

# Start openSSH
##check_command_success "systemctl start sshd" "----> The sshd started successfully <----" ">>>> Failed to start sshd, Check systemctl status sshd <<<<"

# Status openSSH
systemctl status sshd

echo -e "2th phase"

# Mitigation CVE-2020-15778
###check_command_success "chmod 0000 /usr/bin/scp" "----> The scp was disabled successfully <----" ">>>> Failed to disable scp <<<<"

echo -e "3th phase"

# Mitigation CVE-2023-48795/ HMAC (SHA1)


if [ -e "$cve_file_path" ]; then
  echo "File $cve_file_path exists."
else
  echo "File $cve_file_path does not exist. Creating the file and entering text."

  # Create the file and enter text
  echo -e "$CVE_2023_48795" > "$cve_file_path"

  echo "File $file_path created with the text \"$CVE_2023_48795\"."
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
#Set SSH Client Alive Interval 900 
echo -e "5th phase"


if grep -q '^StopIdleSessionSec' $logind_path; then
  echo "The config exists"
  existing_config=$(grep -i '^StopIdleSessionSec' $logind_path) 
  
  echo $existing_config
  read -p "Do you want to change the interval? (yes/no): " answer

if [ "$answer" == "yes" ]; then
  read -p "Enter the interval " interval
  sed -i "s/^${existing_config}/StopIdleSessionSec=$interval/" "$logind_path"
  
else
  echo "The interval will not change."
fi
  
else
  echo "The config does not exist"
  read -p "Do you want to set the interval? (yes/no): " answer

if [ "$answer" == "yes" ]; then
  read -p "Enter the interval " interval
  echo "StopIdleSessionSec=$interval" >> $logind_path
  echo -e "The interval( $interval ) was set in $logind_path "
else
  echo "The interval will not change."
fi
fi




