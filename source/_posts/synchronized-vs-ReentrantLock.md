---
title: synchronized vs ReentrantLock
date: 2017-03-08 22:37:02
category: java
tags:
---

> 最近看到项目代码中有很多地方用到了`synchronized`，纠结它与`ReentrantLock`在性能上孰优孰劣。正好也把`ReadWriteLock`、`ReentrantReadWriteLock`、`StampedLock`也研究一下。

参考：
[difference between synchronized vs ReentrantLock](https://javarevisited.blogspot.com/2013/03/reentrantlock-example-in-java-synchronized-difference-vs-lock.html)

看了一个接一个的资料，觉得自己对Java一无所知，曾经看过的都忘记了。这就是只会用的硬伤，先看完薄的Java并发再看深入jvm，回头来解决这个博客，估计是要看源码的了，自己写代码比较一下。
蛋疼的渣渣，以前太自以为是了，欠了好多债啊！！！