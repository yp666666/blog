---
title: Java动态代理
date: 2018-05-12 08:46:13
category: java
tags: spring
---
## JDK原生动态代理
http://www.cnblogs.com/xiaoluo501395377/p/3383130.html
面向接口编程就一定要先定义接口再定义实现类吗？一个项目中有大量的 dao/imp、service/imp 包，看上去很‘规范’（理由是大家都这么写）。其实这样写是有历史包袱的，AOP特性的实现依赖于动态代理机制，而最早的框架中只能对接口进行动态代理，这样就导致每次都是先写接口，然后让框架去代理这个接口的实现类，返回对象是接口。而现在框架有能力直接代理对象无须接口，那我们的dao、service接口还有保留的意义吗？
```java
import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;

public class DynamicProxyTest {
    interface Animal {
        void say();

        void say(String words);
    }

    static class Duck implements Animal {

        @Override
        public void say() {
            System.out.println("呱呱");
        }

        @Override
        public void say(String words) {
            System.out.println("卧槽：" + words);
        }
    }

    static class ProxyOfAnimal implements InvocationHandler {

        Animal animal;

        public ProxyOfAnimal(Animal animal) {
            this.animal = animal;
        }

        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            System.out.println("Proxy invoke");
            System.out.println(method);
            return method.invoke(this.animal, args);
        }
    }

    public static void main(String[] args) {
        Duck duck = new Duck();
        ProxyOfAnimal proxyOfAnimal = new ProxyOfAnimal(duck);
        Animal got = (Animal) Proxy.newProxyInstance(duck.getClass().getClassLoader(), duck.getClass().getInterfaces(), proxyOfAnimal);
        System.out.println(got.getClass().getName());
        got.say();
        got.say("wawa");
    }
}

```
控制台
```
$Proxy0
Proxy invoke
public abstract void DynamicProxyTest$Animal.say()
呱呱
Proxy invoke
public abstract void DynamicProxyTest$Animal.say(java.lang.String)
卧槽：wawa

Process finished with exit code 0
```

InvocationHandler.invoke(Object proxy, Method method, Object[] args) 第一个参数是 Proxy.newProxyInstance 的返回对象，即 $Proxy0。可能是老接口没设计好，这个proxy在这里就是 this。

局限性：Proxy.newProxyInstance 只能返回接口Animal，不能返回对象Duck；不支持对static方法的代理。
优点：所谓的‘动态’只不过是调用某方法时去执行我事先定义好的handler方法，虽然我不必像静态代理那样写一个代理类，但是我需要写一个handler。但是我现在只需要写一个handler，就能产生Duck、Dog、Cat的代理类。


