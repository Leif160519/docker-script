#!/usr/bin/env bash 
config_dir=`pwd`
docker run -d  --name jenkins\
     -p 80:8080 \
     -e TZ=Asia/Shanghai \
     --restart=always \
     -v ${config_dir}/jenkins.war:/root/jenkins.war \
     -v ${config_dir}/.jenkins:/root/.jenkins \
     java:8 \
     /usr/bin/java -Djava.awt.headless=true -Xms1024m -Xmx2048m -XX:PermSize=256m -XX:MaxPermSize=512m -jar /root/jenkins.war --webroot=/var/cache/jenkins/war --httpPort=8080
exit
