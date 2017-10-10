---
title: Hello Python
date: 2016-06-06 23:18:31
category:
tags: python
---
### **《Python 核心编程》**
***基于python2.7版本***
#### 第一章 欢迎来到python世界
```python
#！/usr/bin/env python
# -*- coding: utf-8 -*-
 print 'hello world'
```
#### 第二章 快速入门
##### 2.1 程序输出
```python
print "%s is number %d!" % ("Python", 1), 'what do you think? %.2f' % (2.50)
```
```python
import sys
print >> sys.stderr, 'Fatal error: invalid input'
```
```python
# -*- coding: utf-8 -*-
logfile = open('/home/hero/workspace/PythonTest/log', 'a') #a添加、r读、w写
print >> logfile, '可以重定向输出到文件log'
logfile.close()
```
##### 2.2 程序输入和raw_input()内建函数
```python
user = raw_input('Enter login name: ')
print 'Your login name is', user
```
##### 2.4 操作符
|**算数操作符**  |**方式**  | **示例**|
|:--------------|:-------:|--------:|
|+、-、*、/、%|标准操作符|
|//|浮点除法(四舍五入)|7//2=3
|**|乘方操作符|3**2=9


##### 2.18 类
```python
#!/usr/bin/env python
# -*- coding: utf-8 -*-
class Foo(object):
    """docstring for Foo"""
    version = 1.0
    """constructor"""
    def __init__(self, nm='John Doe'):
        self.name = nm
        print 'create Foo '+ nm
    def showname(self): #self（java中的this）
        print self.name
    def showver(self):
        print self.version

foo = Foo()
foo.showname()
foo.showver()

foo = Foo('Jimy')
foo.showname()
foo.showver()
```
##### 2.19 模块
module_cap.py
```python
# -*- coding:utf-8 -*-
#将每个单词首字母改为大写
def my_cap(s):  # my capitalize fun
    if not isinstance(s, str):
        return
    l = s.split(' ')
    res = ''
    for i in l:
        res += i.capitalize() + ' '
    return res
value=999
```
test_main.py
```python
# -*- coding: utf-8 -*-
from module_cap import *
print my_cap('hello world')
print value
```
#### 第三章 语句和语法
##### 3.6 文件读写
```python
#!/usr/bin/env python
# --*-- coding: utf-8 --*--

"""makeTextFile.py -- create text file"""

import os


def touch_file():
    ls = os.linesep

    # get file name
    while True:
        fname = raw_input('Please enter the file name:("q" to quit) ')
        if fname == 'q':
            return
        elif os.path.exists(fname):
            print "Error: '%s' already exists" % fname
        else:
            break

    # get file content lines
    all = []
    print 'Enter lines ("#" by itself to quit).'

    # loop
    while True:
        entry = raw_input('> ')
        if entry == '#':
            break
        else:
            all.append(entry)

    # write to file
    fobj = open(fname, 'w')
    fobj.writelines(['%s%s' % (x, ls) for x in all])
    fobj.close()
    print 'Done!'

if __name__ == '__main__':
    touch_file()
```
```python
#!/usr/bin/env python
# --*-- coding: utf-8 --*--

"""readTextFile.py -- read text file"""


def read_text_file():
    fname = raw_input('Enter file name: ')
    try:
        fobj = open(fname, 'r')
    except IOError, e:
        print 'file open error:', e
    else:
        for eachLine in fobj:
            print eachLine,
        fobj.close()


if __name__ == '__main__':
    read_text_file()
```
