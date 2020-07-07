## 前期准备
在宿主机创建backuppc用户和组
```
groupadd backuppc
useradd -m backuppc -s /bin/bash -d /home/backuppc -g backuppc
usermod -u 1000 backuppc
groupmod -g 1000 backuppc
```
## 将backuppc的英文界面改成中文
在启动容器之后，修改`/etc/backuppc/config.pl`,将`$Conf{Language} = 'cn';`改为`$Conf{Language} = 'zh_CN';`之后重启容器即可

## 访问
浏览器打开`http://<backuppc-server>:8080` 使用用户名`backuppc`和密码`backuppc`即可登录

## 参考
[docker-hub][1]

## 补充
若因为目标主机无法ping而导致的backuppc无法进行备份任务，可在`修改服务器配置`中将默认的`PingCmd`命令替换为`/bin/echo`保存设置即可

## 已知问题
backuppc 的prometheus中关于`backuppc_hosts_full_keep_count`指标采取失败
去github上下载[Metrics.pm][3]文件并使用如下命令替换和重启服务即可
```
docker cp Metrics.pm backuppc:/usr/local/BackupPC/lib/BackupPC/CGI/Metrics.pm
docker restart backuppc
```

- [[BUG] Prometheus exporter is wrong when array is used in configuration for FullKeepCnt #462][2]

[1]: https://hub.docker.com/r/adferrand/backuppc
[2]: https://github.com/backuppc/backuppc/issues/462
[3]: https://github.com/backuppc/backuppc/blob/master/lib/BackupPC/CGI/Metrics.pm
