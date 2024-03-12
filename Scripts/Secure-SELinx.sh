#!/bin/bash
#
#
#    NOTE, THIS CODE IS NOT COMPLETED YET.
#
#This script actives SELinux
# selinux_path="/etc/selinux/config"
# set_enforce="SELINUX=enforcing"

#SHOULD CHANGE

selinux_path="/home/student/Desktop/tmp/config"
set_enforce="SELINUX=enforcing"

if grep -q '^SELINUX=enforcing' "$selinux_path"; then
  echo -e "The SELinux mode is Enforcing. Nothing to do"
else
  echo -e "The SELinux mode is not enforcing; it should change to Enforcing"
  sed -i "s/^SELINUX=.*/$set_enforce/" "$selinux_path"
  
  if grep -q '^SELINUX=enforcing' "$selinux_path"; then
  echo -e "The SELinux mode was changed to enforcing successfully"
  else
  echo -e "Failed to change SELinux mode, please check the SELinux mode in /etc/selinux/config.
  Please refer to man page man selinux"
  fi
fi
