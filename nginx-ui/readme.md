## 用法
```
git clone https://github.com/0xJacky/nginx-ui.git
docker-compose up -d
```

## 访问
浏览器打开`http://<nginx-ui-server>:9000`

## 参考
- [推荐一个非常牛皮的nginx图形管理项目][1]
- [0xJacky/nginx-ui][2]

## 配置说明
- web界面中，nginx日志-访问日志/错误日志若无法显示日志，则需要在`app.ini`中修改如下配置：
```
LogDirWhiteList = /var/log/nginx # 添加nginx日志目录
```

> 参考：[config-nginx.md][3]

## 注意点
- 若`nginx.conf`中包含`include /etc/nginx/modules-enabled/*.conf;`内容，请删除或者拷贝一份删除这段内容并挂载到`nginx-ui`容器中
- 由于[config-nginx.md][3]中提到
`Nginx UI 遵循 Debian 的网页服务器配置文件标准。创建的网站配置文件将会放置于 Nginx 配置文件夹（自动检测）下的 sites-available 中，启用后的网站将会创建一份配置文件软连接到 sites-enabled 文件夹`,
所以docker-compose中需要将宿主机的`sites-enabled`挂载到`nginx-ui`容器的`sites-available`中，否则`网站管理`-`站点列表`中将显示不全所有nginx配置，所以docker-compose需要如下调整
```
version: "3"
services:
  nginx-ui:
    image: uozi/nginx-ui:latest
    container_name: nginx-ui
    hostname: nginx-ui
    restart: always
    volumes:
      - /etc/localtime:/etc/localtime
      - /etc/nginx/sites-enabled:/etc/nginx/sites-available  # 将宿主机的所有配置文件挂载到容器的对应目录中，方便识别
      - /etc/nginx/conf.d:/etc/nginx/conf.d
      - /var/log/nginx:/var/log/nginx                        # 将宿主机的日志目录挂载进容器中
      - ./nginx-ui:/etc/nginx-ui                             # 将nginx-ui前端资源挂载进容器中
      - ./nginx.conf:/etc/nginx/nginx.conf                   # 将修改后的nginx.conf文件挂载进容器中，防止宿主机的部分模块在容器中无法加载而报错
    ports:
      - 8080:80
      - 8443:443
      - 9000:9000
```

[1]: https://mp.weixin.qq.com/s/P1QsPd_SXNJH-atvRS1ltg
[2]: https://github.com/0xJacky/nginx-ui
[3]: https://github.com/0xJacky/nginx-ui/blob/96cff98c66deba24a20fdde4c6722896f3617680/docs/zh_CN/guide/config-nginx.md
