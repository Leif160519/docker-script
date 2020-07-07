# 注意事项
1.此脚本适用于已经安装了docker的机器上。

## jenkins
使用本地jenkins.war包并挂载进docker中(war需自行官网下载)，默认占用8080端口

## mysql
默认`root`密码为`root`，并且将配置文件也挂载了出来

## sonarqube

提供了两种数据库安装方式，不过sonarqube的版本不一样，注意区分
