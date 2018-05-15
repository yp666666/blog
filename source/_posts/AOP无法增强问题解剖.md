---
title: AOP无法增强问题解剖
date: 2018-05-15 09:36:44
category:
tags: spring
---
>摘录自：《精通Spring 4.x 企业应用开发实战》

由于Spring使用CGLib增强，所以无法对private、static、final的方法进行增强，此外还有一种特别容易忽视的情况，即funA，funB都被增强，但在funA中调用funB时funB其实并未被增强。

```java
public static void main(String[] args) {
    @Component
    class Waiter {
        public void funA() {
            funB();
        }

        public void funB() {
            System.out.println("What do you want to eat?");
        }
    }

    @Aspect
    class P {
        @Pointcut("execution(* *.fun*(..))")
        public void pointcut() {
        }

        @Before("pointcut()")
        public void advice() {
            System.out.println("good morning sir");
        }
    }

    @Configuration
    @Import({P.class, Waiter.class})
    @EnableAspectJAutoProxy(proxyTargetClass = true)
    class Config {
    }

    ApplicationContext context = new AnnotationConfigApplicationContext(Config.class);
    Waiter w = context.getBean(Waiter.class);
    w.funA();
}
```

遇到这种情况，需要特别注意，解决方法很简单，就是在funA中使用代理对象调用funB。



