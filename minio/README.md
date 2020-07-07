## minio [官方中文文档][1]

## 1.文件结构
```
minio-linux
├── cluster
│   ├── config.env                           # 环境变量配置文件
│   ├── docker-compose.yml                   # 单机器minio集群，4节点各4磁盘
│   └── nginx.conf                           # 单机器minio集群nginx配置
├── LICENSE
├── README.md
└── single
    └── docker-compose.yml                   # 单节点minio
```

## 2.使用prometheus监控minio
[官方文档][2]

- 1.为Prometheus指标配置身份验证类型
MinIO支持Prometheus `jwt`或两种身份验证模式`public`，默认情况下，MinIO在`jwt`模式下运行。要允许对普罗米修斯度量标准不进行身份验证就可以进行公共访问，请按如下所示设置环境。
```
export MINIO_PROMETHEUS_AUTH_TYPE="public"
```
配置之后重启minio服务

- 2.配置公共 Prometheus:
```
  - job_name: minio-job
    metrics_path: /minio/v2/metrics/cluster
    scheme: http
    static_configs:
    - targets: ['<minio_server>:9000']
```
若配置了SSL访问，则:
```
  - job_name: minio-job
    metrics_path: /minio/v2/metrics/cluster
    scheme: https
    static_configs:
    - targets: ['<minio_server>:9000']
    tls_config:
      insecure_skip_verify: true
```


- 3. 配置身份验证 Prometheus
若想使用身份验证的方式，则需要为mc生成的别名生成prometheus配置，使用如下命令
```
mc admin prometheus generate <alias>

scrape_configs:
- job_name: minio-job
  bearer_token: <secret>
  metrics_path: /minio/v2/metrics/cluster
  scheme: http
  static_configs:
  - targets: ['localhost:9000']
```

- 4.重新加载prometheus
```
systemctl reload prometheus
```

详细操作步骤和性能参数介绍请参看官方教程:[how-to-monitor-minio-using-prometheus][3]

- 5.Grafana添加监控模板
可以参考官方说明：[How to monitor MinIO server with Grafana][4]

注意：
图表导入后Grafana不会自动检测minio所对应的job名称，所以有两种方法来查看指标：

- 1.在`scrape_jobs`中手动填入job名称:`minio-job`,每次打开都需要重新输入很麻烦
- 2.修改图表，在图表的`Settings`->`Variables`->`scrape_jobs`->将`Type`从`Query`改成`Constant`并在下方Value中填写固定值`minio-job`，update即可

## 3.使用s3fs挂载minio对象存储

- 1.编辑docker-compose文件，挂载本机localtime文件保证容器与宿主机时间同步（时区不同步也会挂载失败）
```
volumes:
  - /etc/localtime:/etc/localtime

...
```

- 2.安装`s3fs-fuse`
```
# centos
yum -y install s3fs-fuse

# ubuntu
apt-get -y install s3fs
```

- 3.配置`.passwd-minio`
```
echo <MINIO_ACCESS_KEY>:<MINIO_SECRET_KEY> > .passwd-minio

# 注意修改文件权限为只读
chmod 600 .passwd-minio
```

- 4.去minio网页创建bucket

- 5.挂载文件系统
```
s3fs -o passwd_file=.passwd-minio -o use_path_request_style -o endpoint=us-east-1 -o url=http://<mionio_server>:9000 -o bucket=<bucket_name> <mount_dir>
```

> 参数解释：
- passed_file: 指定密码文件
- endpoint：节点，默认美国东一区
- url：minio服务端ip地址
- bucket：存储桶名称

参考：[使用s3fs-fuse 挂载minio s3 对象存储][8]

## 4.windows安装minio
- [Running MinIO as a service on Windows][9]

## 5.客户端上传文件到服务端(SSL)
- 安装mc客户端，下载地址:[mc][10]
- 安装minio服务端，下载地址:[minio][11]
- 启动服务端: `minio server /data` --console-address ":9001"
- 进入minio页面，新建bucket:`share`
- 指定存储桶的名称:`mc alias set s3 https://127.0.0.1:9000 minio minio123 --api s3v4`(SSL)
- 将minio的crt证书复制到mc下`cp ~/.minio/certs/public.crt ~/.mc/certs/CAs`(此步骤执行后无需在上一步设置`--insecure`)(SSL)
- 客户端复制文件到存储桶上:`mc cp --recursive --preserve <file_name> s3/share`

