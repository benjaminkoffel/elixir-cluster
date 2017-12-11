#!/bin/bash

# work in progress, is meant to initialization script to boot ec2

# set hostname from instance metadata
# HOSTNAME="$(curl http://169.254.169.254/latest/meta-data/hostname)"
HOSTNAME=$(base64 /dev/urandom | tr -cd '[[:alnum:]]._-' | head -c 10)
sudo hostnamectl set-hostname $HOSTNAME
echo "127.0.0.1 ${HOSTNAME}" >> /etc/hosts


##sed -r -i "s/\-sname.+/\-name api\@$(hostname)/g" /opt/app/releases/0.1.0/vm.args

# create .hosts.erlang containing other nodes
# SERVER_CLASS=tag-for-similar-nodes-in-aws
# aws ec2 describe-instances \
#   --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateDnsName' \
#   --output text \
#   --filter Name=tag:Class,Values=${SERVER_CLASS} | sed '$!N;s/\t/\n/' | sed -e "s/\(.*\)/'\1'./" > $OTP_ROOT/.hosts.erlang

echo "node initialized"
