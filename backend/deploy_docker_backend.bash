#!/bin/bash

# Stop and remove existing docker entries
echo *** Stop webserver
docker stop backend > /dev/null

echo *** Remove webserver image
docker rm backend > /dev/null

# Build nameko service from Vagrant host
echo *** Build RabbitMQ and nameko service
cd /vagrant/backend
docker build . --network host --rm -t backend 

docker images 

export BACKEND_IP=$1

cat << EOF

"##########################################"
"Starting Docker Container with BACKEND_IP as ${BACKEND_IP} , input argument is $1"
"##########################################"

EOF

# Start docker backend. The http server uses the nameko framework which runs on port 8000. Map this to port 80 on the Vagrant host
echo *** Run backend service 
docker run --rm -d --network host --name backend -p 7600:7600 -e BACKEND_IP=${BACKEND_IP} backend 

echo *** Will wait for container to initalized and then check on its logs 
sleep 20

docker logs backend

