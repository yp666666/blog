---
title: javascript权威指南
date: 2017-12-30 11:05:29
category:
tags: javascript
---
## 一、概述
### 变量
```js
javascript 是弱类型语言，即不需要声明变量的类型。如：
var x = 2;
var y = "hello world"
javascript最重要的两类数据类型是对象和数组：
var book = {
	topic: "JavaScript",
	fat: true
}
通过"."或"[]"来访问对象属性：
book.topic
book["fat"]
book.author = "jack";    // 通过赋值创建一个新属性

var primes = [2, 3, 5, 7];
primes[2]
primes.length
primes.push(1, 2, 3)	// 向数组中添加元素，尾插法
primes.reverse()	// 将数组元素次序反转
```
### 运算
```js
算数运算
var count = 0;
count++;
count--;
count += 2;
count /= 4;

"3" + "2" // "32"，字符串连接

关系运算
var x = 2, y = 3;
x == y // false
x <= y // true
x != y
x < y

"two" > "three" // true，"tw"在字母表中的索引大于"th"

逻辑运算
&&      // 与
||		// 或
！		// 反
```
### 函数
```js
function plus1(x) {
	return x+1;
} 
plus1(3)

var square = function(x) {
	return x*x;
}

对象中定义函数就成了对象的方法：
var points = {
	x: 3,
	y: 2;
}
points.dist = function(p){
	var a = this.x - p.x,
		b = this.y - p.y;
	return Math.sqrt(a*a + b*b);
}
```
### 控制语句
```js
if(true) {
}else {
}
while(true) {
}
for(var i = 0; i < 5; i++) {
}
```
### 面向对象编程
```js
function Point(x, y) {
	this.x = x;
	this.y = y;
}
var p = new Point(2, 3);	// 使用new来创建对象
Point.prototype.r = function() {
	return Math.sqrt(
		this.x*this.x +
		this.y*this.y;
	);
};
p.r()
```
























