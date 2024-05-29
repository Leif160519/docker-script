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

## 其他
若备份的路径中是非`/`下的挂载路径，则backuppc会默认不备份，需要修改rsync参数：
打开backuppc首页=左手边选择“修改服务器配置”-切换到“传输”选项卡-在`RsyncArgs`选项中删除`--one-file-system`参数-点击”保存“

官方文档解释：`http:<backuppc-server>:<backuppc-port>/BackupPC_Admin?action=view&type=docs#_conf_rsyncsharename_`
```
$Conf{RsyncShareName} = '/';
Share name to backup. For $Conf{XferMethod} = "rsync" this should be a file system path, eg '/' or '/home'.

For $Conf{XferMethod} = "rsyncd" this should be the name of the module to backup (ie: the name from /etc/rsynd.conf).

This can also be a list of multiple file system paths or modules. For example, by adding --one-file-system to $Conf{RsyncArgs} you can backup each file system separately, which makes restoring one bad file system easier. In this case you would list all of the mount points:

    $Conf{RsyncShareName} = ['/', '/var', '/data', '/boot'];
```

中文对照：
```
$Conf{RsyncShareName} = '/';
共享名称以进行备份。对于$Conf{XferMethod} = "rsync"，这应该是文件系统路径，例如“/”或“/home”。

对于$Conf{XferMethod} = "rsyncd"，这应该是要备份的模块的名称（即：/etc/rsynd.conf 中的名称）。

这也可以是多个文件系统路径或模块的列表。例如，通过将 --one-file-system 添加到$Conf{RsyncArgs}中，您可以单独备份每个文件系统，这使得恢复一个损坏的文件系统变得更加容易。在这种情况下，您将列出所有安装点：

    $Conf{RsyncShareName} = ['/', '/var', '/data', '/boot'];
```

文新一言中关于`--one-file-system`的解释
```
Q:rsync参数--one-file-system的含义

A:rsync 是一个用于在本地和远程文件系统之间同步文件和目录的工具。--one-file-system 是 rsync 的一个参数，其意义如下：

当使用 --one-file-system 参数时，rsync 只会复制与指定源目录位于同一文件系统上的文件和目录。换句话说，它不会跨文件系统边界复制数据。

举个例子，如果你有一个挂载点（如 /mnt/data），并且该挂载点指向一个与根文件系统（/）不同的文件系统，那么当你尝试使用 rsync 复制 / 目录时，如果不使用 --one-file-system 参数，rsync 会尝试复制 /mnt/data 下的内容（如果它存在的话）。但是，如果你使用了 --one-file-system 参数，那么 /mnt/data 下的内容将不会被复制，因为 /mnt/data 是在一个与 / 不同的文件系统上。

这个参数在某些情况下可能很有用，特别是当你只想复制特定文件系统上的数据时，或者当你不想复制可能包含大量数据的挂载点时。但请注意，这可能会导致数据不完整，特别是如果某些重要的数据存储在挂载点上时。因此，在使用此参数之前，请确保你了解它的影响。
```

[1]: https://hub.docker.com/r/adferrand/backuppc
[2]: https://github.com/backuppc/backuppc/issues/462
[3]: https://github.com/backuppc/backuppc/blob/master/lib/BackupPC/CGI/Metrics.pm
