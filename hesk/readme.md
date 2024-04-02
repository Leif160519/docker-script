## 说明
1.目录结构
```
hesk
├── docker-compose.yml
├── Dockerfile
├── hesk345.zip
├── mysql
│   └── conf
│       └── my.cnf
├── readme.md
└── zh_cmn_hans.zip
```

- hesk345.zip: hesk免费版安装包
- zh_cmn_hans.zip: hesk中文汉化包
- my.cnf: mysql数据库配置文件

## 使用方法
```
docker-compose up -d
```

## 运行效果
```
f23cd7f3c911        hesk_hesk-app                                              "/usr/sbin/httpd -..."   3 minutes ago       Up 3 minutes (healthy)       0.0.0.0:8999->80/tcp                       hesk-app
6f94f5828143        mysql:5.7.28                                               "docker-entrypoint..."   About an hour ago   Up About an hour (healthy)   33060/tcp, 0.0.0.0:32773->3306/tcp         hesk-mysql
```

## 参考资料
- [安装部署一套免费的HESK服务台工单系统][1]
- [Download Free Help Desk Software][2]
- [Hesk Chinese Simplified][3]

[1]: https://blog.csdn.net/Junson142099/article/details/112945887
[2]: https://www.hesk.com/download.php
[3]: https://www.hesk.com/language/info.php?tag=zh_cmn_hans
