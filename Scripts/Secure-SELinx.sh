#!/bin/bash
#
# Author: Tarik Alkanan
# Date: 10.04.2024
# Note: This script is not completed yet.

# This script activates SELinux

# Path to SELinux configuration file
selinux_path="/home/student/Desktop/tmp/config"
# Value to set SELinux to enforcing mode
set_enforce="SELINUX=enforcing"

# Function to change SELinux mode to enforcing if not already set
main() {
    if grep -q '^SELINUX=enforcing' "$selinux_path"; then
        echo -e "The SELinux mode is Enforcing. Nothing to do"
    else
        echo -e "The SELinux mode is not enforcing; it should change to Enforcing"
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
