#!/usr/bin/env bash 
config_dir=`pwd`
PASSWORD=root
docker run -d  --name mysql\
     -p 3306:3306 \
     -e MYSQL_ROOT_PASSWORD=$PASSWORD \
     -e TZ=Asia/Shanghai \
     --restart=always \
     -v ${config_dir}/mysqld.cnf:/etc/mysql/mysql.conf.d/mysqld.cnf \
     mysql:5.7.28
exit
