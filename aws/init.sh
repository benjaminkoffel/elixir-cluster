#!/bin/bash

# install packages
sudo su
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
dpkg -i erlang-solutions_1.0_all.deb
apt-get update
apt-get install -y esl-erlang elixir git awscli

# download and build application
git clone https://github.com/benjaminkoffel/elixir-cluster.git
cd elixir-cluster
mix local.hex --force
mix deps.get
mix deps.compile
mix compile
mix release

# set hostname and address from instance metadata
HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/hostname | sed 's/[.].*$//')
ADDRESS=$(echo $HOSTNAME | sed 's/ip-//g' | sed 's/[-]/\./g')
sudo hostnamectl set-hostname $HOSTNAME
echo "127.0.0.1 ${HOSTNAME}" >> /etc/hosts
sed -i -e "s/\-name.*/\-name $HOSTNAME\@$ADDRESS/g" _build/dev/rel/app/releases/0.1.0/vm.args

# hardcode hosts.txt
echo ":\"ip-172-31-11-52@172.31.11.52\"" >> _build/dev/rel/app/.hosts.txt
echo ":\"ip-172-31-31-153@172.31.31.153\"" >> _build/dev/rel/app/.hosts.txt
# echo ":\"a@192.168.1.1 \"" >> _build/dev/rel/app/.hosts.txt
# echo ":\"b@192.168.1.1 \"" >> _build/dev/rel/app/.hosts.txt

##sed -r -i "s/\-sname.+/\-name api\@$(hostname)/g" /opt/app/releases/0.1.0/vm.args

# create .hosts.txt file containing other nodes
AWS_DEFAULT_REGION=ap-southeast-2
# SERVER_CLASS=elixir-cluster-autoscaling-group
# aws ec2 describe-instances \
#   --region ap-southeast-2
#   --query 'Reservations[].Instances[].NetworkInterfaces[].PrivateIpAddresses[].PrivateDnsName' \
#   --output text \
#   --filter Name=tag:Class,Values=${SERVER_CLASS} | sed '$!N;s/\t/\n/' | sed -e "s/\(.*\)/'\1'./" > .hosts.txt

# run application
_build/dev/rel/app/bin/app foreground

# MIX_ENV=dev elixir --name $HOSTNAME@$ADDRESS -S mix run --no-compile --no-halt
# iex --name $HOSTNAME@$ADDRESS -S mix
