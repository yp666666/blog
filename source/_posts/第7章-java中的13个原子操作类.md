---
title: 第7章 java中的13个原子操作类
date: 2017-03-23 21:26:40
category: 并发编程的艺术
tags: reflect
---

[见识见识Unsafe](http://ifeve.com/sun-misc-unsafe/#header)

```java
package chapter07;

import sun.misc.Unsafe;

import java.lang.reflect.Field;

/**
 * Created by hero on 17-3-23.
 * 原子操作
 */
public class UnsafeUtils {
    /** 直接对内存操作的牛逼类，编程时不推荐使用 */
    private static Unsafe unsafe = null;

    /**
     *
     * @param obj
     * @param fieldName
     * @param expect int  long  Object
     * @param update int  long  Object 这3个参数一一对应
     * @return
     */
    public static boolean compareAndSet(Object obj, String fieldName, Object expect, Object update) {
        try {
            init();
            long valueOffset = computeOffset(obj, fieldName);

            if (expect instanceof Integer)
                unsafe.compareAndSwapInt(obj, valueOffset, (Integer) expect, (Integer) update);
            else if (expect instanceof Long)
                unsafe.compareAndSwapLong(obj, valueOffset, (Long) expect, (Long) update);
            else
                unsafe.compareAndSwapObject(obj, valueOffset, expect, update);
            return true;
        } catch (Exception e) {
        }
        return false;
    }

    private static void init() throws Exception {
        if (unsafe == null) {
            Field field = Unsafe.class.getDeclaredField("theUnsafe");
            field.setAccessible(true);
            unsafe = (Unsafe) field.get(null);
        }
    }

    private static long computeOffset(Object obj, String fieldName) throws NoSuchFieldException {
        return unsafe.objectFieldOffset(obj.getClass().getDeclaredField(fieldName));
    }

    public static void main(String[] args) {
        Email email = new Email("zxf@123.com");
        User user = new User("carl", 999, email);

        Email email1 = new Email("hello.456");

        System.out.println(user);
        UnsafeUtils.compareAndSet(user, "name", "carl", "hhh");
        UnsafeUtils.compareAndSet(user, "age", 999, 99);
        UnsafeUtils.compareAndSet(user, "email", email, email1);
        System.out.println(user);
    }
}
```
之前我就问过它为什么叫unsafe，从这里就可以看出，它违背了Java的面向对象的设计思想，更像是c语言在直接对memory操作，割裂了一个对象。就像
一个医生拿刀切开一个人的肚子，换点什么或取点什么东西，完全没有把“人”这个对象放在眼里，医生眼里只有血管和器官。……好恶心的比喻，编不下去了。

违背设计思想是第一个，第二个原因是直接操作memory容易出错。

另：java反射之强大由此可见一斑。
