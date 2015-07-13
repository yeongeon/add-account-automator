#!/bin/bash

## load conf
. config.sh

## load lib
. functions.sh

## run
echo "<BEGIN-UNIT-TEST>";

#createSSHKey $_ROOT
#postSSHKeys $_ROOT $ROOT_PASSWORD

#users=(hadoop hbase tajo)
#USERS=(test101)
#HOSTS_SIZE=${#HOSTS[@]}



_host_size=$HOSTS_SIZE
echo "+++++ _host_size A:$_host_size"

_host_size=`expr $_host_size - 1`
echo "+++++ _host_size B:$_host_size"

for i in `seq 0 $_host_size`
do
	dest_host=${HOSTS[$i]}
	echo "$i : $dest_host"
	
done


user=$1 
pass="$user-pass"
isRemote=0 
dest_host=“host03"

echo "------------------------------------------------------"
echo "***** input: $user, $pass, $isRemote, $dest_host"
echo "------------------------------------------------------"
useradd -m $user
if [ $? -eq 0 ]; then
	echo "User has been added to system!"
$_BIN_PATH/expect<<EOF
	spawn passwd $user
	expect "*hanging password*"
	expect "*pass*"
	send "$pass\r"
	interact
EOF
else
	echo "Failed to add a user!"
fi


#addAccount $user $pass 0
#addAccount $user $pass 1 $dest_host


#createSSHKey $user
#postSSHKeys $user $pass

unset USERS_SIZE
unset HOSTS_SIZE
echo "<END-UNIT-TEST>";

