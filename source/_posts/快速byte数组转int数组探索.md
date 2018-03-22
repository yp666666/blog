---
title: 快速byte数组转int数组探索
date: 2018-03-14 23:34:08
category: java
tags:
---
如何快速的将byte数组转成int数组？
先不考虑为什么要这样转，想想如何实现才能高效的转换！
大家应该都用过System的这个方法：
```java
public static native void arraycopy(Object src,  int  srcPos,
                                        Object dest, int destPos,
                                        int length);
```
它是块拷贝，是内存级别的，比对象赋值要快。可是它不能用于两个不同的对象数组的拷贝。这是因为Java世界里万事万物都是对象，即便是个int类型，int a = 9，它也是一个对象，它代表了对象a的value值为9。在内存中，a对象占了不止4个字节的大小，假如a在内存中的位置为0x00到0x05，那么它的属性value可能在偏移2个字节的位置，即value的物理位置为0x02到0x05。
Java的块拷贝之所以快，就是因为它会计算对象的所有字段的偏移量，根据偏移量去内存复制。
同样是块拷贝，C语言就没有对象的概念，内存复制跟类型无关，所以Java+C应该能优化此类需求。
暂时还没想出更好的办法，以后有灵感了再琢磨。
没有卵用的发现：用Unsafe类去拷贝byte数组到int数组时发现高位存到了低位，成小端模式了（我的电脑是Mac），如果想把byte存到int的最高位字节，需要向后偏移3个字节。而Java本身默认是使用大端模式来转的，点进ByteBuffer.wrap(byte[]).getInt()这个方法可以看到，Java使用的是大端模式。所以Unsafe的使用还跟操作系统有关系，而使用ByteBuffer等类就是独立于操作系统了。
```java
package test;

import sun.misc.Unsafe;

import java.lang.reflect.Field;
import java.nio.ByteBuffer;

/**
 * @author hero
 */
public class FastBytesToInts {
    public static void main(String[] args) throws NoSuchFieldException, IllegalAccessException {
        String s = "abcdEFG";
        byte[] bs = s.getBytes();
        System.out.println("length=" + bs.length);
        printf(bs);
        int[] is = new int[2];
        Field field = Unsafe.class.getDeclaredField("theUnsafe");
        field.setAccessible(true);
        Unsafe unsafe = (Unsafe) field.get(null);
        unsafe.copyMemory(bs, Unsafe.ARRAY_BYTE_BASE_OFFSET, is, Unsafe.ARRAY_INT_BASE_OFFSET + 3, 1);
        unsafe.copyMemory(bs, Unsafe.ARRAY_BYTE_BASE_OFFSET + 1, is, Unsafe.ARRAY_INT_BASE_OFFSET + 2, 1);
        unsafe.copyMemory(bs, Unsafe.ARRAY_BYTE_BASE_OFFSET + 2, is, Unsafe.ARRAY_INT_BASE_OFFSET + 1, 1);
        unsafe.copyMemory(bs, Unsafe.ARRAY_BYTE_BASE_OFFSET + 3, is, Unsafe.ARRAY_INT_BASE_OFFSET, 1);
        unsafe.copyMemory(bs, Unsafe.ARRAY_BYTE_BASE_OFFSET + 4, is, Unsafe.ARRAY_INT_BASE_OFFSET + 4 + 3, 1);
        unsafe.copyMemory(bs, Unsafe.ARRAY_BYTE_BASE_OFFSET + 5, is, Unsafe.ARRAY_INT_BASE_OFFSET + 4 + 2, 1);
        unsafe.copyMemory(bs, Unsafe.ARRAY_BYTE_BASE_OFFSET + 6, is, Unsafe.ARRAY_INT_BASE_OFFSET + 4 + 1, 1);
        printf(is);
        System.out.println(intToBits(toInt(new byte[]{bs[0], bs[1], bs[2], bs[3]})));
        System.out.println(intToBits(ByteBuffer.wrap(new byte[]{bs[0], bs[1], bs[2], bs[3]}).getInt()));
    }

    public static int toInt(byte[] bs) {
        return (bs[0] << 24)
                | ((bs[1] & 0xff) << 16)
                | ((bs[2] & 0xff) << 8)
                | (bs[3] & 0xff);
    }

    public static void printf(byte[] bs) {
        for (byte b : bs) {
            System.out.print(byteToBits(b));
        }
        System.out.println();
    }

    public static void printf(int[] is) {
        for (int i : is) {
            System.out.print(intToBits(i));
        }
        System.out.println();
    }

    public static String byteToBits(byte digit) {
        return toBits(digit, 8);
    }

    public static String intToBits(int digit) {
        return toBits(digit, 32);
    }

    private static String toBits(int digit, int capacity) {
        char[] buff = new char[capacity];
        for (int i = capacity - 1; i > -1; i--) {
            buff[i] = (digit & 0x01) > 0 ? '1' : '0';
            digit = digit >>> 1;
        }
        return new String(buff);
    }
}
```
### offset & sizeof
[Unsafe的sizeOf](http://mishadoff.com/blog/java-magic-part-4-sun-dot-misc-dot-unsafe/)
```java
package test;

import sun.misc.Unsafe;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.HashSet;


public class Test {

    static Unsafe unsafe;

    static {
        try {
            Field field = Unsafe.class.getDeclaredField("theUnsafe");
            field.setAccessible(true);
            unsafe = (Unsafe) field.get(null);
        } catch (Exception e) {
            throw new Error(e);
        }
    }

    public static void main(String[] args) throws IllegalAccessException, NoSuchFieldException {
        System.out.println("offset");
        System.out.println(offset(Byte.class, "value"));//12
        System.out.println(offset(Integer.class, "value"));//12
        System.out.println(offset(Long.class, "value"));//16
        System.out.println("sizeof");
        System.out.println(sizeof((byte) 0xff));//Byte, 16
        System.out.println(sizeof(0));//Integer, 16
        System.out.println(sizeof(0l));//Long, 24
    }

    public static long offset(Class c, String fieldName) throws NoSuchFieldException {
        return unsafe.objectFieldOffset(c.getDeclaredField(fieldName));
    }

    public static long sizeof(Object o) {
        Unsafe u = unsafe;
        HashSet<Field> fields = new HashSet<>();
        Class c = o.getClass();
        while (c != Object.class) {
            for (Field f : c.getDeclaredFields()) {
                if ((f.getModifiers() & Modifier.STATIC) == 0) {
                    fields.add(f);
                }
            }
            c = c.getSuperclass();
        }

        // get offset
        long maxSize = 0;
        for (Field f : fields) {
            long offset = u.objectFieldOffset(f);
            if (offset > maxSize) {
                maxSize = offset;
            }
        }
        //取最大偏移量然后这样计算就是Object的内存大小？？？
        return ((maxSize / 8) + 1) * 8;   // padding
    }
}
```
另一种计算sizeof的方式
[Instrumentation的sizeOf](https://stackoverflow.com/questions/52353/in-java-what-is-the-best-way-to-determine-the-size-of-an-object)

```java
import test.Test;

/**
 * @author hero
 */
public class C {
    private int x;
    private long y;

    public static void main(String[] args) {
        System.out.println(ObjectSizeFetcher.getObjectSize(0));//16
        System.out.println(ObjectSizeFetcher.getObjectSize(0L));//24
        System.out.println(ObjectSizeFetcher.getObjectSize(new C()));//24

        System.out.println(Test.sizeof(0));//16
        System.out.println(Test.sizeof(0L));//24
        System.out.println(Test.sizeof(new C()));//24

        System.out.println(Test.offset(C.class, "x"));//12
        System.out.println(Test.offset(C.class, "y"));//16
    }
}

```
两种方法结果一样，但是这也不能解释为什么对象C的大小是24个字节吧。Java的sizeof也就这样了，它的计算意义不大，因为Java对象的字段有的是static，有的是共享缓存对象：IntegerCache的[-128, 127]，你很难分清哪些是共享了同一个instance。
x在C中的偏移量就是x到C实例所在内存区域开始处相差的字节数。通过偏移量可看出y与x相差4个字节，正好是int的字节个数。