---
title: JavaScript对象、继承和原型链
date: 2016-07-04 16:04:07
category:
tags: javascript
---
JavaScript 与 Java 在面向对象编程方面类似，都是引用传递。如
name = '小明'
字符串是一个对象，属性字段是指向这个字符串对象的引用。
Java 中的继承，在 JavaScript 中成了原型链，原型链上的每个节点都是一个对象实例，这是与 Java 不同的地方。

## 对象
```js
var person = {
    name: '', // 共有变量
    $age: 0, // 私有变量
    get getAge() {
        return this.$age;
    },
    set setAge(age) {
        if (age < 0) {
            throw new Error('age can\'t be smaller than 0 : ' + age);
        }
        this.$age = age * 10;
    },
    sing: function() {
        alert(this.name + " is singing");
    }
}
try {
    person.name = '小明';
    person.setAge = 2;
    alert(person.getAge);
    person.sing();
} catch (e) {
    alert(e.message);
}
```
在属性前加**$**，则此属性为私有属性，并不会被子类继承。get、set 方法与 function 不同，set 会按照指定逻辑赋值。

## 继承
```js
function Student(id) {
    this.id = id;
}
Student.prototype = person;
var stu = new Student(1);
alert(stu.name);	// 小明
alert(stu.age);		// undefined，说明私有属性不能被继承
stu.name = '小红';
alert(stu.sing()).  // 小红 is singing
alert(person.name);	//小明，说明修改子类中继承的属性，原型并不会被修改
alert(JSON.stringify(stu)); // {"id":1} 对象的序列化，即对象->字符串,它会调用对象自身的 toJSON() 方法；反序列化为JSON.parse()
```
将 person 设为 Student 的原型，则 Student 继承了 person 的公有方法和公有属性。
修改子类中继承的属性并不会影响到原型的属性，但是如果修改原型的属性，则所有子类的属性都会改变。（跟 Java 内存模型一模一样）

将方法设为prototype可以让浏览器只加载一次方法（为什么？）
```js
function User(first, last){
    this.first = first;
    this.last = last;
}
User.prototype.getFullName = function(){
        return this.first + " " + this.last;
};
User.prototype.getLastName = function(){
        return this.last;
};
var him = new User("wang", "yang");
console.log(him.getFullName())
```
可能就是因为所有 new User 的对象的原型都指向同一个对象，所以这些 new 出来的对象就不必每个都单独加载 getFullName、getLastName 方法了吧。
这里有更专业的解释[Class-based vs. prototype-based languages](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Details_of_the_Object_Model)

## 原型链
从上面的链接中可以看出 prototype-base 的 JavaScript 一些独特的性质，
1. 单继承；一个对象的原型只有一个。
2. 运行时对象的属性可以动态增减。

## 闭包
闭包更像是一个拥有字段和方法的对象实例。
[阮一峰](http://www.ruanyifeng.com/blog/2009/08/learning_javascript_closures.html)
[MDN Closure](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Closures)
```js
v = 'global';
var t = {
    v: 'local',
    f: function(){
        return function(){
            return this.v;
        }
    }
};
console.log(t.f()())
```
f 是 t 的方法，它返回的是一个方法。由于这个返回的方法是在外部被调用，并且 this 关键字会随调用上下文发生变化，所以才会打印 global （this在严格模式下为 undefined,非严格模式下为全局对象）
```js
v = 'global';
var t = {
    v: 'local',
    f: function(){
        var that = this;
        return function(){
            return that.v;
        }
    }
};
console.log(t.f()())
```
虽然这里也是在外部调用，但是返回值的函数定义上下文的 that 没有被垃圾回收，它指向 t，所以打印的是 local