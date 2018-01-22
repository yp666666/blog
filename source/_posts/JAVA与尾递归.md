---
title: JAVA与尾递归
date: 2018-01-22 20:54:11
category:
tags:
---
[[Java 8] (8) Lambda表达式对递归的优化(上) - 使用尾递归](http://blog.csdn.net/dm_vincent/article/details/40581859)
[在Java中谈尾递归--尾递归和垃圾回收的比较](https://www.cnblogs.com/bellkosmos/p/5280619.html)

什么是“尾递归”
深度为1的递归调用，称为尾递归。
举个例子，如果求整数n到1的和，通常的递归写法大都这样：
```java
fun(int n){
	if(n == 0) {
		return n;
	} else {
		return n + fun(n-1);
	}
}
fun(20000);
```
在Java内存模型中，对方法的引用方在一个专门的栈里，并且不会很大(配置-Xss时JVM会提示最小160k)，栈的深度不等于栈的大小，但是会受大小的影响。一般2万次的递归调用就会报“StackOverflow”。换言之，这种写法就限制了它的调用深度不能超过2万，但如果是尾递归，深度永远是1，所以不会出现栈溢出的情况：
```java
fun(int n, int r){
	return n==1?r:fun(n-1, n+r);
}
fun(20000, 1);
```
竟然如此刺激，你还不赶快去撸一把代码测试下！！！

（没撸代码的童鞋不准往下看）

哈哈，发现被捉弄了，尾递归的写法毛用没有，照样栈溢出了。
不错，在Java的王国里，根本就不存在所谓的尾递归。“尾递归”的由来是C语言编译器对C语言的递归代码做的一种优化处理，它曾经让一个狂人因他的一段代码而名扬四海，有兴趣的可以百度一下他的那段代码，他叫[王垠](https://baike.baidu.com/link?url=-kwHpmgU0ezYaYS6s7eqvZp9jMenJch2XOPjxRkVKWGbA6zuyVcPhYSZklHfGYKG4hMOAjWU698S_9Zzhal_ZHLrKUiiQ68cVaTM_kT0Dxm)。尾递归的原理就是递归函数的状态(即每次执行完的结果)是独立存在的，对自身的调用语句是一个单独的表达式。如<code>return fun(n-1, n+r)</code>，函数的状态完全由n和r来保存，对自身的调用是独立的，不像<code>return n + fun(n-1)</code>函数的调用和n有一一对应的关系，如果想知道最终结果就必须知道`n+fun(n-1)`，这样每次递归都要记住n对应的函数栈针`fun(n-1)`，n-1对应的栈针`fun(n-2)`...把递归改成`fun(n, r)`这种形式后，递归就无需记住状态了，编译器就会循环利用一个栈针，这就是尾递归。
尾递归这么好的东西，为什么Java没有？因为开发JDK的人觉得不需要，与其把递归改写成尾递归形式让编译器去优化，倒不如不用递归。（可能吧，但是我仍然觉得写成尾递归更简洁）Python、js也没有尾递归，似乎只有C语言才有。虽然Java没有向尾递归妥协，但是向函数编程妥协了，使用Lambda表达式可以让代码量更少，逻辑更直观。Java的Lambda表达式应该和Spark的一样，都借鉴于Scala。利用Stream的惰性求值性质可以在Java中模拟一下尾递归：
```java
package test;

import java.util.stream.Stream;

public class Lambda {

    @FunctionalInterface
    public interface TailRecursion<T> {
        TailRecursion<T> apply();

        default boolean isFinished() {
            return false;
        }

        default T getResult() {
            throw new IllegalStateException();
        }

        default T invoke() {
            return Stream.iterate(this, TailRecursion::apply)
                    .filter(TailRecursion::isFinished)
                    .findFirst().get().getResult();
        }
    }


    private static TailRecursion<Long> factorial(Long n, Long r) {
        if (n == null || n <= 0)
            throw new IllegalArgumentException();
        return n == 1 ?
                new TailRecursion<Long>() {

                    @Override
                    public TailRecursion<Long> apply() {
                        throw new IllegalStateException();
                    }

                    @Override
                    public boolean isFinished() {
                        return true;
                    }

                    @Override
                    public Long getResult() {
                        return r;
                    }
                }
                : () -> factorial(n - 1, n + r);
    }


    public static void main(String[] args) {
        long c = 10000000000l;
        long start = System.currentTimeMillis();
        System.out.println(factorial(c, 1l).invoke());
        long finish = System.currentTimeMillis();
        System.out.println(finish - start);    //136164
        long a = 1l;
        start = System.currentTimeMillis();
        for (long i = 2; i <= c; i++) {
            a += i;
        }
        System.out.println(a);
        finish = System.currentTimeMillis();
        System.out.println(finish - start);    //6125
    }
}
```
看一下计算时间，尽管可以模拟尾递归，但是这差距也太大了，所以能不用递归最好就不用。