#!/usr/bin/env bash 
docker run -d  --name sonarqube\
     -p 9000:9000 \
     -e TZ=Asia/Shanghai \
     --restart=always \
     --link postgresql \
     -e sonar.jdbc.url="jdbc:postgresql://postgresql:5432/sonar" \
     sonarqube:lts
exit
