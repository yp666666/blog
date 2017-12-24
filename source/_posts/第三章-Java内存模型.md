---
title: 第三章 Java内存模型
date: 2017-03-11 23:28:38
category: 并发编程的艺术
tags:
---
# Java内存模型的基础
## 并发编程模型的两个关键问题：
- 线程之间如何通信。
- 线程之间如何同步。

命令式编程中线程通信机制：

并发模型|程序的公共状态|通信方式
---------------------|:------:|--------:
共享内存|共享|隐式
消息传递|无|显示

同步是指程序中用于控制不同线程间操作发生相对顺序的机制。

并发模型|状态|方式
------|:----:|------:
共享内存|显式|显式指定某个方法或某段代码需要在线程之间互斥执行
消息传递|隐式|消息的发送必须在接收之前的属性决定的

> java的并发采用的是共享内存模型，线程之间的通信是隐式的，整个通信过程对程序员完全透明。

## Java内存模型的抽象结构
在Java中，所有实例域、静态域和数组元素都存储在堆内存中，线程间共享，称为“共享变量”。
局部变量(Local Variables)、方法定义参数(Formal Method Parameters)和异常处理器参数(Exception Handler Parameters)不会在线程间共享，它们不会有内存可见性问题，也不受JMM影响。
<!-- more -->
![](jmm.svg)
注：本地内存是JMM的抽象概念，并不真实存在。

如果线程A与线程B通信，必须经历下面2个步骤：
- 线程A把本地内存A中更新过的共享变量刷新到主内存中去。
- 线程B到主内存中去读取线程A之前已更新过的共享变量。

**JVM通过控制主内存与每个线程的本地内存之间的交互，来为Java程序员提供内存可见性保证。**

## 从源代码到指令序列的重排序
1. 编译器优化的重排序。(编译器重排序)
2. 指令级并行的重排序。(处理器重排序)
3. 内存系统的重排序。(处理器重排序)

## 并发编程模型的分类
每个处理器的缓冲区仅对它所在的处理器可见，所以会导致处理器对内存的读/写操作的执行顺序，不一定与内存实际发生的读/写操作顺序一致。

  -  |processorA|processorB
------|:-------|---------:
代码|a=1;  //A1 <br/>x=b;  //A2| b=2;  //B1<br/>y=a;  //B2
运行结果|初始状态: a=b=0<br/>处理器允许执行后得到的结果: x=y=0
![](wrong.svg)

## happens-before简介
表述操作之间的内存可见性。
与程序员密切相关的happens-before规则：
- 程序顺序规则：一个线程中的每个操作，happens-before于该线程之后的任意操作。
- 监视器锁规则：对一个锁的解锁，happens-before于随后对这个锁的加锁。
- volatile变量规则：对一个volatile域的写，happens-before于任意后续对这个volatile域的读。
- 传递性：如果A happens-before B，B happens-before C，那么A happens-before C。

happens-before规则让程序员很容易理解JMM内存可见性保证，避免去学习复杂的重排序规则和这些规则的具体实现。

# 重排序
> 重排序是指编译器和处理器为了优化程序性能而对指令序列进行重新排序的一种手段。

## 数据依赖性
名称 | 代码示例 | 说明
---|----------|------
写后读 | a=1;<br/>b=a; | 写一个变量之后，再读这个变量
写后写 | a=1;<br/>a=2; | 写一个变量之后，再写这个变量
读后写 | a=b;<br/>b=1; | 读一个变量之后，再写这个变量

上面3种情况，只要重排序2个操作就会出现错误。
这里所说的数据依赖仅指单个处理器中执行的指令序列和单个线程中执行的操作，不同处理器和不同线程之间的数据依赖不被编译器和处理器考虑。

## as-if-serial语义
> 不管怎么重排序，(单线程)程序的执行结果不能被改变。编译器、runtime、处理器都必须遵从。

# volatile的内存语义
## volatile的特性
- 可见性。对一个volatile变量的读，总是能看到(任意线程)对这个volatile变量最后的写入。
- 原子性。对任意单个volatile变量的读/写具有原子性，但类似于volatile++这种复合操作不具有原子性。

