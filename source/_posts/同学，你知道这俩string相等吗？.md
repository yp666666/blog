---
title: 同学，你知道这俩string相等吗？
date: 2017-06-23 20:08:00
category:
tags: java
---

你肯定有这样的经历，
```java
String a = new String("abc");
String b = "ab" + "c";
String t = "a";
String c = t + "bc";
```
请问：a==b？  b==c?  c==a?

#### 让字节码告诉我们真相

> java version "1.8.0_131"
Java(TM) SE Runtime Environment (build 1.8.0_131-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.131-b11, mixed mode)

不同版本的jdk编译优化可能不会一样。

使用命令：`javac -g 类名.java`  `javap -v 类名`

**首先，先看一个最简单的字节码**

```java
package moc;

/**
 * Created by hero on 6/21/17.
 */
public class A {

    public static void main(String[] args) throws Exception {
        String s = "abc";
    }
}

```
```java
Classfile /home/hero/workspace/JavaJava/FirstTry/src/main/java/moc/A.class
  Last modified Jun 23, 2017; size 453 bytes
  MD5 checksum 7e5c6d00c6c47994955bf9ab4989ff94
  Compiled from "A.java"
public class moc.A
  minor version: 0
  major version: 52
  flags: ACC_PUBLIC, ACC_SUPER
Constant pool:
   #1 = Methodref          #4.#22         // java/lang/Object."<init>":()V
   #2 = String             #23            // abc
   #3 = Class              #24            // moc/A
   #4 = Class              #25            // java/lang/Object
   #5 = Utf8               <init>
   #6 = Utf8               ()V
   #7 = Utf8               Code
   #8 = Utf8               LineNumberTable
   #9 = Utf8               LocalVariableTable
  #10 = Utf8               this
  #11 = Utf8               Lmoc/A;
  #12 = Utf8               main
  #13 = Utf8               ([Ljava/lang/String;)V
  #14 = Utf8               args
  #15 = Utf8               [Ljava/lang/String;
  #16 = Utf8               s
  #17 = Utf8               Ljava/lang/String;
  #18 = Utf8               Exceptions
  #19 = Class              #26            // java/lang/Exception
  #20 = Utf8               SourceFile
  #21 = Utf8               A.java
  #22 = NameAndType        #5:#6          // "<init>":()V
  #23 = Utf8               abc
  #24 = Utf8               moc/A
  #25 = Utf8               java/lang/Object
  #26 = Utf8               java/lang/Exception
{
  public moc.A();
    descriptor: ()V
    flags: ACC_PUBLIC
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 6: 0
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0       5     0  this   Lmoc/A;

  public static void main(java.lang.String[]) throws java.lang.Exception;
    descriptor: ([Ljava/lang/String;)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=1, locals=2, args_size=1
         0: ldc           #2                  // String abc
         2: astore_1
         3: return
      LineNumberTable:
        line 13: 0
        line 14: 3
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0       4     0  args   [Ljava/lang/String;
            3       1     1     s   Ljava/lang/String;
    Exceptions:
      throws java.lang.Exception
}
SourceFile: "A.java"
```
只需要看常量池，
`#2 = String             #23            // abc`
即地址#2内是String类型，值在#23内，为“abc”。
`0: ldc           #2                  // String abc`
`2: astore_1`
`3: return`
把#2内引用置栈顶，赋给slot 1，结束。

jvm应该会在运行时，执行到String s = "abc";时创建一个String对象“abc”在heap，然后将其引用放入常量池中。s就直接拿常量池中的引用赋值。


