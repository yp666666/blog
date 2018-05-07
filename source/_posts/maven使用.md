---
title: maven使用
date: 2017-02-28 14:56:26
category: 系统配置
tags: maven
---

> 用IDEA建了一个maven项目，想打包成jar放到本地~/.m2/repository中。

#### 1. 安装maven
1. 检查是否已安装：   `$ mvn -v`
2. 解压到`/opt/apache-maven-3.3.9`
3.  
打开
```bash
$ subl ~/.zshrc
```
我用的是zsh，如果是原生bash的话，就是.bashrc文件了。
 在文件末尾添加
```
# maven
export MAVEN_HOME=/opt/apache-maven-3.3.9
export PATH=$PATH:${MAVEN_HOME}/bin
```
然后，执行 `source ~/.zshrc` 让配置立即生效。
你可以输入 `mvn -v`，`echo $MAVEN_HOME`，`echo $JAVA_HOME`等查询系统环境。

#### 2. 打包，发布
 建立一个maven项目，进入根目录，执行 `mvn package`，等待结束。
 温馨提示pom.xml文件中要有`<packaging>jar</packaging>` 哦。
 然后[参照](https://www.cnblogs.com/davenkin/archive/2012/02/15/install-jar-into-maven-local-repository.html) 执行命令
```sh
mvn install:install-file -Dfile=/home/hero/workspace/git/Commons/target/commons-1.0.jar -DgroupId=moc.hero -DartifactId=commons -Dversion=1.0 -Dpackaging=jar
```
其中-Dfile=就是你jar包，上面的Commons就是我的根目录，命令就是在这里执行的。
这样你的~/.m2/repository中就有了`/home/hero/.m2/repository/moc/hero/commons`，你可以在本地新建一个maven项目，然后去依赖这个commons了。 

当然了，更全更简单的在[官网](https://maven.apache.org/guides/getting-started/index.html#How_do_I_create_a_JAR_and_install_it_in_my_local_repository)喽。

##### 插件方式

```xml
<build>
        <resources>
            <resource>
                <directory>${project.basedir}/src/main/java</directory>
                <includes>
                    <include>**/*.*</include>
                </includes>
                <filtering>false</filtering>
            </resource>
            <resource>
                <directory>${project.basedir}/src/main/resources</directory>
                <includes>
                    <include>**/*.*</include>
                </includes>
                <filtering>false</filtering>
            </resource>
        </resources>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.7.0</version>
                <configuration>
                    <source>1.8</source>
                    <target>1.8</target>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-install-plugin</artifactId>
                <version>2.5.2</version>
                <configuration>
                    <groupId>${project.groupId}</groupId>
                    <artifactId>${project.artifactId}</artifactId>
                    <packaging>${project.packaging}</packaging>
                    <version>${project.version}</version>
                    <file>${project.basedir}/target/${project.name}-${project.version}.${project.packaging}</file>
                </configuration>
            </plugin>
        </plugins>
    </build>
```
配置*resources*可以将配置文件打到jar包中（默认打包只打编译后的class文件）。运行compiler:compile 和 install:install-file即可。

## Maven 基础
[dependencies与dependencyManagement的区别](https://blog.csdn.net/liutengteng130/article/details/46991829)

## 私服搭建
[下载Nexus Repository OSS](https://www.sonatype.com/nexus-repository-oss)
[参考](https://blog.csdn.net/qq_35559756/article/details/73197715)

### deploy
setting.xml
```xml
<server>
<id>releases</id>
<username>admin</username>
<password>admin123</password>
</server>
<server>
<id>snapshots</id>
<username>admin</username>
<password>admin123</password>
</server>
```

pom.xml

```xml
    <distributionManagement>
        <repository>
            <id>releases</id>
            <url>http://127.0.0.1:8081/repository/maven-releases/</url>
        </repository>
        <snapshotRepository>
            <id>snapshots</id>
            <url>http://127.0.0.1:8081/repository/maven-snapshots/</url>
        </snapshotRepository>
    </distributionManagement>
```

### 指定私服的host地址

pom.xml
```xml
<repositories>  
    <repository>  
        <id>releases</id>  
        <name>releases</name>  
        <url>http://127.0.0.1:8081/repository/maven-releases/</url>  
        <releases>  
            <enabled>true</enabled>  
        </releases>  
        <snapshots>  
            <enabled>false</enabled>  
        </snapshots>  
    </repository>  
</repositories>  
```







