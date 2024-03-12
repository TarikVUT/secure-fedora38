#!/bin/bash
#
#
#    NOTE, THIS CODE IS NOT COMPLETED YET.
#
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

echo "start"

## Install, enable and start openSSH.
check_command_success "dnf install openssh -y" "Installing openSSH was seccessfully" "Fail to install openSSH"
check_command_success "systemctl enable sshd"
systemctl start sshd
systemctl status sshd

## Addressing the openSSH vulnerabilities (CVE-2020-15778, CVE-2023-48795)

# 1- Disable scp
chmod 0000 /usr/bin/scp

# 2- CVE-2023-48795/ HMAC (SHA1)

