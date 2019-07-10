#!/bin/sh

set -e 

cat << EOF

"#####################################################"
"Install prerequisite"
"#####################################################"

EOF

apt-get update -y && apt-get install wget apt-transport-https nano net-tools netcat -y

cat << EOF

"##########################################"
"Installing PIP and then nameko "
"##########################################"

EOF

apt-get install python-pip -y && pip install nameko
