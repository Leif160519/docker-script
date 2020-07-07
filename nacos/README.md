## docker 安装nacos-v2.0.4单节点和集群

## 文件结构
```
nacos
├── cluster
│   ├── docker-compose.yml
│   ├── nacos.conf            // nacos-app nginx配置文件
│   └── nacos.env             // nacos-app 环境变量
├── nacos-mysql.sql         // nacos-mysql 建库脚本
├── README.md
└── single
    ├── docker-compose.yml
    ├── mysql.env             // nacos-mysql 环境变量
    └── nacos.env             // nacos-app 环境变量
```

## 注意：
- nacos-mysql容器部署完成后，需删除容器中自带的nacos_config数据库，导入[nacos-mysql.sql][1]文件重新生成
- nacos集群至少三个节点，mysql只需要一个即可，可以使用单节点的docker-compose部署
- nacos访问地址：http://192.168.0.100:8848/nacos

## 如何暴露metrcs数据

```
docker exec -it nacos-app bash
vim /home/nacos/conf/application.properties

# 在最后一行添加
management.endpoints.web.exposure.include=*

# 重启nacos容器
docker restart nacos-app
```
[1]: https://raw.githubusercontent.com/alibaba/nacos/2.0.4/distribution/conf/nacos-mysql.sql