**第二个**
```java
package moc;

/**
 * Created by hero on 6/21/17.
 */
public class A {

    public static void main(String[] args) throws Exception {
        String a = new String("abc");
    }
}
```
```java
Classfile /home/hero/workspace/JavaJava/FirstTry/src/main/java/moc/A.class
  Last modified Jun 23, 2017; size 516 bytes
  MD5 checksum 4fc9c376a6282640a3770c8ab0ea8e57
  Compiled from "A.java"
public class moc.A
  minor version: 0
  major version: 52
  flags: ACC_PUBLIC, ACC_SUPER
Constant pool:
   #1 = Methodref          #6.#24         // java/lang/Object."<init>":()V
   #2 = Class              #25            // java/lang/String
   #3 = String             #26            // abc
   #4 = Methodref          #2.#27         // java/lang/String."<init>":(Ljava/lang/String;)V
   #5 = Class              #28            // moc/A
   #6 = Class              #29            // java/lang/Object
   #7 = Utf8               <init>
   #8 = Utf8               ()V
   #9 = Utf8               Code
  #10 = Utf8               LineNumberTable
  #11 = Utf8               LocalVariableTable
  #12 = Utf8               this
  #13 = Utf8               Lmoc/A;
  #14 = Utf8               main
  #15 = Utf8               ([Ljava/lang/String;)V
  #16 = Utf8               args
  #17 = Utf8               [Ljava/lang/String;
  #18 = Utf8               a
  #19 = Utf8               Ljava/lang/String;
  #20 = Utf8               Exceptions
  #21 = Class              #30            // java/lang/Exception
  #22 = Utf8               SourceFile
  #23 = Utf8               A.java
  #24 = NameAndType        #7:#8          // "<init>":()V
  #25 = Utf8               java/lang/String
  #26 = Utf8               abc
  #27 = NameAndType        #7:#31         // "<init>":(Ljava/lang/String;)V
  #28 = Utf8               moc/A
  #29 = Utf8               java/lang/Object
  #30 = Utf8               java/lang/Exception
  #31 = Utf8               (Ljava/lang/String;)V
{
  public moc.A();
    descriptor: ()V
    flags: ACC_PUBLIC
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 6: 0
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0       5     0  this   Lmoc/A;

  public static void main(java.lang.String[]) throws java.lang.Exception;
    descriptor: ([Ljava/lang/String;)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=3, locals=2, args_size=1
         0: new           #2                  // class java/lang/String
         3: dup
         4: ldc           #3                  // String abc
         6: invokespecial #4                  // Method java/lang/String."<init>":(Ljava/lang/String;)V
         9: astore_1
        10: return
      LineNumberTable:
        line 9: 0
        line 13: 10
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0      11     0  args   [Ljava/lang/String;
           10       1     1     a   Ljava/lang/String;
    Exceptions:
      throws java.lang.Exception
}
SourceFile: "A.java"
```
结论： 运行到String a = new String("abc")时，首先在常量池生成一个“abc”对象的引用，这就new出一个String了。然后再new一个String，用常量池的“abc”对象对其初始化，返回该对象引用给a。该语句共有两个String对象生成。

