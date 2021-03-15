## 一、注意
 > - 注意：sonarqube从7.9开始已经不支持mysql数据库了，7.8是最后一个版本（lts版本也是7.9的）
 > - 安装sonarqube比较占用cpu和内存资源，运行之前确保配置足够（建议四核，8GB内存以上）
 > - sonarqube汉化教程:[SonarQube基础：中文设定设定方法](https://blog.csdn.net/liumiaocn/article/details/103043922)
 > - 汉化包下载地址:[xuhuisheng/sonar-l10n-zh](https://github.com/xuhuisheng/sonar-l10n-zh/releases/)
 > - `docker-compose-mysql.yml`中的`sonar.jdbc.*`与`docker-compose-postgresql.yml`中的`SONARQUBE_JDBC_*`等效,两种写法都可以。

## 二、常见问题和解决方案
### 1
若docker日志中提示"max virtual memory areas vm.max_map_count [65530] is too low"这个错误，请将`/etc/sysctl.conf`配置文件的最后一行添加`vm.max_map_count=655360`之后使用`sysctl -p`命令生效。


### 2
sonarqube分析代码失败，提示`OutOfMemoryError:Java heap space`

对于代码亮巨大的项目来说，堆内存不足容易引起sonarqube分析失败，解决办法:

```
sed -i "s/^#sonar.ce.javaOpts=/csonar.ce.javaOpts=-Xmx3036m -Xms1024m -XX:+HeapDumpOnOutOfMemoryError/g" /opt/sonarqube/conf/sonar.properties
```

参考:[Sonar问题解决：OutOfMemoryError:Java heap space(linux)](https://zhuanlan.zhihu.com/p/128500015)

### 3
若使用的是mysql作为sonarqube的数据存储，在分析后失败，报错`outofmemory`的，一般是sql语句的字节数超过了mysql的限制导致的，建议在mysql的配置文件中改大`max_allowed_packet`的值即可解决。

## 三、Supported tags and respective Dockerfile links(2021-03-15)

- 7.9.6-community, 7.9-community, lts
- 8.7.1-community, 8.7-community, 8-community, community, latest
- 8.7.1-developer, 8.7-developer, 8-developer, developer
- 8.7.1-enterprise, 8.7-enterprise, 8-enterprise, enterprise
- 8.7.1-datacenter-app, 8.7-datacenter-app, 8-datacenter-app, datacenter-app
- 8.7.1-datacenter-search, 8.7-datacenter-search, 8-datacenter-search, datacenter-search

## 四、补充插件

- [SonarQube社区版分支插件V1.3.0更新](https://cloud.tencent.com/developer/article/1624836)
