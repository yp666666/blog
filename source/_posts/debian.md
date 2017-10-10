---
title: debian
date: 2017-05-06 18:16:09
category: 系统配置
tags:
---
最近看了篇关于吐槽ubuntu放弃unity转用gnome的文章，作者是deepin桌面系统的开发者。忍不住就去deepin的官网下了下装在虚机里试了试，结果样式全都是模仿的mac的。
作为一个linux桌面开发者，他的情怀我可以理解，不过我没打算用deepin系统，虽然样子很酷，毕竟太像mac的linux让我感觉不舒服。另外还有个顾虑，不方便说。
我想，既然mac的小托盘这么好，不如也在我debian8里面装一个。果然评论里有人说装个dash-to-doc和topicons就跟mac差不多了。还等啥，google一下装起来。

**1.检查gnome-shell版本**
```
$ gnome-shell --version
```
GNOME Shell 3.14.4

**2.安装chrome浏览器插件**
GNOME Shell integration

**3.点击插件进入网页**
[https://extensions.gnome.org/](https://extensions.gnome.org/)

**4.搜索dash-to-dock，topicons**
根据shell版本选择对应的下载安装即可。

我找到的是这俩
[dash-to-dock](https://github.com/micheleg/dash-to-dock/tree/gnome-3.14)
[topicons](https://github.com/wincinderith/topicons)

安装过程很简单，都是
下载xxx.zip
$ unzip xxx.zip
$ cd xxx/
$ make
$ make install

目录 `~/.local/share/gnome-shell/extensions` 看看有没有你安装的插件

Alt+F2 r 回车

$ gnome-shell-extension-prefs

找到对应的插件把开关置成on

体验：
Dash To Dock 这个插件还是挺好的，TopIcons插件好多应用就没有icon，唉。


