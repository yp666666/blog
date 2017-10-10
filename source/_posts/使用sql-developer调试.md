---
title: 使用sql developer调试
date: 2017-09-17 10:57:28
category:
tags: oracle
---
[参考](http://www.oracle.com/technetwork/cn/tutorials/plsql-debug-088880-zhs.html#p)

#### 前提条件
1.解锁hr用户
```sql
ALTER USER hr UNLOCK ACCOUNT; -- or alter user xx account unlock
ALTER USER hr IDENTIFIED BY hr;
```
2.授予debug权限
```sql
GRANT debug any procedure, debug connect session TO hr;
```
#### 调试存储过程
1.单击一个存储过程;
2.右键选择`compile for debug`
  此时左侧该存储过程会出现一个绿色的小虫。
3.单击行首设置断点
4.单击红色`debug`按钮
5.在`Parameters/Input Value`中填入`IN`的参数，`OUT`可以不管
6.单击`OK`
