---
title: linux配置jdk
date: 2017-05-06 21:58:38
category: 系统配置
tags:
---
已经有一种习惯，每次配置jdk都会翻自己以前的博客，因为每次只要一百度，肯定会出来很多乱七八糟的东西，而且google出来的也不准确。互联网就是因为坏的东西太多，一一甄别太耗时，还是自己备份的最靠谱。

```
# java jdk 1u8
export JAVA_HOME=/usr/lib/jdk
export JRE_HOME=${JAVA_HOME}/jre 
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH
```

华丽丽的隐身分割线


IDEA可以在terminal中直接'idea'启动，但是点击图标却报JDK not found。
```
$ locate idea.sh
$ vi /path/to/idea.sh

在第2行添加
export IDEA_JDK=/path/to/jdk
```