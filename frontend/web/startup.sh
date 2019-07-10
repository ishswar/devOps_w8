#!/bin/bash

echon(){

	printf "\n$1\n"
}

cat << EOF

"##########################################"
"##########################################"
"Starting Fron-End"
"##########################################"
"##########################################"

EOF

until nc -z ${BACKEND_IP} ${RABBIT_PORT}; do
    echo "$(date) - waiting for rabbitmq..."
    sleep 2
done

nameko run --config /app/config.yml FrontEnd  > frontend.log 2>&1 &

echon "Done starting nameko service"

echon "nameko process"
ps -ef | grep nameko 

echon "Tailing the output"

tail -f frontend.log