## CGLIB动态代理
http://www.importnew.com/27772.html
>[CGLIB(Code Generation Library)](https://github.com/cglib/cglib)是一个基于ASM的字节码生成库，它允许我们在运行时对字节码进行修改和动态生成。CGLIB通过继承方式实现代理。

spring的@Transactional注解不能用在static方法上就很好理解了。spring使用cglib代理，而cglib通过继承方式实现代理，那么static方法不能继承（它不属于任何对象），就不能被代理了。同样，final修饰的方法（不能被override）、final 修饰的类（不能被继承）也不能被代理。

cglib给的一个演示示例，理解其如何实现动态代理
```java
package net.sf.cglib.samples;

import java.beans.*;
/**
 *
 * @author  baliuka
 */
public abstract class Bean implements java.io.Serializable{
   
    String sampleProperty;
    
  abstract public void addPropertyChangeListener(PropertyChangeListener listener); 
   
  abstract public void removePropertyChangeListener(PropertyChangeListener listener);
   
   public String getSampleProperty(){
      return sampleProperty;
   }
   
   public void setSampleProperty(String value){
       System.out.println("base bean");
      this.sampleProperty = value;
   }
   
   public String toString(){
     return "sampleProperty is " + sampleProperty;
   }
    
}



package net.sf.cglib.samples;

import java.beans.*;
import java.lang.reflect.*;
import net.sf.cglib.proxy.*;

/**
 *
 * @author  baliuka
 */
public class Beans implements MethodInterceptor {
    
    private PropertyChangeSupport propertySupport;
   
    public void addPropertyChangeListener(PropertyChangeListener listener) {
        
        propertySupport.addPropertyChangeListener(listener);
        
    }
    
    public void removePropertyChangeListener(PropertyChangeListener listener) {
        propertySupport.removePropertyChangeListener(listener);
    }
    
    /**
    * 返回一个代理对象 C
    * C绑定了一个MethodInterceptor mi，mi 为C 绑定了一个PropertyChangeSupport pcs，
    * 每次调用C的方法，都等于调用mi的intercept
    */
    public static  Object newInstance( Class clazz ){
        try{
            Beans interceptor = new Beans();
            Enhancer e = new Enhancer();
            e.setSuperclass(clazz);
            e.setCallback(interceptor);
            Object bean = e.create();
            interceptor.propertySupport = new PropertyChangeSupport( bean );
            return bean;
        }catch( Throwable e ){
            e.printStackTrace();
            throw new Error(e.getMessage());
        }
        
    }
    
    static final Class C[] = new Class[0];
    static final Object emptyArgs [] = new Object[0];

    public Object intercept(Object obj, Method method, Object[] args, MethodProxy proxy) throws Throwable {
        Object retValFromSuper = null;
        try {
            // 非abstract方法，直接调
            if (!Modifier.isAbstract(method.getModifiers())) {
                retValFromSuper = proxy.invokeSuper(obj, args);
            }
        } finally {
            String name = method.getName();
            // Bean中的两个abstract方法，在这里被'重载'了
            if( name.equals("addPropertyChangeListener")) {
                addPropertyChangeListener((PropertyChangeListener)args[0]);
            }else if ( name.equals( "removePropertyChangeListener" ) ){
                removePropertyChangeListener((PropertyChangeListener)args[0]);
            }
            // 根据setXXX截取字段
            if( name.startsWith("set") &&
                args.length == 1 &&
                method.getReturnType() == Void.TYPE ){
            
                char propName[] = name.substring("set".length()).toCharArray();
            
                propName[0] = Character.toLowerCase( propName[0] );
                // 如果调用setSampleProperty方法，则触发一个事件PropertyChangeEvent
                propertySupport.firePropertyChange( new String( propName ) , null , args[0]);
            
            }
        }
        return retValFromSuper;
    }
    
    public static void main( String args[] ){
        
        Bean  bean =  (Bean)newInstance( Bean.class );
        
        //为代理对象绑定一个PropertyChangeEvent监听器
        bean.addPropertyChangeListener(
        new PropertyChangeListener(){
            public void propertyChange(PropertyChangeEvent evt){
                System.out.println(evt);
            }
        }
        );
        
        bean.setSampleProperty("TEST");
        
        
    }
}
```
控制台
```
base bean
java.beans.PropertyChangeEvent[propertyName=sampleProperty; oldValue=null; newValue=TEST; propagationId=null; source=sampleProperty is TEST]

Process finished with exit code 0
```

Spring 是如何添加事务的呢？大概是这个样子：
```java
import net.sf.cglib.proxy.Enhancer;
import net.sf.cglib.proxy.MethodInterceptor;
import net.sf.cglib.proxy.MethodProxy;

import java.lang.reflect.Method;

public class TxDemo {
    static class Dao {
        public void save(String obj) {
            System.out.println("save entity: " + obj);
        }
    }

    static class Proxy implements MethodInterceptor {

        public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
            Object retObj = null;
            System.out.println("tx begin");
            try {
                retObj = methodProxy.invokeSuper(o, objects);
                System.out.println("tx commit");
            } catch (Exception e) {
                e.printStackTrace();
                System.out.println("tx rollback");
            }
            return retObj;
        }
    }

    public static void main(String[] args) {
        Enhancer enhancer = new Enhancer();
        enhancer.setSuperclass(Dao.class);
        enhancer.setCallback(new Proxy());
        Dao got = (Dao) enhancer.create();
        got.save("user");
    }
}
```
控制台
```
tx begin
save entity: user
tx commit

Process finished with exit code 0
```

