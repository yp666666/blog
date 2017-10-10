---
title: 第4章 Java并发编程基础
date: 2017-03-14 21:42:18
category: 并发编程的艺术
tags:
---
## 查看JVM线程信息
居然还有这么好的东西
```java
package chapter04;

import java.lang.management.ManagementFactory;
import java.lang.management.ThreadInfo;
import java.lang.management.ThreadMXBean;

/**
 * Created by hero on 17-3-14.
 */
public class MultiThread {

    public static void main(String[] args) {
        MultiThread.showThreadsInfo(true, true);
    }

    public static void showThreadsInfo(boolean lockedMonitors, boolean lockedSynchronizers) {
        ThreadMXBean threadMXBean = ManagementFactory.getThreadMXBean();
        ThreadInfo[] threadInfos = threadMXBean.dumpAllThreads(lockedMonitors, lockedSynchronizers);
        for (ThreadInfo threadInfo : threadInfos) {
            System.out.println("[" + threadInfo.getThreadId() + "] " + threadInfo.getThreadName());
        }
    }
}
```

## 线程优先级靠谱吗
```java
package chapter04;

import java.util.concurrent.CyclicBarrier;
import java.util.concurrent.TimeUnit;

/**
 * Created by hero on 17-3-14.
 */
public class ThreadPriority {
    public static final int _SIZE = 10;
    private volatile boolean isEnd;
    private CyclicBarrier cyclicBarrier;

    public ThreadPriority() {
        cyclicBarrier = new CyclicBarrier(_SIZE);
        isEnd = false;
    }

    public static void main(String[] args) {
        ThreadPriority threadPriority = new ThreadPriority();
        threadPriority.run();
    }

    public void run() {
        Job[] jobs = new Job[_SIZE];
        for (int i = 0; i < _SIZE; i++) {
            int priority = i < 5 ? Thread.MIN_PRIORITY : Thread.MAX_PRIORITY;
            jobs[i] = new Job(priority);
            Thread thread = new Thread(jobs[i]);
            thread.setPriority(priority);
            thread.start();
        }

        try {
            TimeUnit.SECONDS.sleep(5);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        isEnd = true;

        for (Job job : jobs) {
            System.out.printf("%5d %15d\n", job.priority, job.count);
        }
    }

    private class Job implements Runnable {
        private int priority;
        private int count;

        public Job(int priority) {
            this.priority = priority;
            this.count = 0;
        }

        public void run() {
            try {
                cyclicBarrier.await();
                while (!isEnd) {
                    this.count++;
                    Thread.yield();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
```
很显然，你需要运行一下上面的代码。

## 线程的状态
state | 说明
------- | ----------
NEW | 初始状态，线程被构建，但还没调start()
RUNNABLE | 运行状态，Java将操作系统中的就绪和运行中两种状态笼统称为“RUNNABLE”
BLOCKED | 阻塞状态，表示线程阻塞于锁
WAITING | 等待状态，需要等待其它线程做出一些特定操作（通知或中断）
TIME_WAITING | 超时等待，不同于WAITING，它可以在指定时间后自行返回
TERMINATED | 终止状态，线程执行完毕

<!-- more -->
![](state.svg)

## Daemon线程
```java
package chapter04;

/**
 * Created by hero on 17-3-15.
 */
public class DaemonThread {

    public static void run() {
        Thread daemon = new Thread(new Runnable() {
            public void run() {
                try {
                    System.out.println("daemon running...");
                } finally {
                    /**
                     * finally may not be executed
                     */
                    System.out.println("hello world");
                }
            }
        });
        daemon.setDaemon(true);
        daemon.start();
    }

    public static void main(String[] args) {
        run();
    }
}
```
**daemon线程中的finally有可能不会被执行。**
JVM中若不存在非daemon线程时，会将Daemon线程立即终止，这样就会造成finally不会被执行。

# 启动和终止线程
规范：最好给自定义的线程起个名字，便于jstack分析等。

## 理解中断
```java
package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * Created by hero on 17-3-15.
 */
public class InterruptYou {

    public static void main(String[] args) {
        InterruptYou test = new InterruptYou();
        test.run();
    }

    public void run() {
        Thread sleepBeauty = new Thread(new sleepRunner(), "sleepBeauty");
        Thread keepRunning = new Thread(new keepingRunner(), "keepRunning");
        sleepBeauty.start();
        keepRunning.start();
        try {
            TimeUnit.SECONDS.sleep(3);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        sleepBeauty.interrupt();
        keepRunning.interrupt();
        System.out.println("sleep " + sleepBeauty.isInterrupted());
        System.out.println("keep " + keepRunning.isInterrupted());
    }

    private class sleepRunner implements Runnable {

        public void run() {
            try {
                TimeUnit.SECONDS.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                System.out.println("wow");
            }
        }
    }

    private class keepingRunner implements Runnable {

        public void run() {
            try {
                while (true) {
                }
            } finally {
                System.out.println("hoops");
            }
        }
    }
}
```
一个线程被成功中断，那它的中断标志位被复位，即置成false，随后抛出中断异常。
若被中断骚扰了一下并没有停止，那中断标志位就会置成true。

