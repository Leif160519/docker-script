## 集群搭建方式
```
mkdir {elk-1,elk-2,elk-3}/{data,logs} -p
chown 1000:1000 -R .
docker-compose -f docker-compose-cluster.yml up -d
```

## 单节点搭建方式
```
mkdir {data,logs} -p
chown 1000:1000 -R .
docker-compose -f docker-compose-single.yml up -d
```

## 集群添加身份验证
在elasticsearch下添加如下环境变量参数开启身份验证
```
      - xpack.security.enabled=true
      - ELASTIC_PASSWORD=123456
```
在kibana下添加如下环境变量参数指定es集群的账户信息
```
      - ELASTICSEARCH_USERNAME=elastic
      - ELASTICSEARCH_PASSWORD=123456
```
添加完成之后重启es和kibaba的容器
```
docker-compose -f docker-compose-single.yml/docker-compose-cluster.yml up -d
```

## 集群状态查询
### 查看集群信息
- 1.集群健康状态：
使用_cluster/health端点可以获取集群的健康状态，例如：
```
curl -XGET "http://ip:port/_cluster/health?pretty"
```
> 其中ip:port是Elasticsearch集群中任一节点的IP地址和端口号。pretty参数用于美化输出格式，使其更易于阅读。

- 2.集群统计信息：
使用_cluster/stats端点可以获取集群的详细统计信息，包括节点、索引、文档计数等1。

- 3.集群设置：
使用_cluster/settings端点可以查询集群的当前设置。

### 查看节点信息
- 1.所有节点信息：
使用_cat/nodes端点可以查看集群中所有节点的信息，包括节点ID、IP地址、堆内存使用情况等。可以添加?v参数以表格形式显示输出：
```
curl -XGET "http://ip:port/_cat/nodes?v"
```

- 2.指定节点信息：
如果只想查看特定节点的详细信息，可以使用_nodes端点并指定节点名称或ID，例如：
```
curl -XGET "http://ip:port/_nodes/nodeName?pretty=true"
```
> 注意，这里的nodeName需要替换为实际的节点名称6。

- 3.分片分配信息：
使用_cat/allocation端点可以查看集群中分片的分配情况，包括哪些分片分配到了哪些节点上。

### 其他常用命令
- 查看所有索引信息：使用_cat/indices端点。
- 查看分片信息：使用_cat/shards端点。
- 查看别名信息：使用_cat/aliases端点。
- 查看当前集群等待任务：使用_cat/pending_tasks端点。

## Kibana切换中文语言
在kibana.yml文件中配置

vim /opt/kibana/config/kibana.yml
再最后面加上一句配置
```
i18n.locale: "zh-CN"
```

然后保存重启 Kibana 服务
