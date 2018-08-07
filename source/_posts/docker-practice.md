---
title: docker practice
date: 2018-08-05 13:23:07
category:
tags: docker
---

## run mysql with docker
```sh
docker run -d --name mysql_server \
-p 3307:3306 \
-v /docker/mysqlDB:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=root \
-e MYSQL_ROOT_HOST=% \
mysql:latest
```

检查是否运行成功：docker ps

然后：
```
mysql -h0.0.0.0 -P3307 -uroot -proot
```

如果报下面错误：
```
ERROR 2059 (HY000): Authentication plugin 'caching_sha2_password' cannot be loaded: dlopen(/usr/local/mysql/lib/plugin/caching_sha2_password.so, 2): image not found
```
则：
```
docker exec -it mysql_server mysql -uroot -proot
alter user 'root'@'%' identified with mysql_native_password by 'root';
```


**备注：**

默认情况下 MySQL server 只允许本机登录，修改任意IP地址登录：
```
grant all privileges on *.* to 'root'@'%' identified by 'root' with grant option;
```

查看 MySQL server container IP 地址：
```
docker inspect mysql_server | grep IPAdd
```

停止并清理
```
docker rm -f mysql_server
docker container prune
docker image prune
```

[IP 地址 0.0.0.0 的意义](https://en.wikipedia.org/wiki/0.0.0.0)

