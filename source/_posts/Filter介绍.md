---
title: Filter介绍
date: 2017-02-25 20:34:43
category:
tags: Servlet
---
> Filter可认为是Servlet的一种增强版,主要用于对用户请求进行预处理,也可以对HttpServletResponse进行后处理,是个典型的处理链. 也可对用户请求进行响应,但实际中很少这样用.

![Filter作用](filter-1.svg)

```java
public class LogFilter implements Filter{
    ...
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain){
        ...对请求进行预处理
        chain.doFilter(request, response);
        ...对服务器响应进行后处理
    }
    ...
}
```
  
#### 在web.xml中配置Filter
类似Servlet配置
```html
<filter>
    <filter-name></>
    <filter-class></>
</filter>
<!-- 定义Filter拦截的URL地址 -->
<filter-mapping>
    <filter-name></>
    <url-pattern></>
</filter-mapping>
```