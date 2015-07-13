#!/bin/bash

## load conf
. config.sh


USER=$1
PASSWORD=$2
HOST=$3

echo "USER:"$USER
echo "PASSWORD:"$PASSWORD
echo "HOST:"$HOST



## run main script
$_BIN_PATH/expect<<EOF
	if { "$USER" ne "root" } {
		spawn $_BIN_PATH/ssh-copy-id $USER@$HOST
	} else {
		spawn $_BIN_PATH/ssh-copy-id $HOST
	}
	expect "*password*" { 
		send "$PASSWORD\r"
	}
	expect "*yes/no*" { 
		send "yes\r"
		exp_continue
	}
EOF
echo "+++++ DONE Dest ssh key : $PASSWORD, $USER@$HOST"