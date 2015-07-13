#!/bin/bash

_ROOT="root"
ROOT_PASSWORD=“password”

#hosts=(host01 host02 host03 host04 host05 host06)
HOSTS=($(cat ./_HOSTS))
#HOSTS_SIZE=`expr ${#HOSTS[@]} - 1`
HOSTS_SIZE=${#HOSTS[@]}
echo "HOST_SIZE: $HOSTS_SIZE"


#users=(hadoop hbase)
USERS=($(cat ./_ACCOUNTS))
#USERS_SIZE=`expr ${#USERS[@]} - 1`
USERS_SIZE=${#USERS[@]}
echo "USERS_SIZE: $USERS_SIZE"

_KEY=""
_PASSPHRASE=""
_SAME_PASSPHRASE=$_PASSPHRASE

_BIN_PATH="/usr/bin"

