#!/bin/bash

## load conf
. config.sh

## load lib
. functions.sh


## run
echo "<BEGIN-AUTOMATOR>"
echo "========================================================================="
echo "100 ]] Create SSH key at localhost for ROOT"
echo "========================================================================="
createSSHKey $_ROOT

echo "========================================================================="
echo "200 ]] Deploy SSH Keys for ROOT"
echo "========================================================================="
postSSHKeys $_ROOT $ROOT_PASSWORD 

_user_size=`expr $USERS_SIZE - 1`
for i in `seq 0 $_user_size`
do
	user=${USERS[$i]}
	echo "========================================================================="
	echo "300 ]] Process accounts :: $user"
	echo "========================================================================="
	
	## post key
	_host_size=`expr $HOSTS_SIZE - 1`
	for j in `seq 0 $_host_size`
	do	
		dest_host=${HOSTS[$j]}		
		echo ">>> $i : $user@$dest_host"
		echo "========================================================================="
		echo "400 ]] Process account at host :: $user :: $dest_host"
		echo "========================================================================="
		
		pass=$user
		echo "========================================================================="
		echo "410 ]] Process account at host :: $user :: localhost"
		echo "========================================================================="
		addAccount $user $pass 0
		
		echo "========================================================================="
		echo "420 ]] Process account at host :: $user :: $dest_host"
		echo "========================================================================="
		addAccount $user $ROOT_PASSWORD 1 $dest_host
	done
	
	echo "========================================================================="
	echo "500 ]] Generate a SSH Key :: $user"
	echo "========================================================================="
	createSSHKey $user
	
	echo "========================================================================="
	echo "600 ]] Generate a SSH Key at remote host :: $user :: $dest_host"
	echo "========================================================================="
	postSSHKeys $user $user
done

unset USERS_SIZE
unset HOSTS_SIZE
echo "<END-AUTOMATOR>"

