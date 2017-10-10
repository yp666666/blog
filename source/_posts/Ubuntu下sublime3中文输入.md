---
title: Ubuntu下sublime3中文输入
date: 2017-02-28 21:41:53
category: 系统配置
tags:
---

[参考](http://www.jianshu.com/p/9f2a11851b4e)

最近我折腾了个新linux系统debian，安装包才二百多MB。又把sublime3中文输入的问题搞了一遍。
首先，安装fcitx，fcitx-sunpinyin，然后卸载ibus-pinyin。
在～/.zshrc中添加export GTK_IM_MODULE=fcitx
运行: fcitx-autostart , fcitx-configtool.
到这，你可以安装sogou。不过我喜欢sun拼音，因为它现在不比sogou差了。

#### 1.保存下述代码为 sublime-imfix.c 文件
[sublime-imfix.c](/blog/2017/02/28/Ubuntu%E4%B8%8Bsublime3%E4%B8%AD%E6%96%87%E8%BE%93%E5%85%A5/sublime-imfix.c)

#### 2.安装 C/C++ 的编译环境 gtk libgtk2.0-dev

```
sudo apt-get install build-essential
sudo apt-get install libgtk2.0-dev
```

#### 3.进入sublime-imfix.c的目录,编译共享内库

```
gcc -shared -o libsublime-imfix.so sublime-imfix.c `pkg-config --libs --cflags gtk+-2.0` -fPIC
```
此句的执行结果是生成libsublime-imfix.so文件,其位置是执行此句命令所在的目录。
将此文件移动到/opt/sublime_text/下。（我sublime3在/opt/下）

#### 4.在/usr/bin/目录下建立新文件subl
```
#!/bin/sh
export LD_PRELOAD=/opt/sublime_text/libsublime-imfix.so
exec /opt/sublime_text/sublime_text "$@"
```
ps: 可能需要chmod，chown命令。

#### 5. 完成
 可新打开一个终端输入subl来敲一敲中文。

