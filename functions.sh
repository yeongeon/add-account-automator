#!/bin/bash

### 
# CREATE ACCOUNTS
# @param userid
# @param user password
# @param is remote 0|1
# @param remote hostname
##
function addAccount {
	params=$#

 	userid=$1
 	userpw=$2
 	remote_host=""
 	is_remote=0
 	 	
 	if [ $params -ge 3 ]
 	then
 		is_remote=$3
 		if [ $3 -eq 1 ]
 		then
 			remote_host=$4
 		fi
 	fi
 	 	
 	if [ $is_remote -eq 0 ]
 	then
		echo "+++++ addAccount : $userid"	
 	else 
		echo "+++++ addAccount to remote : $userid@$remote_host"
 	fi
 	
 	if [ $(id -u) -eq 0 ]
 	then
 		. useradd.sh $userid $userpw $is_remote $remote_host
 	else
       	echo "Only root may add a user to the system"
    fi
}


### 
# CREATE SSH Key
# @param userid
##
function createSSHKey {
	user=$1
	echo "+++++ createSSHKey : $user"
	
	## GENERATE SSH KEYS
$_BIN_PATH/expect<<EOF
	if { "$user" ne "root" } {
		spawn su $user -c "ssh-keygen -t rsa"
	} else {
		spawn $_BIN_PATH/ssh-keygen -t rsa
	}
	expect "*verwrite*" { 
		send "y\r"
	}
    expect "*Enter file in which to save the key*" { 
    	send "$_KEY\r"
    }
   	expect "*yes/no*" { 
   		send "yes\r"
    }
   	expect "*Enter passphrase*" { 
   		send "$_PASSPHRASE\r"
    }
   	expect "*Enter same passphrase again*" { 
   		send "$_SAME_PASSPHRASE\r"
	}
EOF
echo "== DONE : created SSH key for $user"
}


### 
# Post SSH Key
# @param user
# @param password
# @param hostname
##
function postSSHKeyToEach {
	user=$1
	password=$2
	dest_host=$3
	echo "+++++ postSSHKeyToEach : $user"
	
	## don't use .sh
	#. ssh-keycopy.sh $user $password $dest_host 
$_BIN_PATH/expect<<EOF
	if { "$user" ne "root" } {
		spawn ssh-copy-id $user@$dest_host
	} else {
		spawn ssh-copy-id $dest_host
	}
	expect "* password:*" { 
		send "$password\r"
	}
	expect "*Are you sure you want to continue connecting*" { 
		send "yes\r"
	}
EOF
echo "+++++ DONE Dest ssh key : $password, $user@$dest_host"
}

### 
# Post SSH Key to various hosts
# @param user
# @param password
##
function postSSHKeys {	
	user=$1	
	password=$2
	echo "+++++ postSSHKeys : $user"
	## post key
	_host_size=`expr $HOSTS_SIZE - 1`
	#_host_size=$HOSTS_SIZE
	echo "+++++ _host_size:$_host_size"
	for i in `seq 0 $_host_size`
	do
		dest_host=${HOSTS[$i]}
		postSSHKeyToEach $user $password $dest_host
	done
}