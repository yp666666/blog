---
title: 第5章 java中的锁
date: 2017-03-19 11:02:43
category: 并发编程的艺术
tags:
---
# Lock接口
```java
	Lock lock = new ReentrantLock(true);
	lock.lock();
	try {

	} finally {
	    lock.unlock();
	}
```
不把lock.lock()写到try{}里面是因为如果这一步出错了，即锁没获取到，finally会执行锁的释放。
Lock比synchronized的优势在于：
- 尝试非阻塞获取锁
- 能被中断的获取锁
- 超时获取锁
对比一下就知道，synchronized就是阻塞获取锁，不能响应中断获取锁，没有超时限制获取锁。

# 队列同步器
这是个可以自定义锁的框架，大神把实现封装好，只需要按照模板方式实现对应的方法，就能很方便的实现一个锁。
同步器是面对锁的实现者，锁面对的是使用者。
```java
package chapter05;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.AbstractQueuedSynchronizer;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;

/**
 * 独占锁
 */
public class Mutex implements Lock {

    public void lock() {
        sync.acquire(1);
    }

    public void lockInterruptibly() throws InterruptedException {
        sync.acquireInterruptibly(1);
    }

    public boolean tryLock() {
        return sync.tryAcquire(1);
    }

    public boolean tryLock(long time, TimeUnit unit) throws InterruptedException {
        return sync.tryAcquireNanos(1, unit.toNanos(time));
    }

    public void unlock() {
        sync.release(1);
    }

    public Condition newCondition() {
        return sync.newCondition();
    }

    public boolean isLocked() {
        return sync.isHeldExclusively();
    }

    public boolean hasQueuedThreads() {
        return sync.hasQueuedThreads();
    }

    private static final long serialVersionUID = 1L;
    private final Sync sync = new Sync();

    static class Sync extends AbstractQueuedSynchronizer {
        private static final long serialVersionUID = 1L;

        @Override
        protected boolean tryAcquire(int arg) {
            if (compareAndSetState(0, 1)) {
                setExclusiveOwnerThread(Thread.currentThread());
                return true;
            }
            return false;
        }

        @Override
        protected boolean tryRelease(int arg) {
            if (getState() == 0) throw new IllegalMonitorStateException();
            /**
             * 这里没有检查当前线程是否是Owner
             * 因为这是个简单的Demo以，所作者做了省略，自己注意就行
             */
            setExclusiveOwnerThread(null);
            setState(0);
            return true;
        }

        @Override
        protected boolean isHeldExclusively() {
            return getState() == 1;
        }

        Condition newCondition() {
            return new ConditionObject();
        }
    }
}
```
这是个简单的定制独占锁，将AbstractQueuedSynchronizer设为static内部类，然后重写一些方法。在Lock方法里把相对应的方法代理给sync，就这么简单。

下面是共享锁Demo
```java
package chapter05;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.AbstractQueuedSynchronizer;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;

/**
 * 共享锁
 */
public class TwinsLock implements Lock {

    public void lock() {
        sync.acquireShared(1);
    }

    public void unlock() {
        sync.releaseShared(1);
    }

    public void lockInterruptibly() throws InterruptedException {
        sync.acquireSharedInterruptibly(1);
    }

    public boolean tryLock() {
        return sync.tryAcquireShared(1) >= 0;
    }

    public boolean tryLock(long time, TimeUnit unit) throws InterruptedException {
        return sync.tryAcquireSharedNanos(1, unit.toNanos(time));
    }

    public Condition newCondition() {
        return sync.newCondition();
    }

    private final Sync sync = new Sync(2);

    static class Sync extends AbstractQueuedSynchronizer {
        public Sync(int count) {
            setState(count);
        }

        @Override
        protected int tryAcquireShared(int reduceCount) {
            for (; ; ) {
                int current = getState();
                int newCount = current - reduceCount;
                if (newCount < 0 || compareAndSetState(current, newCount)) {
                    return newCount;
                }
            }
        }

        @Override
        protected boolean tryReleaseShared(int returnCount) {
            for (; ; ) {
                int current = getState();
                int newCount = current + returnCount;
                /**
                 * 同样，这里也没判断当前线程是否是owner
                 */
                if (compareAndSetState(current, newCount)) {
                    return true;
                }
            }
        }

        @Override
        protected boolean isHeldExclusively() {
            return false;
        }

        Condition newCondition() {
            return new ConditionObject();
        }
    }
}
```
```java
package chapter05;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

/**
 * Created by hero on 17-3-19.
 */
public class MainTest {
    final TwinsLock lock = new TwinsLock();
    final CountDownLatch gun = new CountDownLatch(1);

    public static void main(String[] args) throws InterruptedException {
        new MainTest().run();
    }

    public void run() throws InterruptedException {
        for (int i = 0; i < 10; i++) {
            Thread t = new Thread(new Runner(), "" + i);
            t.setDaemon(true);
            t.start();
        }
        gun.countDown();
        for (int i = 0; i < 10; i++) {
            TimeUnit.MILLISECONDS.sleep(500);
            System.out.println("------------");

        }
    }

    class Runner implements Runnable {
        public void run() {
            try {
                gun.await();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            lock.lock();
            try {
                TimeUnit.MILLISECONDS.sleep(500);
                System.out.println(Thread.currentThread().getName());
                TimeUnit.MILLISECONDS.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            } finally {
                lock.unlock();
            }
        }
    }
}
```

