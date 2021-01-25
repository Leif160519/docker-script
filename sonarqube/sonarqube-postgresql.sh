#!/usr/bin/env bash
docker run -d  --name postgresql\
     -e TZ=Asia/Shanghai \
     --restart=always \
     -e POSTGRES_USER=sonar \
     -e POSTGRES_PASSWORD=sonar \
     -e POSTGRES_DB=sonar \
     postgres:10

docker run -d  --name sonarqube\
     -p 9000:9000 \
     -e TZ=Asia/Shanghai \
     --restart=always \
     --link postgresql \
     -e sonar.jdbc.url="jdbc:postgresql://postgresql:5432/sonar" \
     sonarqube:lts
exit
