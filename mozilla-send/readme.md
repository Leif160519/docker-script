## docker安装mozilla send文件共享

## 准备工作
- 1.提前安装nginx,docker,docker-compose和redis服务，redis配置参考`redis.conf`(nginx,redis都可以用容器)
- 2.将docker-compose.yml中的`REDIS_HOST`改为真实的redis地址，若为本机安装的redis，则改成本机ip(redis的bind_ip改为0.0.0.0)，若docker的网络设置为host，则直接用`localhost`
- 3.将send.conf中的`server_name`改为访问的域名或者ip，ssl部分替换正确的证书地址，`proxy_pass`也依据实际情况修改正确的服务地址
- 4.若想提高传输的单个文件大小，请修改`ANON_MAX_FILE_SIZE`大小，单位为字节，默认5G

## 注意事项
- mozilla-send不支持带有密码的redis
