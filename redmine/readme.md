## 初始账户
浏览器访问http://127.0.0.1:8080
admin:admin

## 参考
https://blog.csdn.net/weixin_42257277/article/details/107508274

## 注意
若要实现https，则nginx配置如下：
```
server {
    listen 80;
    server_name redmine.example.com;
    return 301 https://$server_name$request_uri;
}
server {
    listen 443 ssl;
    server_name redmine.example.com;
    ssl_certificate      /etc/nginx/ssl/example.com.crt;
    ssl_certificate_key  /etc/nginx/ssl/example.com.key;

    location / {
        proxy_pass http://127.0.0.1:8080;
        access_log    /var/log/nginx/redmine.example.com.access.log;
        error_log     /var/log/nginx/redmine.example.com.error.log;
        client_max_body_size 100m;
        #下面这一步一定要加上端口号，否则如果使用非443端口，网站在ajax请求之后会跳转到错误的页面(会不带端口号)
        proxy_set_header Host $host:$server_port;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header REMOTE-HOST $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_redirect http:// https://;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $http_connection;
        proxy_http_version 1.1;
        #下面这一行配置也要加上，否则ajax请求之后会跳转到错误的页面(https会变成http)
        proxy_set_header X-Forwarded-Proto $scheme;
        index index.html index.htm;
    }
}
```
> 若nginx为容器，则127.0.0.1修改成redmine即可
