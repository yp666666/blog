---
title: 好玩的@annotation标签
date: 2017-03-27 00:33:39
category: java
tags: reflect
---
**参考**
[Java Custom Annotations Example](http://www.mkyong.com/java/java-custom-annotations-example/)

### 一个Annotation小例子
```java
package custom.annotation;

import custom.annotation.NightFire.Light;

/**
 * Created by hero on 17-3-27.
 * 被标签修饰的类和方法
 */
@NightFire(light = Light.HIGH, stars = {"stara", "starb"}, moon = "round")
public class Decorator {

    @Night(enabled = true)
    void testA() {
        throw new RuntimeException("testA");
    }

    @Night(enabled = false)
    void testB() {
    }

    @Night(enabled = true)
    void testC() {
    }
}
```
```java
package custom.annotation;

import java.lang.annotation.Annotation;
import java.lang.reflect.Method;

/**
 * Created by hero on 17-3-27.
 * 处理带标签的类和方法
 */
public class Processor {

    public static void main(String[] args) {
        Class<Decorator> clazz = Decorator.class;
        if (clazz.isAnnotationPresent(NightFire.class)) {
            Annotation annotation = clazz.getAnnotation(NightFire.class);
            NightFire nightFire = (NightFire) annotation;

            System.out.println(nightFire.light());
            for (String star : nightFire.stars()) {
                System.out.printf("%-10s", star);
            }
            System.out.println();
            System.out.println(nightFire.moon());
        }

        for (Method method : clazz.getDeclaredMethods()) {
            if (method.isAnnotationPresent(Night.class)) {
                Annotation annotation = method.getAnnotation(Night.class);
                Night night = (Night) annotation;
                if (night.enabled()) {
                    try {
                        method.invoke(clazz.newInstance());
                        System.out.println("successed: " + method.getName());
                    } catch (Exception e) {
                        System.out.println("failed: " + method.getName());
                    }
                } else {
                    System.out.println("not process: " + method.getName());
                }
            }
        }
    }
}
```
```java
package custom.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by hero on 17-3-26.
 * 参考http://www.mkyong.com/java/java-custom-annotations-example/
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Night {

    //you can or not
    boolean enabled() default false;
}
```
```java
package custom.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * Created by hero on 17-3-26.
 */
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)  // class level
public @interface NightFire {
    public enum Light {
        LOW, MEDIUM, HIGH
    }

    Light light() default Light.LOW;

    String[] stars() default "";

    String moon() default "big";
}
```

### 相关说明

```java
package java.lang.annotation;

public enum ElementType {
    /** Class, interface (including annotation type), or enum declaration */
    TYPE,

    /** Field declaration (includes enum constants) */
    FIELD,

    /** Method declaration */
    METHOD,

    /** Formal parameter declaration */
    PARAMETER,

    /** Constructor declaration */
    CONSTRUCTOR,

    /** Local variable declaration */
    LOCAL_VARIABLE,

    /** Annotation type declaration */
    ANNOTATION_TYPE,

    /** Package declaration */
    PACKAGE,

    /**
     * Type parameter declaration
     *
     * @since 1.8
     */
    TYPE_PARAMETER,

    /**
     * Use of a type
     *
     * @since 1.8
     */
    TYPE_USE
}
```

```java
package java.lang.annotation;

public enum RetentionPolicy {
    /**
     * Annotations are to be discarded by the compiler.
     */
    SOURCE,

    /**
     * Annotations are to be recorded in the class file by the compiler
     * but need not be retained by the VM at run time.  This is the default
     * behavior.
     */
    CLASS,

    /**
     * Annotations are to be recorded in the class file by the compiler and
     * retained by the VM at run time, so they may be read reflectively.
     *
     * @see java.lang.reflect.AnnotatedElement
     */
    RUNTIME
}
```
### 其它元注解
```java
@Documented
@Inherited
@Native
@Repeatable
@Deprecated
@FunctionalInterface
@Override
@SafeVarargs
@SuppressWarnings
```