---
title: mysql server
date: 2018-04-06 19:21:31
category: 系统配置
tags:
---
#### 忘记 root 密码
> mysql server version : 5.7.9+

查找MySQL sever 安装位置
sudo find / -name "mysqld"

1. 停服务
ps -ef|grep mysql
sudo kill -9 pid1 pid2			
2. 重启
mysqld_safe --skip-grant-tables &
3. 登录
mysql -u root 
4. 重置密码
use mysql;
update user set authentication_string='password', password_expired = 'N' where User ='root' and Host='localhost';
flush privileges;
exit;
停服务重新登录即可
sudo mysqld -uroot &

注意：Mac 上通过 System Preferences 启动的 server，其启动参数 -u 为 _mysql，在上述第2步之后，第3步改为
mysql -u _mysql
grant all privileges on *.* to 'root'@'%' identified by 'password' with grant option;






