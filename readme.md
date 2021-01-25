# 注意事项
1.此脚本适用于已经安装了docker的机器上。

## jenkins
使用本地jenkins.war包并挂载进docker中(war需自行官网下载)，默认占用8080端口

## mysql
默认`root`密码为`root`，并且将配置文件也挂载了出来

## sonarqube

提供了两种数据库安装方式，不过sonarqube的版本不一样，注意区分

若docker日志中提示"max virtual memory areas vm.max_map_count [65530] is too low"这个错误，请将`/etc/sysctl.conf`配置文件的最后一行添加`vm.max_map_count=655360`之后使用`sysctl -p`命令生效。

> - 注意：sonarqube从7.9开始已经不支持mysql数据库了，7.8是最后一个版本（lts版本也是7.9的）
> - 安装sonarqube比较占用cpu和内存资源，运行之前确保配置足够（建议四核，8GB内存以上）
> - sonarqube汉化教程:[SonarQube基础：中文设定设定方法](https://blog.csdn.net/liumiaocn/article/details/103043922)
> - 汉化包下载地址:[xuhuisheng/sonar-l10n-zh](https://github.com/xuhuisheng/sonar-l10n-zh/releases/)
> - `docker-compose-mysql.yml`中的`sonar.jdbc.*`与`docker-compose-postgresql.yml`中的`SONARQUBE_JDBC_*`等效,两种写法都可以。
