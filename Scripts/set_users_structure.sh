#!/bin/bash
#
# Author: Tarik Alkanan
# Date: 10.04.2024
# This script is designed to set up user groups and permissions.


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

# Main function
main() {
    # Step 1: Creating administrators group
    echo -e "Step 1: Creating the Administrators group"
    echo
    read -p "Enter the name of the Administrators group: " Admin_Group
    echo
    check_command_success "groupadd $Admin_Group" "----> The group $Admin_Group was created successfully <----" ">>>> Failed to create the $Admin_Group group <<<<"
    echo
    echo -e "Adding sudo permissions to $Admin_Group"
    check_command_success "echo '%$Admin_Group ALL=(ALL) ALL' > /etc/sudoers.d/$Admin_Group" "----> The group $Admin_Group was added to sudoers successfully <----" ">>>> Failed to add $Admin_Group to sudoers <<<<"

    # Step 2: Creating user group for password management
    echo -e "Step 2: Creating user group for password management"
    echo
    read -p "Enter the name of the password group: " password_group
    check_command_success "groupadd $password_group" "----> The group $password_group was created successfully <----" ">>>> Failed to create the $password_group group <<<<"
    echo
    echo -e "Granting permission to change password for users in $password_group and restricting others"
    check_command_success "chown root:$password_group /usr/bin/passwd" "----> Changing the /usr/bin/passwd owner was successful <----" ">>>> Failed to change the /usr/bin/passwd owner <<<<"
    echo
    check_command_success "chmod o -rx /usr/bin/passwd" "----> Changing the /usr/bin/passwd permissions was successful <----" ">>>> Failed to change the /usr/bin/passwd permissions <<<<"

    # Step 3: Creating users
    echo -e "Step 3: Creating users"
    echo
    echo -e "You can now add users to $Admin_Group and $password_group using the 'usermod -aG group username' command. All newly added users will be considered technicians."
}

# Execute main function
main