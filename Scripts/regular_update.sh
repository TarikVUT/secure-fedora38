#!/bin/bash
#
# Author: Tarik Alkanan
# Date: 10.04.2024

#This script set regular update using crond
# 1- Install crond
# 2- Enable and start crond


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
 _                                
(_|    |          |               
  |    |    _   __|   __, _|_  _  
  |    |  |/ \_/  |  /  |  |  |/  
   \__/\_/|__/ \_/|_/\_/|_/|_/|__/
         /|                       
         \|                       

"
###################################
# Install crond
dnf install cronie -y

##################################
# Enable crond
check_command_success "systemctl enable crond" " The crond wad enabled successfully " " Fail to enable crond "

# Start crond
check_command_success "systemctl start crond" " The crond started successfully " " Fail to start crond. Chack status by running systemctl status crond "
##################################
# Set security daily update

echo -e "
#!/bin/bash

# Here you should run the command to backup the system.
# The command will depend on the method you use to back up your system
# 
# rear -d -v mkbackup
#
# Update the package repositories
sudo dnf -y update --security

# Log the update processe
echo 'Daily system update executed on \$(date)' > /var/log/daily_system_update.log
" > /etc/cron.daily/daily_system_update.sh

# Change mode
check_command_success "chmod +x /etc/cron.daily/daily_system_update.sh" " Grant execution permissions to the script was successfully " " Fail to change the script mode"

##################################
# Set update weekly

echo -e "#!/bin/bash
# Update the package repositories
sudo dnf -y update
# Log the update process
echo 'Weekly system update executed on \$(date)' > /var/log/weekly_system_update.log
" > /etc/cron.weekly/weekly_system_update.sh

# Change mode
check_command_success "chmod +x /etc/cron.weekly/weekly_system_update.sh" " Grant execution permissions to the script was successfully " " Fail to change the script mode"



}
main



