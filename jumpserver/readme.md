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

## 反向代理2222和其他终端链接端口(jumpserver与nginx(非docker部署)不为同一个)
在/etc/nginx/nginx.conf中添加如下内容：
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

若jumpserver和nginx(非docker部署)在同一个,则`nginx/conf.d/jumpserver.conf`中留下443的配置即可

## 参考资料
- [在 docker 环境下部署运行 JumpServer 堡垒机][1]

[1]: https://blog.51cto.com/u_15127669/3319781
