---
title: Install OFBiz
date: 2017-03-05 13:11:57
category: OFBiz
tags:
---

# download
[download](https://ofbiz.apache.org/download.html)

# install gradle
[gradle](https://docs.gradle.org/3.4.1/userguide/overview.html)是一个build,automate and deliver工具，类似ant，不过[gradle学习](http://localhost:4000/blog/2017/03/06/gradle/)主要针对Java项目。build scripts是采用[Groovy](http://groovy-lang.org/install.html)语言，原因是它比Java更简单直接，类似Python、Ruby。
你可以不用安装gradle，如果它是一个Gradle-based build项目，直接 `./gradlew tasks`即可。
我选择直接安装在/opt/gradle中，在~/.zshrc中export然后source。(Ubuntu的sdk安装工具sdkman类似mac的brew)

# first step
进入OFBiz根目录，它是一个gradle-based的项目，但是我已经安装gradle了，所以可以直接`gradle cleanAll loadDefault`
