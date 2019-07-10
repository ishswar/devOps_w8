# Use ubuntu
FROM ubuntu:16.04

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

RUN ["chmod", "+x", "./provision.sh"]
RUN ["chmod", "+x", "./startup.sh"]

# Install psutils
RUN ./provision.sh

CMD bash /app/startup.sh

#docker run -it --network host --name backend --rm -p 7600:7600 backend service rabbitmq-server restart && /bin/bash