## 优雅的终止线程
```java
package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * Created by hero on 17-3-15.
 */
public class ElegantTerminate {

    public static void main(String[] args) {
        new ElegantTerminate().run();
    }

    public void run() {
        Runner runner = new Runner();
        Thread thread = new Thread(runner, "control terminate");
        thread.start();
        try {
            TimeUnit.SECONDS.sleep(2);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        runner.cancel();
    }

    private class Runner implements Runnable {
        private volatile boolean isOn;

        public Runner() {
            isOn = true;
        }

        public void run() {
            while (isOn) {
                System.out.println("I'm running");
                try {
                    TimeUnit.MILLISECONDS.sleep(200);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }

        public void cancel() {
            isOn = false;
        }
    }
}
```

## 等待/通知机制
> 原来线程被唤醒是从wait()之后开始执行，保存了线程上下文的。
> 我之前以为是线程重新从头开始执行，唉，惭愧惭愧！

```java
package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * Created by hero on 17-3-15.
 */
public class NotifyWait {
    private static Object lock = new Object();
    private boolean flag = true;

    public void run() throws InterruptedException {
        Thread teacher = new Thread(new Notifier(), "hello");
        Thread student = new Thread(new Waiter(), "world");

        student.start();
        TimeUnit.SECONDS.sleep(2);
        teacher.start();
    }

    public static void main(String[] args) throws InterruptedException {
        new NotifyWait().run();
    }

    private class Notifier implements Runnable {

        public void run() {
            synchronized (lock) {
                flag = false;
                System.out.println("Notifier");
                lock.notify();
            }
        }
    }

    private class Waiter implements Runnable {

        public void run() {
            synchronized (lock) {
                System.out.println("抢一把锁");
                while (flag) {
                    try {
                        System.out.println("我要睡了");
                        lock.wait();
                        System.out.println("把我叫醒");
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
                System.out.println("Waiter");
                lock.notify();
            }
        }

    }
}
```
## ThreadLocal的使用
```java
package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * Created by hero on 17-3-16.
 */
public class MarkInThread {
    public static final ThreadLocal<Integer> flag = new ThreadLocal<Integer>();

    public void copyA() {
        flag.set(8);
        System.out.println(flag.get());
    }

    public void copyB() {
        System.out.println(flag.get());
    }

    public static void main(String[] args) {
        MarkInThread test = new MarkInThread();
        test.run();
    }

    public void run() {

        Thread w = new Thread(new Runnable() {
            public void run() {
                copyA();
            }
        }, "copyA");
        Thread r = new Thread(new Runnable() {
            public void run() {
                copyB();
            }
        }, "copyB");

        w.start();
        r.start();
    }
}
```
ThreadLocal对象的set(value)方法会将value写到当前thread的map<ThreadLocal, Object>中，而且key是弱引用。
好处是get和set可以在不同方法或者类中，但是要看清，必须在同一个线程哦。
重写initialValue方法就是为避免未调过set而直接调get得到null。
当本地map为null时setInitialValue会调这个重写的方法，就是多态么。
```java
ThreadLocal<Integer> flag = new ThreadLocal<Integer>() {
        @Override
        protected Integer initialValue() {
            return 0;
        }
```
# 线程应用实例
## notify和notifyAll的区别
```java
package chapter04;

import java.util.concurrent.TimeUnit;

/**
 * Created by hero on 17-3-18.
 */
public class DiffNotify {

    public static void main(String[] args) throws InterruptedException {
        new DiffNotify().run();
    }

    public void run() throws InterruptedException {
        final Object lock = new Object();
        Thread t1 = new Thread(new Runnable() {
            public void run() {
                synchronized (lock) {
                    try {
                        lock.wait(10 * 1000);
                        System.out.println("t1");

                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        });
        Thread t2 = new Thread(new Runnable() {
            public void run() {
                synchronized (lock) {
                    try {
                        lock.wait(10 * 1000);
                        System.out.println("t2");
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                }
            }
        });

        t1.start();
        t2.start();

        TimeUnit.SECONDS.sleep(1);

        synchronized (lock) {
            lock.notifyAll();
            //lock.notify();
        }
    }
}
```
搞懂notify和notifyAll的区别在设计连接池中比较有用，并且在设计其它程序时可以根据它们的特性进行最优选择。
还记得线程有哪些状态吗？notify和notifyAll都是把在WAITING状态的线程叫醒，区别在于notify只叫一个，notifyAll是叫醒所有。
醒来的线程并不是直接进入RUNNABLE的，这个图中画的不准确。而是进入BLOCKED，因为要重新对锁的获取。notify的还好说，
关键是notifyAll的那些，如果它们被叫醒并且又没有争到锁，它们会去哪。
它们还是会在BLOCKED状态，继续等着下一轮的竞争。

