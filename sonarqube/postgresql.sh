#!/usr/bin/env bash 
docker run -d  --name postgresql\
     -e TZ=Asia/Shanghai \
     --restart=always \
     -e POSTGRES_USER=sonar \
     -e POSTGRES_PASSWORD=sonar \
     -e POSTGRE_DB=sonar \
     postgres:10
exit
