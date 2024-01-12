## 使用方法：
```
docker-compose up -d
```

然后进容器跑
```
docker exec it confluence bash
cd ../../
java -jar atlassian-agent.jar -d -m test@test.com -n test@test.com -p conf -o http://localhost:8090 -s <server id>
```

## 数据库配置
建议写jdbc的形式：
```
jdbc:mysql://mysql:3306/confluence?sessionVariables=transaction_isolation='READ-COMMITTED'
```
