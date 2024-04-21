#!/bin/bash
#
# Author: Tarik Alkanan



path=$(pwd)

backup_folder="/root/secure_backup"

files_backup(){
# Check if the folder exists
if [ ! -d "$backup_folder" ]; then
    # If the folder doesn't exist, create it
    mkdir -p "$backup_folder"
    echo "Created $backup_folder"
else
    echo "$backup_folder already exists"
fi
}

# Function to check the success of a command
check_command_success() {
    command_run="$1"
    true_message="$2"
    fail_message="$3"

    # Execute the command
    $command_run

    # Check the exit status of the command
    if [ $? -eq 0 ]; then
        echo "--->> $true_message <<---"
    else
        echo "*** $fail_message ***"
        exit 1
    fi
}
main(){
echo -e "
 ____                             _     _                  
/ ___|  ___  ___ _   _ _ __ ___  | |   (_)_ __  _   ___  __
\___ \ / _ \/ __| | | | '__/ _ \ | |   | | '_ \| | | \ \/ /
 ___) |  __/ (__| |_| | | |  __/ | |___| | | | | |_| |>  < 
|____/ \___|\___|\__,_|_|  \___| |_____|_|_| |_|\__,_/_/\_\.

"
                                                           

echo "Welcome to the Fedora OS security enhancement script."
echo "This script aims to bolster the security of your Fedora OS by addressing networking, passwords, SELinux, system logs, updates, and backups."
echo
read -p "Do you wish to proceed with the modifications? [y/n]: " choice
if [ "$choice" != "y" ]; then
    exit 0
fi

#create folder to backup the files
files_backup
echo
read -p "Do you to enable SELinux? [y/n]: " an1
if [ "$an1" == "y" ]; then
    sh "$path/SElinux.sh"
fi

echo
read -p "Do you to secure Network? [y/n]: " an2
if [ "$an2" == "y" ]; then
    sh "$path/secure_openSSH.sh"
    echo
    sh "$path/secure_openSSL.sh"

fi

echo
read -p "Do you want to create a hierarchical user structure consisting of three levels:
1- Administrators
2- Users
3- Technicians [y/n]: " an3

if [ "$an3" == "y" ]; then
    sh "$path/set_users_structure.sh"
fi

echo
read -p "Do you to want secure passwords? [y/n]: " an4
if [ "$an4" == "y" ]; then
    sh "$path/secure_password.sh"
fi

echo
read -p "Do you to rotate the logs? [y/n]: " an5
if [ "$an5" == "y" ]; then
    sh "$path/rsyslog.sh"
fi

echo
read -p "Do you to secure Network? [y/n]: " an6
if [ "$an6" == "y" ]; then
    echo hello
fi
}
main