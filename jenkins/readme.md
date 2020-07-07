## systemctl管理的jenkins服务启动配置
```
# /lib/systemd/system/jenkins.service
[Unit]
Description=Jenkins Continuous Integration Server
Requires=network.target
After=network.target

[Service]
Type=notify
NotifyAccess=main
Restart=on-failure
SuccessExitStatus=143
User=root
Group=root
WorkingDirectory=/data/jenkins
Environment="JENKINS_HOME=/data/jenkins/jenkins_home"
Environment="JENKINS_WAR=/data/jenkins/jenkins.war"
Environment="JENKINS_LOG=/data/jenkins/jenkins.log"
Environment="JENKINS_WEBROOT=/data/jenkins/jenkins_home/war"
Environment="JENKINS_PORT=8080"
Environment="JAVA_OPTS=-Duser.home=${JENKINS_HOME} -Djava.awt.headless=true -Dfile.encoding=UTF-8"
Environment="JENKINS_ARGS=--webroot=${JENKINS_WEBROOT} --httpPort=${JENKINS_PORT} --sessionTimeout=1440 --sessionEviction=1440 --logfile=${JENKINS_LOG}"
ExecStart=/bin/bash -c "/usr/bin/java ${JAVA_OPTS} -jar ${JENKINS_WAR} ${JENKINS_ARGS}"

[Install]
WantedBy=multi-user.target
```