参考资料:
- [MinIO Client Complete Guide][12]
- [Can't get HTTPS connection to work #6822][13]


## 6.补充
签发带有ip信息的证书
1.修改`openssl.conf`
```
vim /etc/ssl/openssl.conf
···
[ v3_ca ]
subjectAltName = IP:<minio_server_ip>
···
```

2.保存后使用openssl命令自签证书
```
openssl genrsa -out private.key 2048
openssl req -new -x509 -days 3650 -key private.key -out public.crt -addext 'subjectAltName = IP:<minio_server_ip>' -subj "/C=US/ST=state/L=location/O=organization/CN=domain"
```

## 7.config.env参数解析

- [environment-variables][14]
- [active-directory-ldap-identity-management][15]
- [metrics-and-logging][16]
- [minio-disk-cache-guide][17]
- [Disk Caching Design][18]


| 变量名称 | 说明 |
|----------|------|
| MINIO_SERVER_URL | 指定minio控制台用于连接到minio服务器的url |
| MINIO_BROWSER_REDIRECT_URL | 指定minio控制台提供的对外访问的重定向url |
| MINIO_ROOT_USER | root用户的用户名 |
| MINIO_ROOT_PASSWORD | root用户的访问密钥|
| MINIO_IDENTITY_LDAP_SERVER_ADDR | 指定 Active Directory/LDAP 服务器的主机名 |
| MINIO_IDENTITY_LDAP_STS_EXPIRY | 设定回话过期时间 |
| MINIO_IDENTITY_LDAP_SERVER_STARTTLS | 指定on启用 到 AD/LDAP 服务器的StartTLS连接 |
| MINIO_IDENTITY_LDAP_SERVER_INSECURE | 指定on以允许与 AD/LDAP 服务器的不安全（非 TLS 加密）连接 |
| MINIO_IDENTITY_LDAP_LOOKUP_BIND_DN | 指定 MinIO 在查询 AD/LDAP 服务器时使用的 AD/LDAP 帐户的专有名称 (DN) |
| MINIO_IDENTITY_LDAP_LOOKUP_BIND_PASSWORD | 指定Lookup-Bind用户帐户的密码 |
| MINIO_IDENTITY_LDAP_USER_DN_SEARCH_FILTER | 指定在查询与身份验证客户端提供的用户凭据匹配的用户凭据时 MinIO 使用的 AD/LDAP 搜索过滤器 |
| MINIO_IDENTITY_LDAP_USER_DN_SEARCH_BASE_DN | 指定 MinIO 在查询与身份验证客户端提供的凭据匹配的用户凭据时使用的基本专有名称 (DN) |
| MINIO_IDENTITY_LDAP_GROUP_SEARCH_FILTER | 指定 AD/LDAP 搜索过滤器以对经过身份验证的用户执行组查找 |
| MINIO_IDENTITY_LDAP_GROUP_SEARCH_BASE_DN | 指定 MinIO 在执行组查找时使用的组搜索基础专有名称 |
| MINIO_PROMETHEUS_AUTH_TYPE | 指定 Prometheus抓取端点的身份验证模式 ||
| MINIO_PROMETHEUS_URL | 为抓取minio指标的prometheus服务的url ||
| MINIO_PROMETHEUS_JOB_ID | 指定抓取minio指标的自定义prometheus的job ID ||
| MINIO_CACHE | 设置为“on”或“off”开启或关闭缓存 |
| MINIO_CACHE_DRIVES | 挂载的缓存驱动器或目录列表，以“,”分隔 |
| MINIO_CACHE_EXPIRY | 缓存过期时间 |
| MINIO_CACHE_QUOTA | 缓存的最大允许使用百分比 (0-100) |
| MINIO_CACHE_EXCLUDE | 以“,”分隔的缓存排除模式列表 |
| MINIO_CACHE_AFTER | 缓存对象前的最小访问次数 |
| MINIO_CACHE_COMMENT | 设置为 'writeback' 或 'writethrough' 用于上传缓存 |
| MINIO_CACHE_RANGE | 设置为“on”或“off”缓存每个对象的独立范围请求，默认为“on” |
| MINIO_CACHE_WATERMARK_LOW | 缓存驱逐停止的缓存配额百分比 |
| MINIO_CACHE_WATERMARK_HIGH | 缓存驱逐开始时的缓存配额百分比 |

[1]:  https://docs.minio.io/cn/
[2]:  https://docs.minio.io/docs/how-to-monitor-minio-using-prometheus.html
[3]:  https://docs.minio.io/docs/how-to-monitor-minio-using-prometheus.html
[4]:  https://github.com/minio/minio/blob/master/docs/metrics/prometheus/grafana/README.md
[8]:  https://www.cnblogs.com/rongfengliang/p/10790072.html
[9]:  https://github.com/minio/minio-service/tree/master/windows
[10]: https://dl.min.io/client/mc/release/linux-amd64/mc
[11]: https://dl.min.io/server/minio/release/linux-amd64/minio
[12]: https://docs.min.io/cn/minio-client-complete-guide.html
[13]: https://github.com/minio/minio/issues/6822
[14]: https://docs.min.io/minio/baremetal/reference/minio-server/minio-server.html#environment-variables
[15]: https://docs.min.io/minio/baremetal/reference/minio-server/minio-server.html#active-directory-ldap-identity-management
[16]: https://docs.min.io/minio/baremetal/reference/minio-server/minio-server.html#metrics-and-logging
[17]: https://docs.min.io/docs/minio-disk-cache-guide.html
[18]: https://github.com/minio/minio/blob/master/docs/disk-caching/DESIGN.md
