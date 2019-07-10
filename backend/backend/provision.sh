#!/bin/sh

echon(){

	printf "\n$1\n"
}

set -e 

cat << EOF

"#####################################################"
"Install rabbitmq prerequisite"
"#####################################################"

EOF

#These steps are from : https://www.rabbitmq.com/install-debian.html

apt-key adv --keyserver "hkps.pool.sks-keyservers.net" --recv-keys 

apt-get update -y

apt-get install wget apt-transport-https nano net-tools -y

wget -O - "https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc" | apt-key add -


tee /etc/apt/sources.list.d/bintray.erlang.list <<EOF
deb https://dl.bintray.com/rabbitmq/debian xenial erlang-21.x
EOF

apt-get update -y

echon "Installing all Erlang"

apt-get install -y erlang-base \
                        erlang-asn1 erlang-crypto erlang-eldap  erlang-inets \
                        erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key \
                        erlang-runtime-tools erlang-snmp erlang-ssl \
                        erlang-syntax-tools  erlang-tools erlang-xmerl


echon "Starting to install RabbitMQ"

wget -O - "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | apt-key add -

## Install RabbitMQ signing key
apt-key adv --keyserver "hkps.pool.sks-keyservers.net" --recv-keys "0x6B73A36E6026DFCA"



## Add Bintray repositories that provision latest RabbitMQ and Erlang 21.x releases
tee /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOF
deb https://dl.bintray.com/rabbitmq-erlang/debian xenial erlang-21.x
deb https://dl.bintray.com/rabbitmq/debian xenial main
EOF

## Update package indices
apt-get update -y

echon "Installing Rabbit MQ Server"
## Install rabbitmq-server and its dependencies
apt-get install rabbitmq-server -y --fix-missing

echon "Waiting for 10 seconds"
sleep 10

cat << EOF

"##########################################"
"Installing PIP and then nameko "
"##########################################"

EOF

apt-get install python-pip -y

pip install nameko

cat << EOF

"##########################################"
"Starting RabitMQ with new Config file"
"##########################################"

EOF


# Copy config that runs Rabbit MQ on 7600 port and allow guest user access
cp /app/rabbitmq.conf /etc/rabbitmq/rabbitmq.conf

rm -rf backendoutput.log || echon "No need to cleanup backendoutput"

# Restart Rabbit MQ to take new config 

service rabbitmq-server restart || echon "RabbitMQ is still not up"
rabbitmqctl status || echon "RabbitMQ is still not up"
