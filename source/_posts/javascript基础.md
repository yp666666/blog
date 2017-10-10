---
title: javascript基础
date: 2016-07-04 16:04:07
category:
tags: javascript
---

#### javascript 创建对象.
将方法设为prototype可以让浏览器只加载一次方法.
```js
function User(first, last){
	this.first = first;
    this.last = last;
}
User.prototype = function() {
	getFullName: function(){
		return this.first + " " + this.last;
	}
	getLastName: function(){
		return this.last;
	}
};
var him = new User("wang", "yang");
```
