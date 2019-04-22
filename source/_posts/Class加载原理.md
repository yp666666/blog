---
title: Class加载原理
date: 2017-03-27 21:49:11
category: java
tags: reflect
---
今天想利用类加载机制写一个单例类,结果发现自己不会写了,内部类没有写成static,搞不懂为什么在外部类中不能new这个内部类------当然不能,因为外部类的这个方法是static的,而这个内部类不是static,不要以为这样就结束了,原理你清楚吗?

**参考文献**
[Internals of Java Class Loading](http://www.onjava.com/pub/a/onjava/2005/01/26/classloading.html)
[深入探讨Java类加载器](https://www.ibm.com/developerworks/cn/java/j-lo-classloader/#toggle)

## Class和Data
class代表一段可执行的代码(code),data代表这段代码的情形(state).
白话文就是class就像一个简历模板,data就是填写的信息.
state是会改变的,而code一般不会改变.class+data就是一个instance.
每个class都会在一个.class文件中保存它的信息,任何java类被编译时都会被嵌入一个类型是java.lang.Class的class字段,我们可以这样得到它:java.lang.Class clazz = Myclass.class;重点来了,一旦一个class被JVM加载了,相同的class就不会再被加载.哎哎哎,怎样才叫"相同的class"?在JVM中,一个完整的类名包括包名和类名本身,除此之外JVM还会结合加载这个class的ClassLoader实例来判断两个类是否相同.假如class叫Cl,in package Pg中,被KlassLoader实例Kll加载,那么Cl在JVM中的唯一标识就是(Cl, Pg, Kll),这就意味着(Cl, Pg, Kll)和(Cl, Pg, Cll)是两个不同的类.在JVM中它们不能cast,永远不能成为对方的实例.
那么,在JVM中,到底有多少ClassLoader的实例呢?

## Class Loaders
在JVM中,所有class都是被java.lang.ClassLoader的一些实例加载的.我们也可以继承它来定制自己的classloader.
当敲入命令java MyMainClass启动JVM时,the "bootstrap class loader"负责加载Java核心类如java.lang.Object和其它运行时类(runtime code)到内存中.运行时类在JRE\lib\rt.jar文件中.我们是获取不到bootstarp class loader的任何细节的,因为它是native实现,同样,bootstrap class loader进入JVM的行为肯定有异于其它classloader.
例证一下,尝试获取一个核心类的classloader,你只会得到一个null.
```java
    @Test
    public void test() {
        ClassLoader loader = String.class.getClassLoader();
        if (loader != null) {
            System.out.println(loader.getClass().getName());
        } else {
            System.out.println("null");
        }
    }
```
接下来,就是java扩展类加载器(Java extension class loader).我们可以保存一些与core java runtime code无关的外部libraries,放在java.ext.dirs属性指定的目录下(/usr/lib/jvm/jdk8/jre/lib/ext
),ExtClassLoader会负责把所有jar文件全部加载进来.
第三种,也是最重要的class loader,APPClassLoader.它会把java.class.path属性下所有的classes都加载进来.
```bash
-> echo $CLASSPATH
-> .:/usr/lib/jvm/jdk8/lib:/usr/lib/jvm/jdk8/jre/lib
```
> 其它一些class loader还有:
java.net.URLClassLoader
java.security.SecureClassLoader
java.rmi.server.RMIClassLoader
sum.applet.AppletClassLoader

java.lang.Thread包含一个方法public ClassLoader getContextClassLoader().它是由线程的创建者提供用来加载classes和resources的.如果当前线程没有设置,就会默认使用它父线程的class loader context.

## How Class Loaders Work
除bootstrap class loader之外所有的class loader都有父类class loader.并且所有class loader的类型都是java.lang.ClassLoader.理解上面这两句话对开发自己的ClassLoader非常重要.最关键的就是正确设置父类ClassLoader.父类Classloader就是加载该Classloader的对象实例.(记住,一个classloader本身也是个class)
它是如何工作的呢,来看下源码:
```java
protected Class<?> loadClass(String name, boolean resolve)
        throws ClassNotFoundException
    {
    	//在ConcurrentMap中<name, Object>来设置锁控制并发
        synchronized (getClassLoadingLock(name)) {
            //首先,检查这个类是否已经加载了
            Class<?> c = findLoadedClass(name);
            if (c == null) {
                long t0 = System.nanoTime();
                try {
                    if (parent != null) {
                        //如果有parent class loader就使用父类加载这个类
                        //由此可见,永远是处在顶端的class loader在加载类,就跟并查集算法一样道理
                        c = parent.loadClass(name, false);
                    } else {
                        //用bootstrap class loader去加载
                        //因为没有parent class loader的只有bootstrap class loader了
                        c = findBootstrapClassOrNull(name);
                    }
                } catch (ClassNotFoundException e) {
                    // ClassNotFoundException thrown if class not found
                    // from the non-null parent class loader
                }

                if (c == null) {
                    // 连bootstrap class loader都没找到,只能调你自己重写的findClass方法去加载了
                    // findClass默认的是直接抛出ClassNotFoundException
                    long t1 = System.nanoTime();
                    c = findClass(name);

                    // this is the defining class loader; record the stats
                    sun.misc.PerfCounter.getParentDelegationTime().addTime(t1 - t0);
                    sun.misc.PerfCounter.getFindClassTime().addElapsedTimeFrom(t1);
                    sun.misc.PerfCounter.getFindClasses().increment();
                }
            }
            // resolve这个词起的有歧义,明明就是在误导读者
            // 它为true代表是要link这个class,不是什么resolve
            if (resolve) {
                resolveClass(c);
            }
            return c;
        }
    }
```
自己写ClassLoader时要记得设置parent
```java
public class MyClassLoader extends ClassLoader{

    public MyClassLoader(){
        super(MyClassLoader.class.getClassLoader());
    }
}
```
> `<<Java语言规范>>`给出了详细的loading,linking,initialization处理过程.

基本的就是以上这些,根据这个可以看看第二篇文章,为什么两个classloader加载的类可以cast,试试找出原因,让它们不能cast.如果你能够使这个示例报错,说明你已经掌握了classloader的原理了.
忽然看到开头的疑问,本来是想通过了解ClassLoader来解释内部类加载的问题.内部类的加载看来要分开分析了.
```java
package commons;

/**
 * Created by hero on 17-3-27.
 */
public class Singleton {

    public static Singleton getInstance() {
        return Inner.ins;
    }

    public static void print() {
        System.out.println("hello");
    }

    public static void print(String s) {
        Inner.print(s);
    }

    private static class Inner {
        private static final Singleton ins = new Singleton();

        private static void print(String s) {
            System.out.println(s);
        }

        public Inner() {
            System.out.println("inner init");
        }
    }

    private Singleton() {
        System.out.println("init");
    }
}
```
终于可以把上面的坑填了，其实上面这种懒加载写法是关于Class加载时哪些值会被初始化的问题。

```java
public class Test {

    int a;
    static int b = 1;
    static Inner inner;

    static {
        System.out.println("static block b=" + b);
        b = 2;
        System.out.println(inner == null);
    }

    public static void fun() {
        System.out.println("hello");
        inner = new Inner();
    }

    public static void main(String[] args) throws ClassNotFoundException {
        /*System.out.println(Test.class.getName());
        Class.forName(Test.class.getName());*/
        Test.fun();
    }

    static class Inner {
        static {
            System.out.println("inner static block");
        }
    }
}
/**
 * 结果：
 * static block b=1
 * true
 * hello
 * inner static block
 */
```
Class初始化顺序：
- static variables and static initializers in order
- instance variables and instance initializers in order
- constructors

参考[https://www.geeksforgeeks.org/order-execution-initialization-blocks-constructors-java/](https://www.geeksforgeeks.org/order-execution-initialization-blocks-constructors-java/)
[https://www.baeldung.com/java-initialization](https://www.baeldung.com/java-initialization)



