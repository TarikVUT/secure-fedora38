#!/bin/bash
#
# Author: Tarik Alkanan
# Date: 10.04.2024

echo -e "

 ____                              ___                   ____ ____  _     
/ ___|  ___  ___ _   _ _ __ ___   / _ \ _ __   ___ _ __ / ___/ ___|| |    
\___ \ / _ \/ __| | | | '__/ _ \ | | | | '_ \ / _ \ '_ \\___ \___ \| |    
 ___) |  __/ (__| |_| | | |  __/ | |_| | |_) |  __/ | | |___) |__) | |___ 
|____/ \___|\___|\__,_|_|  \___|  \___/| .__/ \___|_| |_|____/____/|_____|
                                       |_|                                

"



echo "Securing OpenSSL depends on its usage context, such as whether it's for a web server or mail server."
echo "We recommend configuring it with the FUTURE crypto policy."
echo "For further guidance, please refer to the GitHub page https://github.com/TarikVUT/secure-fedora38?tab=readme-ov-file#Network"
echo "or the man page of crypto-policy man update-crypto-policies ."