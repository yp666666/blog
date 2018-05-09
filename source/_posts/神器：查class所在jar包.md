---
title: 神器：查class所在jar包
date: 2018-05-09 07:25:04
category:
tags:
---
[https://blog.csdn.net/wo541075754/article/details/48243403](https://blog.csdn.net/wo541075754/article/details/48243403)

```java
<%@page contentType="text/html; charset=GBK"%>
<%@page import="java.security.*,java.net.*,java.io.*"%>
<%!

  public static URL getClassLocation(final Class cls) {
    if (cls == null)throw new IllegalArgumentException("null input: cls");
    URL result = null;
    final String clsAsResource = cls.getName().replace('.', '/').concat(".class");
    final ProtectionDomain pd = cls.getProtectionDomain();
    // java.lang.Class contract does not specify if 'pd' can ever be null;
    // it is not the case for Sun's implementations, but guard against null
    // just in case:
    if (pd != null) {
      final CodeSource cs = pd.getCodeSource();
      // 'cs' can be null depending on the classloader behavior:
      if (cs != null) result = cs.getLocation();
      if (result != null) {
        // Convert a code source location into a full class file location
        // for some common cases:
        if ("file".equals(result.getProtocol())) {
          try {
            if (result.toExternalForm().endsWith(".jar") ||
                result.toExternalForm().endsWith(".zip"))
              result = new URL("jar:".concat(result.toExternalForm())
                               .concat("!/").concat(clsAsResource));
            else if (new File(result.getFile()).isDirectory())
              result = new URL(result, clsAsResource);
          }
          catch (MalformedURLException ignore) {}
        }
      }
    }
    if (result == null) {
      // Try to find 'cls' definition as a resource; this is not
      // document．d to be legal, but Sun's implementations seem to         //allow this:
      final ClassLoader clsLoader = cls.getClassLoader();
      result = clsLoader != null ?
          clsLoader.getResource(clsAsResource) :
          ClassLoader.getSystemResource(clsAsResource);
    }
    return result;
  }
%>
<html>
<head>
<title>srcAdd.jar</title>
</head>
<body bgcolor="#ffffff">
  使用方法，className参数为类的全名，不需要.class后缀，如
  srcAdd.jsp?className=java.net.URL
<%
try
{
  String classLocation = null;
  String error = null;
  String className = request.getParameter("className");

  classLocation =  ""+getClassLocation(Class.forName(className));
  if (error == null) {
    out.print("类" + className + "实例的物理文件位于：");
    out.print("<hr>");
    out.print(classLocation);
  }
  else {
    out.print("类" + className + "没有对应的物理文件。<br>");
    out.print("错误：" + error);
  }
}catch(Exception e)
{
  out.print("异常。"+e.getMessage());
}
%>
</body>
</html>
```


```java
import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.CodeSource;
import java.security.ProtectionDomain;
import java.util.Objects;

public class ReflectTest {

    public static URL getClassLocation(final Class clazz) {
        Objects.requireNonNull(clazz);
        URL result = null;
        final String classAsResource = clazz.getName().replace('.', '/').concat(".class");
        final ProtectionDomain protectionDomain = clazz.getProtectionDomain();
        if (protectionDomain != null) {
            final CodeSource codeSource = protectionDomain.getCodeSource();
            if (codeSource != null) {
                result = codeSource.getLocation();
            }
            if (result != null) {
                if ("file".equals(result.getProtocol())) {
                    try {
                        if (".jar".equals(result.toExternalForm()) || ".zip".equals(result.toExternalForm())) {
                            result = new URL("jar:".concat(result.toExternalForm()).concat("!/").concat(classAsResource));
                        } else if (new File(result.getFile()).isDirectory()) {
                            return new URL(result, classAsResource);
                        }
                    } catch (MalformedURLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        if (result == null) {
            final ClassLoader classLoader = clazz.getClassLoader();
            result = classLoader != null ? classLoader.getResource(classAsResource) : ClassLoader.getSystemResource(classAsResource);
        }
        return result;
    }

    public static void main(String[] args) {
        URL location = getClassLocation(String.class);
        System.out.println(location);
    }
}
```