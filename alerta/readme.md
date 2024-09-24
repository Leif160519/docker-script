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

## 参考
- [docker-alerta][1]

[1]: https://github.com/alerta/docker-alerta
