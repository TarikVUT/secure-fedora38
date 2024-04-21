#!/bin/bash
#
# Author: Tarik Alkanan
# Date: 10.04.2024
# Note: This script is not completed yet.

# This script activates SELinux

# Path to SELinux configuration file
selinux_path="/etc/selinux/config"
selinux_path_backup="/root/secure_backup/config.bkp"
# Value to set SELinux to enforcing mode
set_enforce="SELINUX=enforcing"

backup(){

# Check if the config file exists
if [ -f "$selinux_path_backup" ]; then
    echo "$selinux_path_backup backup for $selinux_path exist"
else
    echo "$selinux_path_backup does not exist, the backup will be created for $selinux_path"
    cp $selinux_path $selinux_path_backup
fi

}
# Function to change SELinux mode to enforcing if not already set
main() {

echo -e "
 ____  _____ _     _                  
/ ___|| ____| |   (_)_ __  _   ___  __
\___ \|  _| | |   | | '_ \| | | \ \/ /
 ___) | |___| |___| | | | | |_| |>  < 
|____/|_____|_____|_|_| |_|\__,_/_/\_\

"

    if grep -q '^SELINUX=enforcing' "$selinux_path"; then
        echo -e "The SELinux mode is Enforcing. Nothing to do"
    else
        echo -e "The SELinux mode is not enforcing; it should change to Enforcing"
        
        backup

        # Change SELinux mode to enforcing
        sed -i "s/^SELINUX=.*/$set_enforce/" "$selinux_path"
        
        # Check if SELinux mode is successfully changed to enforcing
        if grep -q '^SELINUX=enforcing' "$selinux_path"; then
            echo -e "The SELinux mode was changed to enforcing successfully"
        else
            echo -e "Failed to change SELinux mode, please check the SELinux mode in /etc/selinux/config."
            echo -e "Please refer to man page man selinux"
        fi
    fi
}

# Execute the main function
main
