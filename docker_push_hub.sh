#!/bin/bash
#Author- Amila
#login to docker hub with your docker hub user name and password for push my local docker image to dockerhub
docker login --username amila11111 --password-stdin

#build the python-web server docker image with docker-compose
docker-compose build

#run docker container with docker-compose
docker-compose up -d

#pushing my docker image to my docker hub account
docker push amila11111/python_http_server:1
