## 文件说明
- docker-compose.yml 容器配置文件
- nginx/conf.d/jumpserver.conf jumpserver反向代理配置文件

## 准备工作
### ~~创建jumpserver数据库~~
```
docker exec -it mysql bash
mysql -u root -p123456
create database jumpserver;
```
### 生成密钥
若有重建容器、升级容器，需要继承之前的使用系统配置数据的需要，则必须使用之前创建的密钥，否则原有数据将无法解密。
```
# 生成 SECRET_KEY
if [ "$SECRET_KEY" = "" ];then
    SECRET_KEY=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 50`
    echo "SECRET_KEY=$SECRET_KEY" >> ~/.bashrc
    echo $SECRET_KEY; else echo $SECRET_KEY
fi

# 生成 BOOTSTRAP_TOKEN
if [ "$BOOTSTRAP_TOKEN" = "" ];then
    BOOTSTRAP_TOKEN=`cat /dev/urandom | tr -dc A-Za-z0-9 | head -c 16`
    echo "BOOTSTRAP_TOKEN=$BOOTSTRAP_TOKEN" >> ~/.bashrc
    echo $BOOTSTRAP_TOKEN; else echo $BOOTSTRAP_TOKEN
fi
```

## 反向代理2222和其他终端链接端口
### jumpserver(docker部署)与nginx(非docker部署)不在同一台机器上

1.在nginx服务器上的/etc/nginx/nginx.conf中添加如下内容：
```
stream {
    server {
        listen 2222;
        proxy_pass 10.200.0.230:2222;
    }
    server {
        listen 33060;
        proxy_pass 10.200.0.230:33060;
    }
    server {
        listen 33061;
        proxy_pass 10.200.0.230:33061;
    }
    server {
        listen 54320;
        proxy_pass 10.200.0.230:54320;
    }
    server {
        listen 63790;
        proxy_pass 10.200.0.230:63790;
    }
    server {
        listen 15211;
        proxy_pass 10.200.0.230:15211;
    }
    server {
        listen 15212;
        proxy_pass 10.200.0.230:15212;
    }
}
```

2.将nginx/conf.d/jumpserver.conf文件拷贝到nginx服务器的/etc/nginx/conf.d下，并修改proxy_pass后的ip地址和访问域名

> 10.200.0.230修改为实际ip地址

### jumpserver(docker部署)和nginx(非docker部署)在同一台机器上

1.docker-compose.yml的web部分添加如下内容
```
...
    volumes:
      - /etc/localtime:/etc/localtime:rw
      - ./core/data:/opt/jumpserver/data
      - ./nginx/data/logs:/var/log/nginx
      - ./nginx/conf.d/jumpserver.conf:/etc/nginx/conf.d/jumpserver.conf  # 挂载jumpserver域名反向代理配置
      - ./nginx/ssl:/etc/nginx/ssl                                        # 挂载ssl证书目录
    ports:
      - 80:80
      - 443:443                                                           # 添加443端口暴露
...
```

`nginx/conf.d/jumpserver.conf`中留下443的配置即可
```
server {
    listen 443 ssl;
    server_name jumpserver.example.com;

    ssl_certificate  /etc/nginx/ssl/example.com.crt;
    ssl_certificate_key  /etc/nginx/ssl/example.com.key;

    client_max_body_size 24M;
    client_body_buffer_size 128k;
    client_header_buffer_size 5120k;
    large_client_header_buffers 16 5120k;

    location / {
#        proxy_redirect off;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "Upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_connect_timeout       600;
        proxy_send_timeout          600;
        proxy_read_timeout          600;
        send_timeout                600;
        proxy_pass http://127.0.0.1:80;
    }

    access_log /var/log/nginx/jumpserver.example.com.log;
    error_log  /var/log/nginx/jumpserver.example.com.log;
}
```

> 此方法无法实现301重定向功能，除非直接进入jms_web容器，在/etc/nginx/conf.d/default.conf中80端口部分添加301重定向配置

## 参考资料
- [在 docker 环境下部署运行 JumpServer 堡垒机][1]

[1]: https://blog.51cto.com/u_15127669/3319781