分别运行上面的程序，就会发现：
当lock.notifyAll的时候，第1个线程释放锁之后第2个马上就得到锁，两个线程非常快都结束了。
当lock.notify的时候，第2个线程要等到timeout了才结束，而第1个获取了锁的线程早早的已经把锁释放了，只是由于没有notify一下，所以
第2个线程只能在等待队列中继续等着。

区别很明显了，那什么时候用notify，什么时候用notifyAll呢？聪明的你肯定会列出它俩的优缺点比较一下吧。
我就说个简单的区别，notifyAll会把所有等待线程叫醒，让它们一起竞争。它们竞争一轮就会有一个线程得到锁，竞争N轮之后到最后一个线程也
得到锁才算结束。如果有大量的等待线程，而它们每个对锁占有很长时间之后才释放，这就会造成有大量的BLOCKED线程在浪费cpu，不推荐。
如果它们对锁的占有时间少，并且接下来它们抢的资源不构成竞争关系，那就notifyAll好了，因为这样就不必每次释放锁都要notify一下。

## 简单线程池
池子是一个95后脱口秀演员，额，sorry，今天不聊他。
一言不合就上代码：
```java
package chapter04;

import java.sql.Connection;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Created by hero on 17-3-18.
 */
public class ConnectionPoolTest {
    static final int _COUNT = 100;
    static final int _SIZE = 8;
    static final long _WAIT_TIME_IN_MILLIS = 100;
    static PoolA pool = new PoolA(_SIZE);
    static CountDownLatch start = new CountDownLatch(1);
    static CountDownLatch end;

    public static void main(String[] args) throws InterruptedException {
        end = new CountDownLatch(_COUNT);
        AtomicInteger got = new AtomicInteger();
        AtomicInteger notGot = new AtomicInteger();
        for (int i = 0; i < _COUNT; i++) {
            Thread thread = new Thread(new ConnectionRunner(got, notGot), "ConnectionRunnerThread" + i);
            thread.start();
        }
        long fire = System.currentTimeMillis();
        start.countDown();
        end.await();
        long cost = System.currentTimeMillis() - fire;
        System.out.println("total invoke: " + (_COUNT));
        System.out.println("got connection: " + got);
        System.out.println("not got connection " + notGot);
        System.out.println(cost);
    }

    static class ConnectionRunner implements Runnable {
        AtomicInteger got;
        AtomicInteger notGot;

        public ConnectionRunner(AtomicInteger got, AtomicInteger notGot) {
            this.got = got;
            this.notGot = notGot;
        }

        public void run() {

            try {
                start.await();
                Connection connection = pool.fetchConnection(_WAIT_TIME_IN_MILLIS);
                if (connection != null) {
                    try {
                        connection.createStatement();
                        connection.commit();
                    } finally {
                        pool.releaseConnection(connection);
                        got.incrementAndGet();
                    }
                } else {
                    notGot.incrementAndGet();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            end.countDown();
        }
    }
}
```
```java
package chapter04;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.Connection;
import java.util.concurrent.TimeUnit;

/**
 * Created by hero on 17-3-16.
 */
public class ConnectionDriver {

    /**
     * 创建一个Connection代理
     */
    public static final Connection createConnection() {
        return (Connection) Proxy.newProxyInstance(ConnectionDriver.class.getClassLoader(),
                new Class[]{Connection.class}, new ConnectionHandler());
    }

    private static class ConnectionHandler implements InvocationHandler {
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            if (method.getName().equals("commit")) {
                TimeUnit.MILLISECONDS.sleep(50);
            }
            return null;
        }
    }
}
```
```java
package chapter04;

import java.sql.Connection;
import java.util.LinkedList;

/**
 * Created by hero on 17-3-16.
 */
public class PoolA {
    private LinkedList<Connection> pool = new LinkedList<Connection>();

    public PoolA(int initialSize) {
        for (int i = 0; i < initialSize; i++) {
            pool.addLast(ConnectionDriver.createConnection());
        }
    }

    public void releaseConnection(Connection connection) {
        if (connection != null) {
            synchronized (pool) {
                pool.addLast(connection);
                pool.notifyAll();
            }
        }
    }

    public Connection fetchConnection(long millis) throws InterruptedException {
        synchronized (pool) {
            long future = System.currentTimeMillis() + millis;
            long remaining = millis;
            while (pool.isEmpty() && remaining > 0) {
                pool.wait(millis);
                remaining = future - System.currentTimeMillis();
            }
            if (pool.isEmpty()) return null;
            else return pool.removeFirst();
        }
    }
}
```
```java
package chapter04;

import java.sql.Connection;
import java.util.LinkedList;

/**
 * PoolB 与PoolA有两个地方不一样
 * 我之前好奇，为什么PoolA会计算future，唤醒或超时醒不都是在占有pool锁么，那既然占有pool锁pool肯定不是空的啊
 * 错了，占有pool锁不代表pool就是不空的。
 * notifyAll会叫醒所有等待线程，然后它们再抢占pool锁，第一个抢到锁的肯定就得到一个Connection了
 * 得到之后就释放锁，让后面的继续竞争。后面的这些就会面临pool又empty了。
 * 我改变了一下
 * 把notifyAll改成notify，在while中不计算remaining而是直接break；
 */
public class PoolB {
    private LinkedList<Connection> pool = new LinkedList<Connection>();

    public PoolB(int initialSize) {
        for (int i = 0; i < initialSize; i++) {
            pool.addLast(ConnectionDriver.createConnection());
        }
    }

    public void releaseConnection(Connection connection) {
        if (connection != null) {
            synchronized (pool) {
                pool.addLast(connection);
                /**
                 * 1.这里不一样
                 */
                pool.notify();
            }
        }
    }

    public Connection fetchConnection(long millis) throws InterruptedException {
        synchronized (pool) {
            while (pool.isEmpty() && millis > 0) {
                pool.wait(millis);
                /**
                 * 2.这里不一样
                 */
                break;
            }
            if (pool.isEmpty()) return null;
            else return pool.removeFirst();
        }
    }
}
```
## 线程池示例
```java
package chapter04;

/**
 * Created by hero on 17-3-18.
 */
public interface ThreadPool<Job extends Runnable> {
    void execute(Job job);
    void shutdown();
    int getJobSize();
}
```
```java
package chapter04;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Created by hero on 17-3-18.
 */
public class DefaultThreadPool<Job extends Runnable> implements ThreadPool<Job> {
    private static final int MAX_WORKER_NUMBERS = 10;
    private static final int DEFAULT_WORKER_NUMBERS = 5;
    private static final int MIN_WORKER_NUMBERS = 1;
    private volatile boolean running = true;
    private final LinkedList<Job> jobs = new LinkedList<Job>();
    private final List<Worker> workers = Collections.synchronizedList(new ArrayList<Worker>());
    private static int workerNumbers = DEFAULT_WORKER_NUMBERS;
    private AtomicLong workerNumber = new AtomicLong();

    public DefaultThreadPool() {
        initializeWorkers(DEFAULT_WORKER_NUMBERS);
    }

    public DefaultThreadPool(int workerNumbers) {
        this.workerNumbers = workerNumbers > MAX_WORKER_NUMBERS ? MAX_WORKER_NUMBERS : workerNumbers < MIN_WORKER_NUMBERS ? MIN_WORKER_NUMBERS : workerNumbers;
        initializeWorkers(this.workerNumbers);
    }

    public void execute(Job job) {
        if (job != null) {
            synchronized (jobs) {
                jobs.addLast(job);
                jobs.notify();
            }
        }
    }

    public void shutdown() {
        running = false;
        /**
         * 书中没有下面这个notifyAll
         * 因为running在外面，即使设成false但jobs还是empty，程序就不会跳出内循环
         * 同样的，书中的removeWorkers也错了
         * 建议不要再更改pool的大小
         */
        synchronized (jobs) {
            jobs.notifyAll();
        }
    }

    public int getJobSize() {
        return jobs.size();
    }

    private void initializeWorkers(int workerNumbers) {
        for (int i = 0; i < workerNumbers; i++) {
            Worker worker = new Worker();
            workers.add(worker);
            Thread thread = new Thread(worker, "ThreadPool-Worker-" + workerNumber.incrementAndGet());
            thread.start();
        }
    }

    private class Worker implements Runnable {

        public void run() {
            while (running) {
                Job job = null;
                synchronized (jobs) {
                    /**
                     * 书中是while，那样是shutdown不了线程的，应该是if语句
                     */
                    if (jobs.isEmpty()) {
                        try {
                            jobs.wait();
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    } else {
                        job = jobs.removeFirst();
                    }
                }
                if (job != null) {
                    try {
                        job.run();
                    } catch (Exception ex) {
                    }
                }
            }
        }
    }
}
```