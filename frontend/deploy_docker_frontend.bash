#!/bin/bash

BACKEND_IP=$1

# Stop and remove existing docker entries

echo *** Stopping ws container
docker stop ws > /dev/null

echo *** Removig ws container
docker rm ws > /dev/null

echo *** Removig ws docker image
docker rmi ws > /dev/null


export BACKEND_IP=$1
export RABBIT_PORT=$2

cat << EOF

"##########################################"
"Starting Docker Container with BACKEND_IP as ${BACKEND_IP} , Rabbit MQ port ${RABBIT_PORT} , input argument is $1"
"##########################################"

EOF

# Build ws client from inside Vagrant host
echo *** Build ws client
cd /vagrant/web
docker build . -t ws

# Start docker ws service in background as ws
echo *** Run ws client and map to port 80 on Vagrant host
docker run -dit --restart unless-stopped --name ws -p 80:8000 -e BACKEND_IP=${BACKEND_IP} -e RABBIT_PORT=${RABBIT_PORT} ws

echo *** Will wait for container to initalized and then check on its logs 
sleep 20

docker logs ws

