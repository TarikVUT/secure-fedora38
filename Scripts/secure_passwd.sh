#!/bin/bash
#
# Author: Tarik Alkanan
# Note: This script is not completed yet.

# This script sets password complexity and password expiration.
#This script was created to set password complexity and password expiration.
passwd_path="/etc/security/pwquality.conf.d/"
passwd_file="complex_password.conf"
login_path="/etc/login.defs"
login_path_backup="/root/secure_backup/login.defs.bkp"

dcredit=0
ucredit=0
lcredit=0
ocredit=0
minclass=0
maxrepeat=0
maxsequence=0
difok=0

#recommended_PASS_MAX_DAYS="PASS_MAX_DAYS   90"
#recommended_PASS_MIN_DAYS="PASS_MIN_DAYS   0"
#recommended_PASS_WARN_AG="PASS_WARN_AGE   7"

maximum=90
minimum=0
days_warning=7



the_recommended_config="## This parameter determines whether the password quality checks specified in this configuration file are enforced for the root user. \nenforce_for_root \n
## The minimum length of the password \nminlen = 12 \n
##  The credit assigned for each digit (numeric character) in the password \ndcredit = -1 \n
##  The credit assigned for each uppercase letter in the password. \nucredit = -1 \n
##  The credit assigned for each lowercase letter in the password. \nlcredit = 1 \n
##  The credit assigned for each special character (other character) in the password. \nocredit = 1 \n
##  The minimum number of character classes (types of characters) that must be present in the password. \nminclass = 1 \n
##  The maximum number of consecutive identical characters allowed in the password. \nmaxrepeat = 2 \n
##  The maximum number of consecutive characters allowed from the same character class (e.g., consecutive uppercase letters, consecutive digits) \nmaxclassrepeat = 3 \n
##  The number of characters that must differ between the new password and the old password. \ndifok = 5 
"

backup(){

# Check if the config file exists
if [ -f "$login_path_backup" ]; then
    echo "$login_path_backup backup for $login_path exist"
else
    echo "$login_path_backup does not exist, the backup will be created for $login_path"
    cp $login_path $login_path_backup
fi

}

check_command_success(){

command_run="$1"
true_message="$2"
fail_message="$3"

$command_run

if [ $? -eq 0 ]	
then
	echo "--->> $true_message <<---"
else
	echo "*** $fail_message ***"
	exit 0
fi
}
check_empty_variable() {
    local parameter="$1"
    local default_value="$2"

    if [ -z "${!parameter}" ]; then
        eval "$parameter=$default_value"
    fi
}

set_config(){

echo -e "

In the next steps, you will be require to enter a values to set the password complexity.
Please Note, the below steps do not investigated against errors
IN CASE PRESSED ENTER WITHOUT TYPING ANYTHING, SET THE DEFAULT VALUE.


"

read -p "Set the Minimum acceptable size for the new password (Cannot be set to lower value than 6): " minlen
check_empty_variable "minlen" "6"
if [ "$minlen" -lt 6 ]; then
    minlen=6
fi

read -p "Set the maximum credit for having digits in the new password. If less than 0 it is the minimum number of digits in the new password. default 0: " dcredit
check_empty_variable "dcredit" "0"

read -p "Set the maximum credit for having uppercase characters in the new password.  If less than 0 it is the minimum number of uppercase characters in the new password. (default 0): " ucredit
check_empty_variable "ucredit" "0"

read -p "Set the maximum credit for having lowercase characters in the new password.  If less than 0 it is the minimum number of lowercase characters in the new password. (default 0) : " lcredit
check_empty_variable "lcredit" "0"

read -p "Set the maximum credit for having other characters in the new password.  If less than 0 it is the minimum number of other characters in the new password. (default 0) : " ocredit
check_empty_variable "ocredit" "0"

read -p "Set the minimum number of required classes of characters for the new password (digits, uppercase, lowercase, others). (default 0): " minclass
check_empty_variable "minclass" "0"

read -p "Set the maximum number of allowed same consecutive characters in the new password.  The check is disabled if the value is 0. (default0): " maxrepeat
check_empty_variable "maxrepeat" "0"

read -p "Set the maximum length of monotonic character sequences in the new password, The check is disabled if the value is 0: " maxsequence
check_empty_variable "maxsequence" "0"

read -p "Set the Number of characters in the new password that must not be present in the old password. (default 1): " difok
check_empty_variable "difok" "1"

echo "Your new setting"
echo -e "minlen = $minlen
dcredit = $dcredit
ucredit = $ucredit
lcredit = $lcredit
ocredit = $ocredit
minclass = $minclass
maxrepeat = $maxrepeat
maxsequence = $maxsequence
difok = $difok
"

the_setting_config="## This parameter determines whether the password quality checks specified in this configuration file are enforced for the root user. \nenforce_for_root \n
## The minimum length of the password \nminlen = $minlen \n
##  The credit assigned for each digit (numeric character) in the password \ndcredit = $dcredit \n
##  The credit assigned for each uppercase letter in the password. \nucredit = $ucredit \n
##  The credit assigned for each lowercase letter in the password. \nlcredit = $lcredit \n
##  The credit assigned for each special character (other character) in the password. \nocredit = $ocredit \n
##  The minimum number of character classes (types of characters) that must be present in the password. \nminclass = $minclass \n
##  The maximum number of consecutive identical characters allowed in the password. \nmaxrepeat = $maxrepeat \n
##  The maximum number of consecutive characters allowed from the same character class (e.g., consecutive uppercase letters, consecutive digits) \nmaxclassrepeat = $maxsequence \n
##  The number of characters that must differ between the new password and the old password. \ndifok = $difok
"
echo -e $the_setting_config > ${passwd_path}/${passwd_file}
	if [ $? -eq 0 ]
	then
	 	echo "--->> The file '${passwd_path}/${passwd_file}' was updated successfully with the new setting config <<---"
	else
	 	echo "*** Failed to update the file '${passwd_path}/${passwd_file} ***"
	 
	fi

}

