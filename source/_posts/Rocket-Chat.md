---
title: Rocket.Chat
date: 2017-12-02 13:09:12
category:
tags:
---
[在Ubuntu上安装、配置和部署Rocket.Chat](http://blog.topspeedsnail.com/archives/3767)
### RocketChat 是什么
[官网](https://rocket.chat/)
Rocket.Chat 是一个开源的通讯工具，可以视频/音频会议、文件共享、屏幕分享、双因素认证等等。可以简单理解为企业版的qq。但是比qq强大，在聊天时可以实时翻译，只不过这是人家公司提供的云服务，不是免费的，如果自己搭就得想办法配置。支持浏览器、桌面系统（Windows、Linux、MacosOS）、移动端（iOS、Android）。
#### 语言、框架
#### 功能
#### 安装
[install on ubuntu](https://rocket.chat/docs/installation/manual-installation/ubuntu)
[安装mongodb](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/)

`sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
`
`echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
`
`sudo apt-get update
`
`sudo apt-get install -y mongodb-org
`
`sudo service mongod start
`

运行
cd /snap/rocketchat-server/1188
bin/mongod --dbpath "/home/hero/data"
bin/node main.js

#### 搭建 Video Conferences 服务器
安装 jitsi-meet
https://github.com/jitsi/jitsi-meet/blob/master/doc/manual-install.md
https://github.com/jitsi/jitsi-meet/blob/master/doc/quick-install.md
