---
title: nginx
date: 2017-08-20 21:09:08
category:
tags: 
---
[官网](http://nginx.org)
#### 安装步骤
>nginx安装跟系统版本有关

我的系统是ubuntu 16.04 LTS
1、修改/etc/apt/sources.list
文件末尾添加：
```code
deb http://nginx.org/packages/ubuntu/ xenial nginx
deb-src http://nginx.org/packages/ubuntu/ xenial nginx
```
2、
```shell
sudo apt-get update
sudo apt-get install nginx
```
又是遇到[NO_PUBKEY](https://carl-zk.github.io/blog/2017/05/17/NO-PUBKEY/)
```sh
sudo apt-key adv --keyserver hkp://keys.gnupg.net --recv-keys 提示中的key
sudo apt-get update
sudo apt-get install nginx
```
3、检查版本
`nginx -v`
4、查找nginx安装目录
`sudo find / -type d -name '*nginx*'`

/etc/nginx
/usr/lib/nginx
/usr/share/doc/nginx
/usr/share/nginx
/var/cache/nginx
/var/log/nginx

##### Mac安装nginx
下载nginx源码，正则匹配需要[pcre](http://mac-dev-env.patrickbougie.com/pcre/)库，需要下载[pcre源码](ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre)共同编译
`./configure --prefix=/etc/nginx --with-pcre=/Users/hero/tmp/pcre-8.41`
`make`
`sudo make install`

#### 入门
1. 启动nginx
`sudo service nginx start`
`sudo nginx`
2. 配置静态资源服务器
+ 备份
  - **/etc/nginx/conf.d/default.conf**
  - **/etc/nginx/nginx.conf**
+ 注释掉**/etc/nginx/conf.d/default.conf**内容
因为nginx会同时读default和nginx.conf，导致在nginx.conf中某些配置无效，例如重复的url。
[default.conf](/blog/2017/08/20/nginx/default.conf)、[nginx.conf](/blog/2017/08/20/nginx/nginx.conf)
+ 目录结构
**/home/hero/tmp/nginxdemo**
---**img**
------qtds.png
---index.html
+ 重新加载配置
`sudo nginx -s reload`
访问`http://localhost/`


3.nginx.conf 配置代理和url匹配规则
```sh
server{
listen 8090;
root /home/hero/tmp/nginxdemo;
}
server {
listen 80;
server_name localhost;
location / {
  proxy_pass http://localhost:8090;
}
location ~ /img/*\.(png|jpg|gif)$ {
  root /home/hero/tmp/nginxdemo;
}
}
```
这样对80端口的请求就被8090代理了。
匹配规则：～代表匹配尽可能长的前缀，后面是一个正则表达式，只要满足正则就从这个location获取，否则就交给其它满足的去处理。