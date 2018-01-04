---
title: 给spring-mvc添加事务
date: 2017-02-28 00:48:17
category: 
tags:
---
 
> 所谓的spring容器，一般指的是spring-context所提供的IOC容器；但是我们一般都是要建立一个web项目，所以就要引入另一个依赖---spring-web，它也提供了一个容器，在web.xml文件中配置一个ContextLoaderListener就可以将IOC容器加入到spring-web容器中。

![容器关系](container.svg)

> 很多博客都将了上面的这个事实，但是他们却没给一个很准确的给controller层加事务能力的方法。

```
<tx:annotation-driven transaction-manager="transactionManager"/>
```
> 要在xxx-controller.xml中加入上面这一句注释。

 延伸：
 [分析源码的大牛](http://jinnianshilongnian.iteye.com/blog/1901694)
 [ Spring AOP APIs](http://docs.spring.io/spring/docs/current/spring-framework-reference/html/aop-api.html) ctr+F搜索: `proxyTargetClass`
 
 为什么这样写也可以
```
<aop:aspectj-autoproxy proxy-target-class="true"/>  
<tx:annotation-driven transaction-manager="transactionManager"/> 
```
