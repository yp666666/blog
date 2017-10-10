---
title: 第二章 Java并发机制的底层实现原理
date: 2017-03-11 21:35:52
category: 并发编程的艺术
tags:
---
从下图中可以看出，Java中所使用的并发机制依赖于**JVM的实现**和**CPU的指令**。

<!-- more -->

![](compile.svg)

# volatile的应用
volatile修饰的变量进行写操作时，多核处理器会引发两件事情：
- 将当前处理器缓存行的数据写回到系统内存。
- 这个写回内存的操作会使在其他CPU内缓存了该内存地址的数据无效。

原理：volatile变量进行写操作时，汇编代码会多出一个lock指令，它会锁缓存行，并写回到内存，并使用缓存一致性机制阻止同时修改由两个以上处理器缓存的内存区域数据。处理器使用嗅探技术，将状态是共享的内存地址填充行在访问该地址内存时强制执行缓冲行填充。

# synchronized的实现原理与应用
锁的3种类型：
- 普通同步方法，锁是当前实例对象。synchronized function(){} 
- 静态同步方法，锁是当前类的Class对象。public static synchronized void function(){}
- 同步方法块，锁是括号里配置的对象。public void function(){ synchronized(object){}}  

# 原子操作的实现原理
atomic operation是指“不可被中断的一个或一系列操作”。
处理器如何保证原子操作？
- 总线锁定。
- 缓存锁定。

## Java如何实现原子操作
锁和**CAS**两种方式。
*使用CAS实现原子操作。*
```java
package chapter01;

import java.util.ArrayList;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Created by hero on 17-3-11.
 */
public class CASIncrease {
    private static final int _COUNT = 1000;
    private AtomicInteger atomicV = new AtomicInteger(0);
    private int v = 0;

    public static void main(String[] args) {
        new CASIncrease().contrast();
    }

    /**
     * 在并发情况下，对比CAS加法和普通加法
     */
    public void contrast() {
        ArrayList<Thread> list = new ArrayList<Thread>(_COUNT);
        for (int i = 0; i < _COUNT; i++) {
            Thread t = new Thread(new Runnable() {
                public void run() {
                    commonAdd();
                    casAdd();
                }
            });
            list.add(t);
        }

        for (Thread item : list) {
            item.start();
        }

        for (Thread thread : list) {
            try {
                thread.join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        System.out.println("CAS add " + atomicV.get());
        System.out.println("normal add " + v);
    }

    private void casAdd() {
        for (; ; ) {
            int real = atomicV.get();  //操作1
            /**
             * 在这里如果有另外一个线程把atomicV值改了，然后又改了回来，就发生了ABA问题
             */
            boolean succeed = atomicV.compareAndSet(real, real + 1);  //操作2
            if (succeed) break;
        }
    }

    private void commonAdd() {
        int real = v;
        v = real + 1;
    }
}
```

CAS实现原子操作的3大问题：
- ABA问题。
- 循环时间长开销大。
- 只能保证一个共享变量的原子操作。