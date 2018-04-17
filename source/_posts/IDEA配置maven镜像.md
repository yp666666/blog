---
title: IDEA配置maven镜像
date: 2017-02-21 15:40:21
category: 系统配置
tags:
---


打开IntelliJ IDEA->Settings ->Build, Execution, Deployment -> Build Tools > Maven

![](screenshot.png)

override  **User settings file**, 在`<mirrors></mirrors>`中添加alimaven.

```html
   <mirrors>
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>        
    </mirror>
  </mirrors>
```

pom.xml 配置
```
<repositories>  
        <repository>  
            <id>alimaven</id>  
            <name>aliyun maven</name>  
            <url>http://maven.aliyun.com/nexus/content/groups/public/</url>  
            <releases>  
                <enabled>true</enabled>  
            </releases>  
            <snapshots>  
                <enabled>false</enabled>  
            </snapshots>  
        </repository>  
</repositories>  
```