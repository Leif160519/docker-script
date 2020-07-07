#!/usr/bin/env bash 
config_dir=`pwd`
docker run -d  --name jenkins\
     -p 8080:8080 \
     -e TZ=Asia/Shanghai \
     --restart=always \
     -v ${config_dir}/jenkins.war:/root/jenkins.war \
     -v ${config_dir}/.jenkins:/root/.jenkins \
     java:8 \
     /usr/bin/java -jar /root/jenkins.war --httpPort=8080
exit
