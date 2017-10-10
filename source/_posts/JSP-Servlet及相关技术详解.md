---
title: JSP/Servlet及相关技术详解
date: 2017-02-25 16:01:07
category:
tags: Servlet
---
JSP(Java Server Page) 和 Servlet 是 Java EE 规范的两个基本成员。JSP 和 Servlet 的本质是一样的，JSP最终必须编译成Servlet才能运行，可以理解为JSP是Servlet的“草稿”文件。JSP就是嵌套了Java代码的html页面。
#### web应用和web.xml文件
##### 创建一个最简单的web应用
1. 新建文件夹webDemo；
2. 在webDemo内新建WEB-INF文件夹；
3. 在WEB-INF下加入一个web.xml文件；

 ```xml
<!-- web.xml文件 -->
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                      http://xmlns.jcp.org/xml/ns/javaee/web-app_3_1.xsd"
  version="3.1"
  metadata-complete="true">
</web-app>
 ```
 ``` html
 <!-- a.jsp文件 -->
<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<html>
<head>
	<title>Welcome</title>
</head>
<body>
    欢迎学习JAVA WEB知识
</body>
</html>
 ```

4. 在WEB-INF下新建classes、lib两个文件夹；
5. 一个空的web应用就创建完成了，现在只需把JSP（a.jsp）放在Web应用的根目录下（webDemo目录）就可以部署到Tomcat中。
6. 将webDemo复制到Tomcat的**webapps**目录下，启动tomcat，在浏览器中输入localhost:8080/webDemo/a.jsp就可以访问了。



**webDemo** *目录结构*
|-WEB-INF
-------|-classes
-------|-lib
-------|-web.xml
|-a.jsp

web.xml被称为配置描述符，配置JSP，Servlet，Listener，Filter，标签库，JSP属性，JAAS授权认证，资源引用和应用首页等。


#### JSP的基本原理

JSP的本质是Servlet，用户向指定Servlet发送请求时，Servlet利用输出流动态生成HTML页面。
一个JSP页面有两部分组成：静态部分和动态部分。

每个JSP文件都会产生一个对应的.java文件和.class文件，JSP代码发生变化，则对应的.class也会更新。服务器中JSP的实例对象只有一个。


```html
<%@ page contentType="text/html; charset=UTF-8" language="java" errorPage="" %>
<html>
<head>
	<title>Welcome</title>
</head>

<%!
	//声明一个变量
	public int count;
	//声明一个方法
	public String info(){
        return "info : hello";
    }
%>

<body>
    欢迎学习JAVA WEB知识
    <%out.println(new java.util.Date());%>
    <!-- 下面是JAVA脚本 -->
    <% for(int i = 0; i < 7; i++){
    	  out.println("<font size='" + i +"'>");
    	  out.println("Wild Java Camp</font> <br/>");
       } 
    %>

    <%-- 浏览器审查元素也看不到我，我是JSP注释 --%>
    <%
    	//将count的值输出后加1
    	out.println(count++);
    %>
    <!-- 表达式法输出 -->
    <%=count%>
    <br/>
    <%
    	//输出info()方法的返回值
    	out.println(info());
    %>

</body>
</html>
```

#### JSP的3个编译指令: page include taglib
> 使用编译指令的语法格式：
**<%@ 编译指令名 属性名="属性值" ...%>**

##### page
该指令是针对当前页面的指令。

##### include
用于指定包含另一个页面。
静态导入
动态导入`<jsp:include>`
##### taglib
用于定义和访问自定义标签。

#### JSP的7个动作指令

##### jsp:forward
执行页面转向，将请求的处理转发到下一个页面。
##### jsp:param
用于传递参数，必须与其它支持的标签一起使用。
#####jsp:include
用于动态引入一个JSP页面
##### jsp:plugin
用于下载JavaBean或Applet到客户端执行
#####jsp:useBean
创建一个JavaBean的实例。
##### jsp:setProperty
设置JavaBean实例的属性值。
#####jsp:getProperty
输出JavaBean实例的属性值。

#### JSP脚本中的9个内置对象
application
config
exception
out
page
pageContext
request
response
session
