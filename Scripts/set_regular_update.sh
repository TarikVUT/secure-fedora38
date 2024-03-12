#!/bin/bash
#
#
#    NOTE, THIS CODE IS NOT COMPLETED YET.
#
#This script set regular update using crond
# 1- Install crond
# 2- Enable and start crond
# 3- Set update time

#update_path="/etc/cron.weekly/weekly_system_update.sh"
update_path="/home/student/Desktop/tmp/weekly_system_update.sh"

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

###################################
# Install crond
#dnf install cronie -y

##################################
# Enable crond
#check_command_success "systemctl enable crond" " The crond wad enabled successfully " " Fail to enable crond "

# Start crond
#check_command_success "systemctl start crond" " The crond started successfully " " Fail to start crond. Chack status by running systemctl status crond "

#check status
#systemctl status crond

##################################
# Set update weekly

echo -e "#!/bin/bash
# Update the package repositories
sudo dnf -y update
# Log the update process
echo 'Weekly system update executed on \$(date)' >> /var/log/weekly_system_update.log
" > $update_path
if [ $? -eq 0 ];then
echo "The scheduling update was set successfully"
else
echo " Fail to set schedul for update, please check $update_path"
fi

# Enable exec
#check_command_success "chmod +x $update_path" " The exec permission was set successfully " " Fail to set exec permission "



