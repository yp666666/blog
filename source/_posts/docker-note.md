---
title: docker note
date: 2018-08-11 23:30:54
category:
tags: docker
---
## docker container networking
### Closed containers
```
docker run --net none
```
### Bridged containers (default)
```
docker run --net bridge
```
#### custom name resolution
```
--hostname containerhostname
```
set primary DNS server
```
--dns 8.8.8.8
```
在此 DNS server 上配置容器的 IP 和 hostname

custome mapping for an IP address and host name pair:
```
--add-host test:1.1.1.1
```

所有映射均可在 /etc/hosts 中看到。

端口映射：
1. <containerPort\>
```
-p 3333
```
2. <hostPort\>:<containerPort\>
```
-p 3333:3333
```
3. <ip\>::<containerPort\>
```
-p 1.1.1.1::3333
```
4. <ip\>:<hostPort\>:<containerPort\>
```
-p 1.1.1.1:3333:3333
```

默认情况下，inter-container communication 的策略是完全访问，即同一个 docker0 bridge 下的所有容器都可以 ping 通其它容器。这其实是很不安全的，禁用方法：
```
--icc=false
```
我们可以通过修改 bridge interface 来控制：

- define the address and subnet of the bridge
- define the range of IP addresses that can be assigned to containers
- define the maximum transmission unit (MTU)

```
--bip "192.168.0.128/25"
```
这样就会使 docker0 interface 的 IP 设为 192.168.0.128，允许 192.168.0.128-192.168.0.255 访问。
设置好后，容器的 IP 就会在这个区间分配，你可以为容器指定固定 IP:
```
--fixed-cidr "192.168.0.130/25"
```

如果需要设置 maximum size of a packet，(default 1500 bytes)
```
-mtu 1200
```

如何使用定制的 bridge:
```
-b mybridge
```
### Joined containers
```
docker run --net container:xxx
```
for example,
```
docker run -d --name brady \
    --net none alpine:latest \
    nc -l 127.0.0.1:3333
docker run -it \
    --net container:brady \
    alpine:latest netstat –al
```
即 network interface 版的 managed volume.
使用场景：
- 在a中修改网络配置使b中的生效。
- 在a中监控b的流量。
- 多个容易共用一个端口交流。
- 与容器未 expose 的端口通信。

Joined containers 允许你连接任何其它容器，但它还不是最不安全的，最不安全的是下面这个。
### Open containers
```
docker run --net host
```

## Inter-container dependencies
```
--link a:alias-a
```
link 不具有传递性：B->A, C->B =/= C->A.
link 有一个特权：它可以连接没有 expose 任何端口号的容器。

## Limiting risk with isolation
### memory limits
```
-m 256m 
```
单位：b, k, m, g
这里需要注意的是设置为 256m 并不表示真会分配的到这么多，仅仅是为了防止使用超度。

```
docker run -d --name ch6_mariadb \
    --memory 256m \
    --cpu-shares 1024
    --user nobody \
    --cap-drop all \
    dockerfile/mariadb
```

## 制作镜像
```sh
docker run --name rie \
-e ENV_A=a -e ENV_B=b \
--entrypoint "/bin/sh" \
busybox:latest \
-c "echo \$ENV_A"


docker commit -a "carl" -m "just for example" rie zxfspace/rie

```
### exporting and importing flat file systems
如果需要添加一个文件，用`docker copy`；如果多个文件，`docker export`；
将容器文件 copy 到 tar 包。
```
docker export --output export.tar container
```
### Dockerfile
```sh
FROM ubuntu:latest
# (or scratch for empty)
MAINTAINER carl
RUN echo 'hello' \
    && echo 'world'
ENV APPROOT="/app" \
    APP="myapp" \
    VERSION='0.1'
LABEL base.name="hw" \
      base.version="${VERSION}"
WORKDIR $APPROOT
ENTRYPOINT ["pwd"]
EXPOSE 3333
# do not set the default user in the base
```
`docker build -f df -t diy:1 .`
不想加到 image 中的文件写到 **.dockerignore** 中。
```sh
FROM diy:1
COPY ["./", "${APPROOT}"]
# USER example:example
RUN chmod 111 ${APPROOT}/df
VOLUME ["/docker/diy", "/var/log"]
CMD ["echo 'hello'"]
```





