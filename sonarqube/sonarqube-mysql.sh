#!/usr/bin/env bash
docker run -d --name mysql\
     -e MYSQL_USER=sonar \
     -e MYSQL_PASSWORD=sonar \
     -e MYSQL_ROOT_PASSWORD=root \
     -e MYSQL_DATABASE=sonar \
     -e TZ=Asia/Shanghai \
     --restart=always \
     mysql:5.7.28

docker run -d --name sonarqube\
     -p 9000:9000 \
     -e TZ=Asia/Shanghai \
     --restart=always \
     --link mysql \
     -e sonar.jdbc.url="jdbc:mysql://mysql:3306/sonar?useUnicode=true&characterEncoding=utf8" \
     sonarqube:7.8-community
exit
