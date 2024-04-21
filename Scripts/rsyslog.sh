#!/bin/bash
#
# Author: Tarik Alkanan
# Note: This script is not completed yet.

# This script installs and configures rsyslog.

rsyslog_config="/etc/rsyslog.conf"
backup_rsyslog_config="/root/secure_backup/rsyslog.conf.bkp"

backup(){

# Check if the config file exists
if [ -f "$backup_rsyslog_config" ]; then
    echo "$backup_rsyslog_config backup for $rsyslog_config exist"
else
    echo "$backup_rsyslog_config does not exist, the backup will be created for $rsyslog_config"
    cp $rsyslog_config $backup_rsyslog_config
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

# Function to send logs via UDP
send_logs_udp() {
    echo "Sending logs via UDP..."
    read -p "Enter the IP address for the receiving server (in format 255.255.255.255): " server_ip_address
    read -p "Enter the IP port for the receiving server: " server_port

    # Adding UDP port to firewall
    check_command_success "firewall-cmd --permanent --add-port=$server_port/udp" "----> The port $server_port/udp was added successfully <----" ">>>> Failed to add $server_port/udp port <<<<"
    check_command_success "firewall-cmd --reload" "----> The firewall-cmd was reloaded successfully <----" ">>>> Failed to reload firewall-cmd <<<<"

    #create backup for /etc/rsyslog.conf
    backup

    # Adding server address and port to rsyslog configuration
    echo "*.* @$server_ip_address:$server_port" >> $rsyslog_config

    # Instructions for server configuration
    echo -e "The server_udp_rsyslog_config file was created in /root/. Add the config on the server side:"
    echo -e "
    Install the rsyslog package: # dnf install rsyslog
    Add the $server_port/udp to the firewall using: firewall-cmd --permanent --add-port=$server_port/udp 
    Reload the firewall using: firewall-cmd --reload

    Add the below lines to $rsyslog_config:
    module(load="imudp")
    input(type="imudp" port="$server_port") 

    Restart the rsyslog service: # systemctl restart rsyslog

    " >> /root/server_udp_rsyslog_config.txt

    echo -e "After applying the steps on the client and server sides, restart rsyslog by running: systemctl restart rsyslog"
}

# Function to send logs via TCP
send_logs_tcp() {
    echo "Sending logs via TCP..."
    read -p "Enter the IP address for the receiving server (in format 255.255.255.255): " server_ip_address
    read -p "Enter the IP port for the receiving server: " server_port

    # Adding TCP port to firewall
    check_command_success "firewall-cmd --permanent --add-port=$server_port/tcp" "----> The port $server_port/tcp was added successfully <----" ">>>> Failed to add $server_port/tcp port <<<<"
    check_command_success "firewall-cmd --reload" "----> The firewall-cmd was reloaded successfully <----" ">>>> Failed to reload firewall-cmd <<<<"

    #create backup for /etc/rsyslog.conf
    backup

    # Adding server address and port to rsyslog configuration
    echo "*.* @@$server_ip_address:$server_port" >> $rsyslog_config

    # Instructions for server configuration
    echo -e "The server_tcp_rsyslog_config file was created in /root/. Add the config on the server side:"
    echo -e "
    Install the rsyslog package: # dnf install rsyslog
    Add the $server_port/tcp to the firewall using: firewall-cmd --permanent --add-port=$server_port/tcp 
    Reload the firewall using: firewall-cmd --reload

    Add the below lines to $rsyslog_config:
    module(load="imtcp")
    input(type="imtcp" port="$server_port") 

    Restart the rsyslog service: # systemctl restart rsyslog
    " >> /root/server_tcp_rsyslog_config.txt

    echo -e "After applying the steps on the client and server sides, restart rsyslog by running: systemctl restart rsyslog"
}

# Function to send logs via RELP
send_logs_relp() {
    echo "Sending logs via RELP..."
    read -p "Enter the IP address for the receiving server (in format 255.255.255.255): " server_ip_address
    read -p "Enter the IP port for the receiving server: " server_port
    read -p "Enter the RELP path where the logs will be saved on the server side: " path_relp

    # Adding TCP port to firewall
    check_command_success "firewall-cmd --permanent --add-port=$server_port/tcp" "----> The port $server_port/tcp was added successfully <----" ">>>> Failed to add $server_port/tcp port <<<<"
    check_command_success "firewall-cmd --reload" "----> The firewall-cmd was reloaded successfully <----" ">>>> Failed to reload firewall-cmd <<<<"

    #create backup for /etc/rsyslog.conf
    backup

    # Adding server address and port to rsyslog configuration
    echo -e "module(load="omrelp")\n*.* action(type="omrelp" target="$server_ip_address" port="$server_port")" >> /etc/rsyslog.d/client_relp.conf

    # Instructions for server configuration
    echo -e "The server_relp_rsyslog_config file was created in /root/. Add the config on the server side:"
    echo -e "

    Install the rsyslog package: # dnf install rsyslog
    Add the $server_port/tcp to the firewall using: firewall-cmd --permanent --add-port=$server_port/tcp 
    Reload the firewall using: firewall-cmd --reload

    Create the /etc/rsyslog.d/server_relp.conf file and add the below lines:
    ---------------------------------------------------------
    ruleset(name="relp"){
    *.* action(type="omfile" file="$path_relp")
    }   

    module(load="imrelp")
    input(type="imrelp" port="$server_port" ruleset="relp")
    ---------------------------------------------------------

    Restart the rsyslog service: # systemctl restart rsyslog
    
    " >> /root/server_relp_rsyslog_config.txt

    echo -e "After applying the steps on the client and server sides, restart rsyslog by running: systemctl restart rsyslog"
}

# Function to send logs via TLS
send_logs_tls() {
    echo "Sending logs via TLS..."
    echo "Please refer to the GitHub page: https://github.com/TarikVUT/secure-fedora38"
}

# Main function
main() {
echo -e "
 , __                          _                
/|/  \                        | |               
 |___/  __ _|_  __, _|_  _    | |  __   __,  ,  
 | \   /  \_|  /  |  |  |/    |/  /  \_/  | / \_
 |  \_/\__/ |_/\_/|_/|_/|__/  |__/\__/ \_/|/ \/ 
                                         /|     
                                         \|     
"



    # Install rsyslog
    check_command_success "dnf install -y rsyslog" "----> rsyslog installed successfully <----" ">>>> Failed to install rsyslog <<<<"

    # Enable and start rsyslog
    check_command_success "systemctl enable rsyslog" "----> rsyslog enabled successfully <----" ">>>> Failed to enable rsyslog <<<<"
    check_command_success "systemctl start rsyslog" "----> rsyslog started successfully <----" ">>>> Failed to start rsyslog <<<<"

    # Prompt user to choose log sending method
    echo "Choose a protocol to send logs:"
    echo "1. UDP"
    echo "2. TCP"
    echo "3. RELP"
    echo "4. TCP over TLS"

    read -p "Enter your choice (1-4): " choice

    case $choice in
        1) send_logs_udp ;;
        2) send_logs_tcp ;;
        3) send_logs_relp ;;
        4) send_logs_tls ;;
        *) echo "Invalid choice. Please enter a number between 1 and 4." ;;
    esac
}

# Call the main function
main
