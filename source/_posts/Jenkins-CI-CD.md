---
title: Jenkins CI/CD
date: 2019-05-02 12:52:07
category:
tags: jenkins
---
> 很好奇 Jenkins 是怎么做灰度发布的，我不懂。
> 我根据对 Pipeline 的理解，然后尝试将一个 Spring Boot Web 项目编译，打包，生成镜像和部署。整个下来才发现原来我一直以为自己理解什么是滚动发布，但是实际上我不懂如何用 Jenkins 做到。

## Pipeline
[https://jenkins.io/doc/book/pipeline/](https://jenkins.io/doc/book/pipeline/)

Pipeline 是一条流水线，涵盖了整个项目从编译、打包到测试、部署中间所有的步骤。一般在Jenkinsfile文件中定义整个 pipeline。

先理解 Pipeline的几个概念。
- Node 
  Jenkins service 的一部分，可以跑 Pipeline 的机器。Jenkinsfile中 agent { node { label 'labelName' } } 可以指定 node。刚起动的 Jenkins 只有 master 一个节点。
- Stage
  自定义一组 task，可在 Jenkins UI 看到 status/progress。
- Step
  一个 task，存在于一个特定的 Stage 中。
- [agent](https://jenkins.io/doc/book/pipeline/syntax/#agent)
  pipeline 运行环境，如果定义在最上面表明整个 pipeline 都在同一个 agent 中执行，也可以在每个 Stage 块中单独指定，作用于单个 Stage。

## Config Master Node
为了让 pipeline 都跑在 master 节点上，需要额外配置好 maven。
```sh
docker exec -it -u root my-jenkins bash
wget https://www-us.apache.org/dist/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz
tar xvzf apache-maven-3.6.1-bin.tar.gz
ln -s /apache-maven-3.6.1/bin/mvn /usr/bin/mvn
apt-get update && apt-get install vim
vi /apache-maven-3.6.1/conf/settings.xml
修改仓库地址 <localRepository>/home/.m2/repository</localRepository>
```

## Create Jenkinsfile
[github source](https://github.com/carl-zk/jenkins-demo)
Jenkinsfile
```sh
pipeline {
    agent { label 'master' }

    environment {
        IMAGE_NAME = 'jenkins-demo'
        LABEL = 'latest'
        CONTAINER_NAME = 'jenkins-demo'
        PORT = 8090
    }

    stages {
        stage('Package') {
            steps {
                sh 'mvn -B -DskipTests=true clean package'
            }
        }

        stage('Build Image') {
            steps {
                script {
                    sh 'pwd && cd docker/ && docker build -t ${IMAGE_NAME}:${LABEL} .'
                }
            }
        }

        stage('Deploy') {
            steps {
                sh """
                    docker ps -f name=${CONTAINER_NAME} -q | xargs --no-run-if-empty docker container stop
                    docker container ls -a -f name=${CONTAINER_NAME} -q | xargs -r docker container rm -v
                    docker run -d --name ${CONTAINER_NAME} -p ${PORT}:${PORT} ${IMAGE_NAME}:${LABEL}
                """
            }
        }
    }
}
```
Jenkins 持续集成/持续发布 待续。









