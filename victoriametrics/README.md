## Docker部署victoriametrics

- prometheus数据持久化,默认数据保留1个月，修改保留时间请修改`retentionPeriod`后面的数值
- `vmalert.proxyURL`后跟prometheus服务器的地址

## 参考
- [dockerhub](https://hub.docker.com/r/victoriametrics/victoria-metrics)
- [Configure Prometheus and Grafana](https://docs.victoriametrics.com/#operation)
- [github](https://github.com/VictoriaMetrics/VictoriaMetrics)
