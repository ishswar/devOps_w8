#!/bin/bash

cat << EOF

"##########################################"
"##########################################"
"Starting Back-End"
"##########################################"
"##########################################"

EOF

echon(){

	printf "\n$1\n"
}

echon "Will restart RabbitMQ in 10 seconds "
sleep 10

service rabbitmq-server restart || echo "RabbitMQ is still not up"

echon " Checking RabbitMQ status"
rabbitmqctl status || echo "RabbitMQ is still not up"

echon "About to start nameko service"
# Start Backend Micro service 
nameko run --config config.yml BackEnd > backendoutput.log 2>&1 &

echon "Done starting nameko service"

echon "nameko process"
ps -ef | grep nameko 

echon "Port listing"
netstat -aon | grep 7600

echon "Tailing the output"

tail -f backendoutput.log