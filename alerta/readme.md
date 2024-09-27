## 用法
```
docker-compose up -d
docker-compose ps -a
```

## 访问
浏览器访问http://127.0.0.1:9080
用户名：admin@alerta.io
密码：alerta

## prometheus配置
```
  - job_name: alerta
    metrics_path: /api/management/metrics
    static_configs:
    - targets:
      - 10.10.1.216:9080
    basic_auth:
      username: admin@alerta.io
      password: alerta
```

## alertmanager配置
```
    webhook_configs:
      - url: 'http://10.10.1.216:9080/api/webhooks/prometheus'
        send_resolved: true
        http_config:
          basic_auth:
            username: admin@alerta.io
            password: alerta
```

## 注意
如果alerta-web是docker部署，但是prometheus和alertmanager是非docker环境部署的，alerta-web可能会报一下警告内容
```
2024-09-27 03:19:28,833 alerta.plugins[1514]: [WARNING] [POLICY] Alert environment does not match one of Production, Development request_id=7f80f938-d271-4bb1-b819-b3ba029a36c5 ip=10.10.1.216
```
这时候只需要把alerta-web中的插件`reject`去掉，重新运行alerta-web容器即可

> 参考:[[POLICY] Alert environment must be one of Production, Development #106][2]

## 参考
- [docker-alerta][1]

[1]: https://github.com/alerta/docker-alerta
[2]: https://github.com/alerta/alerta/issues/106
