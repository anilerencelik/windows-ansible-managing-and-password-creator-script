#!/bin/bash

WDIRECTORY=/home/anileren/ansible
KEYPAIR_NAME=boyner-staging-new
KEYPAIR_LOCATION=/home/anileren/ansible/boyner-staging-new.pem

getEc2Details () {
    aws ec2 describe-instances --filters "Name=platform,Values=windows" "Name=instance-state-code,Values=16" "Name=key-name,Values=$KEYPAIR_NAME" | jq .Reservations > $WDIRECTORY/automata_ec2infos
    cat $WDIRECTORY/automata_ec2infos | grep InstanceId | sed 's| ||g' | sed 's|:||g' | sed 's|InstanceId||g' | sed 's|"||g' | sed 's|,||g' > $WDIRECTORY/automata_ec2ids
    cat $WDIRECTORY/automata_ec2infos | grep -A 1 '"Key": "Name"' | grep -v '"Key": "Name"' | grep -v "\-\-" | sed  's| ||g' | sed 's|:||g' | sed 's|Value||g' | sed 's|"||g' > $WDIRECTORY/automata_ec2names
    cat $WDIRECTORY/automata_ec2infos | grep -A 3 NetworkInterfaceId | grep PrivateIpAddress | sed 's| ||g' | sed 's|:||g' | sed 's|PrivateIpAddress||g' | sed 's|"||g' | sed 's|,||g' > $WDIRECTORY/automata_ec2ips
}

writeAnsibleInventory () {
    rm -rf $WDIRECTORY/inventoryAutomation.yml
    uzunluk=$(cat $WDIRECTORY/automata_ec2ids | wc -l )

    echo "[nodes:vars]
ansible_user=Administrator
ansible_port=5986
ansible_connection=winrm
ansible_winrm_server_cert_validation=ignore

[nodes]" >> $WDIRECTORY/inventoryAutomation.yml
    for (( c=1; c<=uzunluk; c++ ))
    do  
        id=$(head -n $c $WDIRECTORY/automata_ec2ids | tail -n 1 )
        name=$(head -n $c $WDIRECTORY/automata_ec2names | tail -n 1 )
        ip=$(head -n $c $WDIRECTORY/automata_ec2ips | tail -n 1 )
        echo "#$name">> $WDIRECTORY/inventoryAutomation.yml
        echo "$ip ansible_password="$(getPassword $id) >> $WDIRECTORY/inventoryAutomation.yml
    done
    rm -rf $WDIRECTORY/automata_ec2infos $WDIRECTORY/automata_ec2ids $WDIRECTORY/automata_ec2names $WDIRECTORY/automata_ec2ips
}

getPassword () {
    aws ec2 get-password-data --instance-id $1 --priv-launch-key $KEYPAIR_LOCATION | jq --raw-output .PasswordData
}

getEc2Details
writeAnsibleInventory