# 重入锁
非公平锁比公平锁更少的上下文切换，所以有更高的吞吐量，但是容易有“饥饿现象”。

# 读写锁
ReentrantLock是排他锁，而读写锁可以在同一时间允许多个读线程访问。
> 一般情况下，读写锁的性能都会比排它锁好，因为大多数场景读是多于写的。在读多于写的情况下，读写锁能够提供比排他锁更好的并发性和吞吐量。

```java
package chapter05;

import java.util.HashMap;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

/**
 * Created by hero on 17-3-19.
 */
public class DIYCache {
    private HashMap<String, String> cache = new HashMap<String, String>();
    private final ReentrantReadWriteLock rwLock = new ReentrantReadWriteLock();
    private final Lock rLock = rwLock.readLock();
    private final Lock wLock = rwLock.writeLock();

    public final String get(String key) {
        rLock.lock();
        try {
            return cache.get(key);
        } finally {
            rLock.unlock();
        }
    }

    public final void put(String key, String value) {
        wLock.lock();
        try {
            cache.put(key, value);
        } finally {
            wLock.unlock();
        }
    }

    public final void clear() {
        wLock.lock();
        try {
            cache.clear();
        } finally {
            wLock.unlock();
        }
    }
}
```

## 读写锁的实现分析
这个放到以后源代码分析中。

# LockSupport工具
# Condition接口
有界队列Demo
```java
package chapter05;

import java.util.PriorityQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Created by hero on 17-3-20.
 */
public class BoundedQueue<T> {
    private PriorityQueue<T> que;
    private int capacity = 0;
    private final ReentrantLock lock = new ReentrantLock();
    private final Condition empty = lock.newCondition();
    private final Condition full = lock.newCondition();

    public static void main(String[] args) {
        final BoundedQueue<Integer> que = new BoundedQueue<Integer>(5);
        Thread t1 = new Thread(new Runnable() {
            public void run() {
                for (int i = 0; i < 10; i++) {
                    que.add(i);
                    System.out.println("add=" + i);
                    try {
                        // TimeUnit.SECONDS.sleep(1);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        });
        Thread t2 = new Thread(new Runnable() {
            public void run() {
                while (true) {
                    try {
                        TimeUnit.SECONDS.sleep(2);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    int t = que.peek();
                    System.out.println("peek=" + t);
                }
            }
        });
        t2.setDaemon(true);

        t2.start();
        t1.start();
    }

    BoundedQueue(int capacity) {
        this.capacity = capacity;
        que = new PriorityQueue<T>(capacity);
    }

    public void add(T t) {
        lock.lock();
        try {
            if (capacity == que.size()) {
                System.out.println("----- full -----");
                full.await();
            }
            que.add(t);
            empty.signal();
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
    }

    public T peek() {
        lock.lock();
        try {
            if (0 == que.size()) {
                System.out.println("---- empty -----");
                empty.await();
            }
            T t = que.peek();
            que.remove(t);
            full.signal();
            return t;
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock();
        }
        return null;
    }

    public int getCapacity() {
        return capacity;
    }
}
```

# Condition的实现分析