**第三个**
```java
package moc;

/**
 * Created by hero on 6/21/17.
 */
public class A {

    public static void main(String[] args) throws Exception {
        String a = new String("abc");
        String b = "ab" + "c";
        String t = "a";
        String c = t + "bc";
    }
}
```
```java
Classfile /home/hero/workspace/JavaJava/FirstTry/src/main/java/moc/A.class
  Last modified Jun 23, 2017; size 753 bytes
  MD5 checksum 547cc81812cf60311fd061229fe3c23a
  Compiled from "A.java"
public class moc.A
  minor version: 0
  major version: 52
  flags: ACC_PUBLIC, ACC_SUPER
Constant pool:
   #1 = Methodref          #12.#33        // java/lang/Object."<init>":()V
   #2 = Class              #34            // java/lang/String
   #3 = String             #35            // abc
   #4 = Methodref          #2.#36         // java/lang/String."<init>":(Ljava/lang/String;)V
   #5 = String             #24            // a
   #6 = Class              #37            // java/lang/StringBuilder
   #7 = Methodref          #6.#33         // java/lang/StringBuilder."<init>":()V
   #8 = Methodref          #6.#38         // java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
   #9 = String             #39            // bc
  #10 = Methodref          #6.#40         // java/lang/StringBuilder.toString:()Ljava/lang/String;
  #11 = Class              #41            // moc/A
  #12 = Class              #42            // java/lang/Object
  #13 = Utf8               <init>
  #14 = Utf8               ()V
  #15 = Utf8               Code
  #16 = Utf8               LineNumberTable
  #17 = Utf8               LocalVariableTable
  #18 = Utf8               this
  #19 = Utf8               Lmoc/A;
  #20 = Utf8               main
  #21 = Utf8               ([Ljava/lang/String;)V
  #22 = Utf8               args
  #23 = Utf8               [Ljava/lang/String;
  #24 = Utf8               a
  #25 = Utf8               Ljava/lang/String;
  #26 = Utf8               b
  #27 = Utf8               t
  #28 = Utf8               c
  #29 = Utf8               Exceptions
  #30 = Class              #43            // java/lang/Exception
  #31 = Utf8               SourceFile
  #32 = Utf8               A.java
  #33 = NameAndType        #13:#14        // "<init>":()V
  #34 = Utf8               java/lang/String
  #35 = Utf8               abc
  #36 = NameAndType        #13:#44        // "<init>":(Ljava/lang/String;)V
  #37 = Utf8               java/lang/StringBuilder
  #38 = NameAndType        #45:#46        // append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
  #39 = Utf8               bc
  #40 = NameAndType        #47:#48        // toString:()Ljava/lang/String;
  #41 = Utf8               moc/A
  #42 = Utf8               java/lang/Object
  #43 = Utf8               java/lang/Exception
  #44 = Utf8               (Ljava/lang/String;)V
  #45 = Utf8               append
  #46 = Utf8               (Ljava/lang/String;)Ljava/lang/StringBuilder;
  #47 = Utf8               toString
  #48 = Utf8               ()Ljava/lang/String;
{
  public moc.A();
    descriptor: ()V
    flags: ACC_PUBLIC
    Code:
      stack=1, locals=1, args_size=1
         0: aload_0
         1: invokespecial #1                  // Method java/lang/Object."<init>":()V
         4: return
      LineNumberTable:
        line 6: 0
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0       5     0  this   Lmoc/A;

  public static void main(java.lang.String[]) throws java.lang.Exception;
    descriptor: ([Ljava/lang/String;)V
    flags: ACC_PUBLIC, ACC_STATIC
    Code:
      stack=3, locals=5, args_size=1
         0: new           #2                  // class java/lang/String
         3: dup
         4: ldc           #3                  // String abc
         6: invokespecial #4                  // Method java/lang/String."<init>":(Ljava/lang/String;)V
         9: astore_1
        10: ldc           #3                  // String abc
        12: astore_2
        13: ldc           #5                  // String a
        15: astore_3
        16: new           #6                  // class java/lang/StringBuilder
        19: dup
        20: invokespecial #7                  // Method java/lang/StringBuilder."<init>":()V
        23: aload_3
        24: invokevirtual #8                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
        27: ldc           #9                  // String bc
        29: invokevirtual #8                  // Method java/lang/StringBuilder.append:(Ljava/lang/String;)Ljava/lang/StringBuilder;
        32: invokevirtual #10                 // Method java/lang/StringBuilder.toString:()Ljava/lang/String;
        35: astore        4
        37: return
      LineNumberTable:
        line 9: 0
        line 10: 10
        line 11: 13
        line 12: 16
        line 13: 37
      LocalVariableTable:
        Start  Length  Slot  Name   Signature
            0      38     0  args   [Ljava/lang/String;
           10      28     1     a   Ljava/lang/String;
           13      25     2     b   Ljava/lang/String;
           16      22     3     t   Ljava/lang/String;
           37       1     4     c   Ljava/lang/String;
    Exceptions:
      throws java.lang.Exception
}
SourceFile: "A.java"
```
结论：在运行时，
a是new String(), 然后取常量池对象对其初始化。
b是经过编译器优化，直接指向常量池对象。
c是new 一个 StringBuilder，该builder组装好后把一个String对象赋给c，所以c也是new出来的。
StringBuilder的toString方法就是返回一个new String：
```java
public String toString() {
        // Create a copy, don't share the array
        return new String(value, 0, count);
}
```
同时可以看到，String对象"bc"也在常量池中，这是编译器优化的结果。然而"ab"却没有被加入到常量池，大家可以想想为什么。
因为“ab” + “c”这里的“c”也是常量，所以编译期知道这个+表达式永远不会改变，所以直接组成了一个整的。而t + ”bc“就不一样了，t是一个String对象，它在运行时会可能改变的，所以在编译期编译器是不知道这个+表达式最后是什么，为了不用每次执行都要new String("bc")，所以就把”bc“加入到常量池中，这样以后运行到这里就直接去常量池取。

这样结论就出来了，它们三个都不等。

我经验告诉我，不能随便相信别人所说，必须自己亲自验证。
如果你还看不懂字节码，很抱歉我没有讲解如何看，因为我也不太懂zz，况且有太多现成的资料，大家可以都学习学习然后互相交流一下。

大家都知道如果是下面这种情况，优化一下，应该在for外面定义好一个StringBuilder，这个用字节码一看就知道为什么。
```java
package moc;

/**
 * Created by hero on 6/21/17.
 */
public class A {

    public static void main(String[] args) throws Exception {
        String a = "a";
        for (int i = 0; i < 5; i++)
            a += i;
    }
}
```
但是我在项目中经常看到这样的代码，
```java
StringBuilder sb = new StringBuilder();
sb.append("select * from table1, table2 where");
sb.append("....")
sb.append("group by ...")
String sql = sb.toString();
stat.query(sql);
```
这样做其实是多余的，并没有优化任何东西，还不如直接用+连接起来。这样写还把”select * from table1, table2 where“、”group by ...“等放到了常量池中，就等价于把一条完整的sql语句分成多个片段放到了常量池中，下回用还是要拼接。而直接用+连接则是把整个sql语句放到常量池，下回直接用。
可能写代码的人怕sql语句过长，又担心用+连接会产生多个StringBuilder，这其实反映出了编程的基本功底。革命尚未成功，同志仍需努力啊！