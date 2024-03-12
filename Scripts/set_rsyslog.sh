#!/bin/bash
#This script install and configure  rsyslog.
# 1- Install rsyslog
# 2- Enable and start rsyslog
# 3- Config rsyslog

###############################
# 1- Install rsyslog
dnf install -y rsyslog
# 2- Enable and start rsyslog
systemctl enable rsyslog
systemctl start rsyslog
systemctl status rsyslog

