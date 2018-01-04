---
title: SQL中的锁
date: 2017-05-20 21:44:49
category:
tags: sql
---
Connnection设置autoCommit=false时，sql执行更新之后还未commit，其它更新这条数据的sql会等待还是顺利执行完成？

**测试环境**
mysql  Ver 14.14 Distrib 5.5.55, for debian-linux-gnu (x86_64) using readline 6.3
Linux itmebrnb 3.16.0-4-amd64 #1 SMP Debian 3.16.43-2 (2017-04-30) x86_64 GNU/Linux

[测试代码](https://github.com/carl-zk/JavaJava/tree/master/SqlRowLock)

#### 测试方法
在IDEA中debug模式下运行TestA，断点设在MySqlUserRepository
```java
public int save(User user) {
        Connection conn = DBUtil.getConnection();
        PreparedStatement stat = null;
        int res = 0;
        try {
            conn.setAutoCommit(false);
            stat = conn.prepareStatement("update user set name=?, age=? where id=?");
            stat.setString(1, user.getName());
            stat.setInt(2, user.getAge());
            stat.setInt(3, user.getId());
            res = stat.executeUpdate();
            conn.commit();      // 在这里设置断点则其他update命令将等待
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBUtil.closeAll(null, stat, conn);
        }
        return res;
    }
```

在terminal中运行TestB
```sh
java -classpath ~/.m2/repository/mysql/mysql-connector-java/5.1.6/mysql-connector-java-5.1.6.jar: manual.commit.tx.TestB
```

#### 结果
TestB会等待TestA执行commit，如果TestA不执行，TestB会一直等到超时为止。
手动提交模式下，sql执行完还在占有锁。（自动提交其实是一样的）
数据库保证事务的原子性应该是这样的，所有的更新sql会一直占有锁，这样其它更新语句就必须等待，这样原子性就得到了保障。

