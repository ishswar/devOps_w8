#!/bin/bash

echon(){

	printf "\n$1\n"
}

# Stop and remove existing docker entries
echon *** Stop FileServer
docker stop backend > /dev/null

echon *** Remove FileServer container
docker rm backend > /dev/null

echon *** Remove FileServer image
docker rmi backend > /dev/null

# Build nameko service from Vagrant host
echon *** Build RabbitMQ and nameko service
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
echon *** Run backend service 
docker run -dit --restart unless-stopped --network host --name backend -p 7600:7600 -e BACKEND_IP=${BACKEND_IP} backend 

echon *** Listing Running docker containers
docker ps 

echon *** Will wait for container to initalized and then check on its logs 
sleep 20

docker logs backend

