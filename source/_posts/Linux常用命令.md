---
title: Linux常用命令
date: 2024-11-20 17:18:47
tags:
---
### 安装JDK

- 检查是否已安装

```bash
[root@localhost ~]# java -version
```

- yum方法

```shell
# 获取 jdk 列表
# 选择带-devel的版本，不带的是jre
[root@localhost ~]# yum -y list java*
[root@localhost ~]# yum install -y java-1.8.0-openjdk-devel.x86_64
```

```bash
# 卸载
[root@localhost ~]# yum list installed | grep java
[root@localhost ~]# yum -y remove java-1.8.0*
[root@localhost ~]# yum -y remove tzdata-java.noarch
[root@localhost ~]# yum -y remove javapackages-tools.noarch
```

- 压缩包方法

```bash
# 解压JDK到指定的目录，如果不存在请建立该目录：/usr/lib/jvm
[root@localhost ~]# tar -xvf jdk-8u131-linux-x64.tar.gz -C /usr/lib/jvm
# 修改环境变量
[root@localhost ~]# vim /etc/profile
```

```bash
JAVA_HOME=/usr/lib/jvm/jdk1.8.0_131
JRE_HOME=$JAVA_HOME/jre
PATH=$PATH:$JAVA_HOME/bin
CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
export JAVA_HOME
export JRE_HOME
export PATH
export CLASSPATH
```

```bash
# 刷新环境变量
[root@localhost ~]# source /etc/profile
# 配置超链接
[root@localhost ~]# ln -s /usr/lib/jvm/jdk1.8.0_131/bin/java /usr/bin/java
```

***

todo