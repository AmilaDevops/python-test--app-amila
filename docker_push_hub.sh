#!/bin/bash
#Author- Amila
#login to docker hub with your docker hub user name and password for push my local docker image to dockerhub
docker login --username amila11111 --password-stdin

#pushing my docker image to my docker hub account
docker push amila11111/python_http_server:1