# Function to apply the recommended password configuration for complexity
apply_the_recommended_config_for_complex(){
read -p "Do you want to apply the recommended password configuration? (y/N): " answer
	if [ "$answer" == "y" ]; then
	 echo -e $the_recommended_config > ${passwd_path}${passwd_file}

	 	if [ $? -eq 0 ]
	 	then
	 		echo "--->> The file '${passwd_path}${passwd_file}' was updated successfully <<---"
	 	else
	 		echo "*** Failed to update the file '${passwd_path}/${passwd_file} ***"
	 
	 	fi
	else
 	  	echo "This required a good knowledge"
 	  	set_config
	fi


}

# Function to apply the recommended password expiration configuration
apply_the_recommended_config_for_expiration(){
read -p "Do you want to apply the recommended password expiration? (y/N): " answer
existing_PASS_MAX_DAYS=$(grep -i '^PASS_MAX_DAYS' $login_path)
existing_PASS_MIN_DAYS=$(grep -i '^PASS_MIN_DAYS' $login_path)
existing_PASS_WARN_AGE=$(grep -i '^PASS_WARN_AGE' $login_path)

	if [ "$answer" == "y" ]; then
		sed -i "s/^${existing_PASS_MAX_DAYS}/PASS_MAX_DAYS   $maximum/" "$login_path"
	 	sed -i "s/^${existing_PASS_MIN_DAYS}/PASS_MIN_DAYS   $minimum/" "$login_path"
	 	sed -i "s/^${existing_PASS_WARN_AGE}/PASS_WARN_AGE   $days_warning/" "$login_path"
	 	
	 	echo -e "The new value:
	 	PASS_MAX_DAYS   $maximum
	 	PASS_MIN_DAYS   $minimum
	 	PASS_WARN_AGE   $days_warning
	 	\nThis values were update to $login_path
	 	
	 	"
	else
 	  	echo "
 	  	
 	  	
 	  	This required a good knowledge
 	  	IN CASE PRESSED ENTER WITHOUT TYPING ANYTHING, SET THE DEFAULT VALUE
 	  	
 	
 	  	"
 	  	read -p "Enter the maximum number of days a password may be used. " maximum
 	  	check_empty_variable "maximum" "99999"
 	  	if [ "$maximum" -lt 0 -o "$maximum" -gt 100000 ]; then
    		maximum=99999
		fi
 	  	
 	  	read -p "Enter the minimum number of days allowed between password changes. " minimum
 	  	check_empty_variable "minimum" "0"
 	  	if [ "$minimum" -lt 0 -o "$minimum" -gt 100000 ]; then
    		minimum=0
		fi
 	  	
 	  	read -p "Enter the number of days warning given before a password expires. " days_warning
		check_empty_variable "days" "7"
		if [ "$days_warning" -lt 0 -o "$days_warning" -gt 100000 ]; then
    			days_warning=7
		fi
		
		sed -i "s/^${existing_PASS_MAX_DAYS}/PASS_MAX_DAYS   $maximum/" "$login_path"
	 	sed -i "s/^${existing_PASS_MIN_DAYS}/PASS_MIN_DAYS   $minimum/" "$login_path"
	 	sed -i "s/^${existing_PASS_WARN_AGE}/PASS_WARN_AGE   $days_warning/" "$login_path"
	 	
	 	echo -e "The new value:
	 	PASS_MAX_DAYS   $maximum
	 	PASS_MIN_DAYS   $minimum
	 	PASS_WARN_AGE   $days_warning
	 	\nThis values were update to $login_path
	 	
	 	"
		
	fi

}

main(){
 	
echo -e "
 ____                                                             _ 
/ ___|  ___  ___ _   _ _ __ ___   _ __   __ _ ___ _____      ____| |
\___ \ / _ \/ __| | | | '__/ _ \ | '_ \ / _` / __/ __\ \ /\ / / _` |
 ___) |  __/ (__| |_| | | |  __/ | |_) | (_| \__ \__ \\ V  V / (_| |
|____/ \___|\___|\__,_|_|  \___| | .__/ \__,_|___/___/ \_/\_/ \__,_|
                                 |_|   
"


	read -p "Do you want to want to set the password complexity (y/N): " rep1

	if [ "$rep1" == "y" ]; then

		if [ -z "$(ls -A "$passwd_path")" ]; then
    		echo "There is no configuration setting in $passwd_path"
    		apply_the_recommended_config_for_complex
    
		else
    
			echo "Directory $passwd_path contains a files, may that file contents a configuration, which will effect the new configuration. Kindly check it."
    		read -p "Do you want to want to continue(y/N): " ans
    
    		if [ "$ans" == "y" ]; then
   	 			apply_the_recommended_config_for_complex
   			else
			   	echo "bye"
   			fi

		fi
	fi

	read -p "Do you want to want to set the password expiration (y/N): " rep2
		if [ "$rep2" == "y" ]; then

			echo -e "  

			The second phase is to set the password expiration

			"	
			#create the backup for /etc/login.defs
			backup

			apply_the_recommended_config_for_expiration
		else

			echo "Nothing to do"
			exit 0
		fi

}
main