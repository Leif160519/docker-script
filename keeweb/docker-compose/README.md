# 功能包含
- webdav服务(可上传和下载)
- nginx服务(只能下载kdbx文件)

# 文件结构
```
keeweb
├── docker-compose.yml                // docker-compose 配置文件
├── keeweb.conf                       // nginx配置文件
├── keeweb.json                       // keeweb配置文件
├── nginx.conf                        // nginx主配置文件
├── ssl                               // ssl证书目录
│   ├── cert.pem
│   └── key.pem
├── user.passwd                       // keeweb登录身份验证文件
└── webdav
    └── demo.kdbx                     // keeweb加密文件
```
# keeweb前后端的安装
```
docker-compose -f docker-compose.yml up -d
```

# keeweb的使用
使用方法可以参照[知乎教程](https://zhuanlan.zhihu.com/p/99928513)

# 增加keeweb的安全性
可以在打开keeweb的界面的同时要求用户登录并制定配置文件:
在`keeweb.conf`的`location /`下添加认证配置：
```
auth_basic "Access limited";
auth_basic_user_file /etc/nginx/user.passwd;
```
其中，user.passwd文件可以通过以下命令生成:
```
echo "用户名:$(openssl passwd 密码)" >/etc/nginx/user.passwd
```

`keeweb.json`内容可以参考本项目文件，内容可定义keeweb使用的主题，kdbx的webdav路径等

> 实例中的用户名为keeweb，密码为keeweb-123

> 制定配置文件访问kdbx文件url:`https://192.168.124.128:8443/?config=/keeweb.json`

# 疑难解答
## 1.若webdav在同步时出现500错误，请保证`nginx.conf`的用户为`root`
```
user  root;
worker_processes  auto;

error_log /dev/stdout info;
daemon off;
pid        /var/run/nginx.pid;
·······
```
## 2.新创建的kdbx文件无法以webdev的方式保存
将kdbx导入到服务器，之后再以webdev的方式打开即可

## 3.设置webdav之后，无法保存，提示403
在存储部分，将`上传一个临时文件并移动`改为`已PUT方式覆盖文件`即可

## 4.配置https://127.0.0.1:8444/webdav/xxx.kdbx是提示network error
是nginx跨域了，按照keeweb.conf中444的配置添加跨域请求头即可
