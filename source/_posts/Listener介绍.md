---
title: Listener介绍
date: 2017-02-25 21:56:04
category:
tags: Servlet
---
> 当web应用在web容器中运行时,web应用内部会不断的发生各种事件:web应用被启动、web应用被停止、用户session开始、用户session结束、用户请求到达等，通常来说这些web事件对开发者是透明的。
> ServletAPI提供了大量监听器来监听web应用的内部事件，从而允许当web内部事件发生时回调事件监听器内的方法。
> 使用Listener只需两步：
 1. 定义Listener实现类。
 2. 通过Annotation或web.xml文件中配置Listener。

