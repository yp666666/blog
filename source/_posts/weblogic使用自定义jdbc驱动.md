---
title: weblogic使用自定义jdbc驱动
date: 2017-10-29 23:41:21
category:
tags: weblogic
---
翻译自[Using JDBC Drivers with WebLogic Server](https://docs.oracle.com/middleware/1213/wls/JDBCA/third_party_drivers.htm#JDBCA231)
[Using Third-Party Drivers with WebLogic Server](https://docs.oracle.com/cd/E13222_01/wls/docs81/jdbc/thirdparty.html#1050527)

WebLogic Server 12.1.3

### weblogic自带的JDBC驱动
The 12c version of the Oracle Thin driver is installed with Oracle WebLogic Server.

ojdbc7.jar, ojdbc7_g.jar, and ojdbc7dms.jar for JDK7
ojdbc6.jar, ojdbc6_g.jar, and ojdbc6dms.jar for JDK 6

> 所有驱动都在**$ORACLE_HOME/oracle_common/modules**中，**weblogic.jar**中的manifest文件或直接或间接的引用了它们，所以在weblogic server启动时会自动加载。

### 使用第三方JDBC驱动
如果你需要使用weblogic server没有自带的驱动，你需要把驱动包加到CLASSPATH中。


### 添加或更新JDBC驱动
1. 如果要更新驱动，先备份相应的驱动包。自带的驱动在目录**$ORACLE_HOME/oracle_common/modules**中。
2. 将驱动jar包放到适当的地方，或直接替换原来的驱动包。
3. 决定是否需要修改CLASSPATH：
   - 如果用新包替换，名字不变，则不需要修改CLASSPATH。
   - 如果替换后，名字改变：
     - 只作用于指定domain，编辑domain/bin/** setDomainEnv.cmd/sh**，将jar file 写到PRE_CLASSPATH最前面。
     - 作用于所有domain，编辑WL_HOME/common/bin/**commEnv.cmd/sh**,将jar file 写到WEBLOGIC_CLASSPATH最前面。


welbogic 11g略有不同，自带驱动在WL_HOME/server/lib中。  
[jdbc driver for weblogic server 12.2.1.3.0](https://docs.oracle.com/middleware/12213/wls/JDBCA/third_party_drivers.htm#JDBCA231)   

在weblogic server 12.2.1.3.0中，自带驱动放在**$ORACLE_HOME/oracle_common/modules**中，如mySQL5.1x(mysql-connector-java-commercial-5.1.22-bin.jar)、Oracle Thin Driver(ojdbc8.jar)。

如果要使用weblogic没有的驱动，则直接把驱动jar放到**DOMAIN_HOME/lib **中，它作用于整个domain。

