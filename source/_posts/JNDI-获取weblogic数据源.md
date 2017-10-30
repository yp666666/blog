---
title: JNDI 获取weblogic数据源
date: 2017-09-11 22:30:45
category:
tags: weblogic
---

[JNDI](https://en.wikipedia.org/wiki/Java_Naming_and_Directory_Interface): Java Naming and Directory Interface.

java如何获取weblogic配置的数据源？
[参考](https://blogs.oracle.com/luzmestre/how-to-connect-to-weblogic-datasource-from-a-java-client)

1.在weblogic中新建一个mysql数据源，`JNDI name`设成`dbconn`.
2.java代码
```java
package common;

//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.*;
import java.util.Hashtable;

public abstract class DBUtils {
    // private static final Logger logger = LoggerFactory.getLogger(DBUtils.class);
    private static DataSource ds = null;

    static {
        try {
            Hashtable<String, String> env = new Hashtable<>();
            env.put(Context.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");
            env.put(Context.PROVIDER_URL, "t3://localhost:7001");//7001为数据源挂载的server端口
            Context context = new InitialContext(env);
            ds = (DataSource) context.lookup("dbconn");
        } catch (NamingException e) {
            System.out.println(e);
            //    logger.error("datasource init failed.", e);
        }
    }

    public static Connection getConn() {
        Connection conn = null;
        try {
            conn = ds.getConnection();
        } catch (SQLException e) {
            System.out.println(e);
            //     logger.error("getConn failed.", e);
        }
        return conn;
    }

    public static void main(String[] args) {
        Connection conn = null;
        Statement statement = null;
        ResultSet resultSet = null;
        try {
            conn = getConn();
            statement = conn.createStatement();
            resultSet = statement.executeQuery("select count(*) from tbl_user");
            resultSet.next();
            System.out.println(resultSet.getLong(1));
        } catch (SQLException e) {
            System.out.println(e);
            e.printStackTrace();
        } finally {
            close(resultSet);
            close(statement);
            close(conn);
        }
    }

    public static void close(Connection conn) {
        if (conn == null) return;
        try {
            conn.close();
        } catch (SQLException e) {
            //    logger.error("close conn failed.", e);
        }
    }

    public static void close(PreparedStatement statement) {
        if (statement == null) return;
        try {
            statement.close();
        } catch (SQLException e) {
            //    logger.error("close prepareStatement failed.", e);
        }
    }

    public static void close(Statement statement) {
        if (statement == null) return;
        try {
            statement.close();
        } catch (SQLException e) {
            //    logger.error("close statement failed.", e);
        }
    }

    public static void close(ResultSet resultSet) {
        if (resultSet == null) return;
        try {
            resultSet.close();
        } catch (SQLException e) {
            //   logger.error("close resultSet failed.", e);
        }
    }
} 
```
3.打开终端
`~ /weblogic/user_projects/domains/base_domain/bin/setDomainEnv.sh`
`javac  common/DBUtils.java`
`java -classpath /weblogic/wlserver/server/lib/weblogic.jar: common.DBUtils`
其中**setDomainEnv.sh**文件内容
[setDomainEnv.sh](/blog/2017/09/11/JNDI-%E8%8E%B7%E5%8F%96weblogic%E6%95%B0%E6%8D%AE%E6%BA%90/setDomainEnv.sh.txt)

额，如果直接把weblogic.jar加到build lib中，也能直接运行。。。