## volatile写-读建立的happens-before关系
斗胆的质疑一下本书作者，这里可能出错了，我不能认同把volatile真的类比成锁的获取和释放，然后可以对一个普通int型值进行读写的控制。下面是我实验代码，它的结果是不固定的，即书中happens-before的关系第2、3条不能成立：
额，N年之后，回头看到这里，发现其实下面的代码不能证明happens-before原则有错误。happens-before是规范，它的具体实现才有可能出错，而一个规范怎么会有错误呢。两个线程都是从主内存读b，这就代表了如果前面一个线程刚修改了b后面的线程会“立刻”看到修改后的值，仅此而已。
```java
package chapter01;

/**
 * Created by hero on 17-3-12.
 */
public class SerialConsistent {
    public int a = 0;
    public volatile boolean b = false;
    public int t = 5;

    public void write() {
        a = 1;
        try {
            Thread.sleep(501);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        b = true;
    }

    public void read() {
        if (b) {
            t = a;
        }
    }

    public static void main(String[] args) throws InterruptedException {
        SerialConsistent test = new SerialConsistent();
        test.run();
    }

    public void run() throws InterruptedException {
        Thread t1 = new Thread(new Runnable() {
            public void run() {
                write();
            }
        });
        Thread t2 = new Thread(new Runnable() {
            public void run() {
                read();
            }
        });

        t1.start();
        TimeUnit.MILLISECONDS.sleep(500);    //保证t1在t2之前执行
        t2.start();

        t1.join();
        t2.join();

        System.out.println(t);
    }
}
```

## volatile写-读的内存语义
线程A执行volatile变量写操作之后，线程B在读该变量时，本地内存会被JVM置为无效，必须从主内存读。

# 锁的内存语义
## 锁的释放-获取建立的happens-before关系
书中，这个happens-before递推关系是成立的。
下面的栗子证明，锁的happens-before会保证多线程的内存可见的传递性。
```java
package chapter01;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by hero on 17-3-12.
 */
public class ReentrantLockExample {
    int a = 0;
    ReentrantLock lock = new ReentrantLock();
    int t = 5;

    public static void main(String[] args) throws InterruptedException {
        ReentrantLockExample test = new ReentrantLockExample();
        test.run();
    }

    public void write() {
        lock.lock();
        try {
            TimeUnit.MILLISECONDS.sleep(500);
            a++;
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
    }

    public void read() {
        lock.lock();
        try {
            t = a;
        } finally {
            lock.unlock();
        }
    }

    public void run() throws InterruptedException {
        Thread t1 = new Thread(new Runnable() {
            public void run() {
                write();
            }
        });
        Thread t2 = new Thread(new Runnable() {
            public void run() {
                read();
            }
        });

        t1.start();
        TimeUnit.MILLISECONDS.sleep(200);
        t2.start();

        t1.join();
        t2.join();

        System.out.println(t);
    }
}
```

## 锁内存语义的实现
以上面代码为例：
```java
public ReentrantLock() {
    sync = new NonfairSync();
}
```
默认非公平锁，那么lock的调用顺序则是：
1. 先CAS，成功则将当前线程设为独占者。(state：0无独占者，1有)，失败则
2. 当前state=0则CAS，失败则有可能进入等待队列。state=1，则比较当前线程是否是独占者。

公平锁的lock调用顺序是：
1. 先取状态state，满足公平条件后才能获取锁。

公平锁和非公平锁的释放完全一样：
```java
protected final boolean tryRelease(int releases) {
    int c = getState() - releases;
    if (Thread.currentThread() != getExclusiveOwnerThread())
        throw new IllegalMonitorStateException();
    boolean free = false;
    if (c == 0) {
        free = true;
        setExclusiveOwnerThread(null);
    }
    setState(c);
    return free;
}
```
## concurrent包的实现
由于Java的CAS同时具有volatile读和写的内存语义，因此Java线程之间的通信有下面4种：
- 线程A写volatile变量，随后线程B读这个volatile变量。
- 线程A写volatile变量，随后线程B用CAS更新这个volatile变量。
- 线程A用CAS更新一个volatile变量，随后线程B用CAS更新这个volatile变量。
- 线程A用CAS更新一个volatile变量，随后线程B读这个volatile变量。

[ sun.misc.Unsafe](http://ifeve.com/sun-misc-unsafe/#header)
unsafe的CAS是原子性的，至于它为什么叫unsafe，琢磨一下上面这个文章。

# final域的内存语义
我感觉作者错了，普通int怎么会从构造函数中'逃逸'出来，我用程序试了没出现初始值没写入普通域的情况。
另外，如果构造函数中的普通域可以重排到构造函数之外，，，你不觉得这不是优化，而是编译器的bug么？
有些东西确实很难用代码“亲眼看见”结果，但是原理是高于实现的，所以，是存在逃逸的可能性的。

读一读[Java language specification](https://docs.oracle.com/javase/specs/)吧!


