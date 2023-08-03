## zabbix提示agent not avaliable
- 1.查询zabbix-agent容器的ip地址
```
docker exec -it zabbix-agent cat /etc/hosts
```

> 最后一行就是容器的ip地址

- 2.修改agent主机的IP地址
登录zabbix->配置->主机->Zabbix server->将客户端后面的ip地址改为zabbix-agent的容器ip地址->更新

> 要是嫌麻烦，可以修改docker-compose，将每一个容器的网络类型改为host,再将mysql-server和zabbix-server的地址都替换为127.0.0.1

## zabbix默认账户密码
Admin:zabbix
