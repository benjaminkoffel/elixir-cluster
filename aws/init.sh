#!/bin/bash

# install packages
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install -y esl-erlang elixir git awscli

# download and build application
git clone https://github.com/benjaminkoffel/elixir-cluster.git
cd elixir-cluster
mix local.hex --force && mix deps.get && mix release

# set hostname and address from instance metadata
HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/hostname | sed 's/[.].*$//')
ADDRESS=$(echo $HOSTNAME | sed 's/ip-//g' | sed 's/[-]/\./g')
sudo hostnamectl set-hostname $HOSTNAME
echo "127.0.0.1 ${HOSTNAME}" >> /etc/hosts
sed -i -e "s/\-name.*/\-name $HOSTNAME\@$ADDRESS/g" _build/dev/rel/app/releases/0.1.0/vm.args

# create .hosts.txt file containing other nodes
aws ec2 describe-instances \
  --region ap-southeast-2 \
  --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateDnsName' \
  --output text \
  --filter Name=tag:Project,Values=elixir-cluster \
  | sed '$!N;s/\t/\n/' \
  | sed 's/[.].*$//' \
  | sed 's@ip\-\(.*\)\-\(.*\)\-\(.*\)\-\(.*\)@ip\-\1\-\2\-\3\-\4\@\1\.\2\.\3\.\4@' \
  > .hosts.txt

# run application as daemon
_build/dev/rel/app/bin/app start
