apt update
apt install default-jdk -y
groupadd tomcat
useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
mkdir -p /opt/tomcat
cd /opt/tomcat
curl -O http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.8/bin/apache-tomcat-8.5.8.tar.gz
tar xzvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
chgrp -R tomcat /opt/tomcat
chmod -R g+r conf
chmod g+x conf
chown -R tomcat webapps/ work/ temp/ logs/
cat >/etc/systemd/system/tomcat.service <<EOL
[Unit]
Description=Apache Tomcat Web Application Container
After=network.target

[Service]
Type=forking

Environment=JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat
Environment=CATALINA_BASE=/opt/tomcat
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC'
Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom'

ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh

User=tomcat
Group=tomcat
UMask=0007
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
EOL
chmod -R g+w /opt/tomcat
usermod -a -G tomcat ubuntu

systemctl daemon-reload
systemctl start tomcat

if [ -e /root/SampleWebApplication.war ]; then
    mv /root/SampleWebApplication.war /opt/tomcat/webapps/
fi