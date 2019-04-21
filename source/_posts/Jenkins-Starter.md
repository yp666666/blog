---
title: Jenkins Starter
date: 2019-04-21 04:58:32
category:
tags: jenkins
---
> 周末有时间搞一搞Jenkins，也算是充实一下。当业务开发久了，好多工具只知道用，不知怎么搭建，有点惭愧。
> Jenkins官网的文档倒是挺全的，还有中文版本，只不过我天生带debug buff，什么东西刚上手总是能遇到别人遇不到的各种问题，:)。并且官网的文档不会随着版本去更新，第一次接触还是会有一些问题，所以记录下来方便自己也方便他人。

# 使用Maven构建Java应用程序
参考[使用Maven构建Java应用程序](https://jenkins.io/zh/doc/tutorials/
build-a-java-app-with-maven/)

## Jenkins 安装
宿主机上已安装docker，通过docker去安装。
[https://hub.docker.com/r/jenkins/jenkins/](https://hub.docker.com/r/jenkins/jenkins/)

```sh
docker run --name my-jenkins \
-p 7777:8080 -p 50000:50000 \
-v /opt/Jenkins/var/jenkins_home:/var/jenkins_home \
-v /var/run/docker.sock:/var/run/docker.sock \
-v "$HOME":/home \
--env JAVA_OPTS="-Duser.timezone=Asia/Shanghai" \
jenkins/jenkins:lts
```

我将Jenkins端口映射到宿主机7777；
`/opt/Jenkins/var/jenkins_home` 为空目录，Jenkins Server的所有配置文件都在这里；
`-v /var/run/docker.sock:/var/run/docker.sock \` 运行docker命令时，关联到宿主机 Docker daemon；
`-v "$HOME":/home` home目录与宿主机一致，当Jenkins执行mvn install时，依赖包都在~/.m2中；

按照提示，应该可以顺利进入Jenkins管理页面。

## 创建第一个流水线项目
Fork [https://github.com/jenkins-docs/simple-java-maven-app](https://github.com/jenkins-docs/simple-java-maven-app)。
这一部分参考文档写的差不多，我就不赘述了。只讲一点，参考文档是将simple-java-maven-app clone 到本地，如果不想这样也是可以的，直接贴URL，这时就需要一个Deploy Key：
```sh
ssh-keygen -t rsa -f /Users/carl/.ssh/jenkins/simple-java-maven-app -C "github/simple-app"
```
使用 `pbcopy < simple-java-maven-app.pub` 将公钥设置在GitHub上，私钥配在Jenkins上即可。

创建Jenkinsfile
```
pipeline {
    agent {
        docker {
            image 'maven:3-alpine' 
            args '-v /root/.m2:/root/.m2' 
        }
    }
    stages {
        stage('Build') { 
            steps {
                sh 'mvn -B -DskipTests clean package' 
            }
        }
    }
}
```

## 第一次build失败
保存并build，应该不会成功，这很正常。下面的问题需要对docker有一点点的了解。

1. 错误信息 “docker: not found”。
Jenkins Server 在执行docker命令时，找不到docker命令。
docker命令的运行需要两个条件：一个client，一个daemon。由于宿主机已有daemon，所以Jenkins Server上安装一个client即可。记得吗？我们启动Jenkins时已经mount好了容器到宿主机的docker socket `-v /var/run/docker.sock:/var/run/docker.sock`。
从[https://docs.docker.com/install/linux/docker-ce/binaries/](https://docs.docker.com/install/linux/docker-ce/binaries/)下载安装包，我选择的是docker-18.06.3-ce.tgz。
解压得到一些文件，其中docker即是client，dockerd即是daemon，我们只需要把docker复制到Jenkins 容器的/usr/bin目录下。

```sh
docker exec -u root -it my-jenkins bash
wget https://download.docker.com/linux/static/stable/x86_64/docker-18.06.3-ce.tgz
tar xvzf docker-18.06.3-ce.tgz
cp docker/docker /usr/bin
rm -rf docker/ docker-18.06.3-ce.tgz
```

OK, 再build一次吧。

2. 错误信息 "connect: permission denied"
这次错误不一样了，意思是client没有权限与daemon交互。
原因可能有两点：
  a. 宿主机docker启动时是root权限启动的。或者
  b. Jenkins Server 中 user jenkins 没有文件 `/var/run/docker.sock` 的rw权限。

检查下宿主机docker是否是root启动，一般都不是。
修改/var/run/docker.sock权限：
```sh
docker exec -u root -it my-jenkins bash
ls -al /var/run/docker.sock
usermod -aG root jenkins
```
这里简单起见，直接把jenkins加入到对应权限组中。

重启Jenkins Server。
`Ctr+C` + `docker start -ai my-jenkins`

![](http://ppdxz524p.bkt.clouddn.com/Jenkins-Starter/simple-pipeline.png)

恭喜！大功告成！

希望这篇文章对你有帮助。








