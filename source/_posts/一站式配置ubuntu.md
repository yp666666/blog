---
title: 一站式配置ubuntu
date: 2017-08-17 21:45:45
category: 系统配置
tags:
---

>这个是方便我每次重装系统避免再到处翻该下载的东西，所以中间细节不会太多。

在准备重装linux系统之前，先把[VirtualBox](https://www.virtualbox.org/wiki/Downloads)、win7镜像、[迅雷](http://xl9.xunlei.com/)、[chrome](https://www.google.com/chrome/browser/desktop/index.html)、[XX-net](https://github.com/XX-net/XX-Net)、[nodejs](https://nodejs.org/en/download/)、[jdk](http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)、[IntelliJ IDEA](https://www.jetbrains.com/idea/)、[Maven](https://maven.apache.org/)、[mysql](https://dev.mysql.com/downloads/mysql/)、[mysql workbench](https://dev.mysql.com/downloads/workbench/)、[sublime](https://www.sublimetext.com/3)、[]()、[]()、[]()、[]()、[]()准备好。

（安装ubuntu的过程跳过,F7或delete开机引导）
zxfspace|carl-zk|legenduper

##### aliyun更新列表
```sh
cd /etc/apt
sudo cp source.list source.list.bak
替换 http://us.archive.ubuntu.com/ubuntu 为 http://mirrors.aliyun.com/ubuntu
sudo apt-get update
```

##### git、zsh、autojump
`sudo apt-get install git`
`sudo apt-get install zsh`
`sudo apt-get install autojump`
[~/.zshrc](/blog/2017/08/17/%E4%B8%80%E7%AB%99%E5%BC%8F%E9%85%8D%E7%BD%AEubuntu/zshrc.txt)

##### others
播放器`sudo apt-get install vlc browser-plugin-vlc`

[idea.sh](/blog/2017/08/17/%E4%B8%80%E7%AB%99%E5%BC%8F%E9%85%8D%E7%BD%AEubuntu/idea.sh.txt)
[idea.vmoptions](/blog/2017/08/17/%E4%B8%80%E7%AB%99%E5%BC%8F%E9%85%8D%E7%BD%AEubuntu/idea.vmoptions.txt)

[sublime license](http://appnee.com/sublime-text-3-universal-license-keys-collection-for-win-mac-linux/)
```
—– BEGIN LICENSE —–
TwitterInc
200 User License
EA7E-890007
1D77F72E 390CDD93 4DCBA022 FAF60790
61AA12C0 A37081C5 D0316412 4584D136
94D7F7D4 95BC8C1C 527DA828 560BB037
D1EDDD8C AE7B379F 50C9D69D B35179EF
2FE898C4 8E4277A8 555CE714 E1FB0E43
D5D52613 C3D12E98 BC49967F 7652EED2
9D2D2E61 67610860 6D338B72 5CF95C69
E36B85CC 84991F19 7575D828 470A92AB
—— END LICENSE ——
```
[libsublime-imfix.so](/blog/2017/08/17/%E4%B8%80%E7%AB%99%E5%BC%8F%E9%85%8D%E7%BD%AEubuntu/libsublime-imfix.so)
[淘宝npm镜像](https://npm.taobao.org/)
`npm install -g cnpm --registry=https://registry.npm.taobao.org`

`sudo apt-get remove 'libreoffice-*'`
`sudo apt-get autoremove`
[http://wps-community.org/downloads](http://wps-community.org/downloads)

##### 别人整理的
[http://blog.csdn.net/terence1212/article/details/52270210](http://blog.csdn.net/terence1212/article/details/52270210)

![](/blog/2017/08/17/%E4%B8%80%E7%AB%99%E5%BC%8F%E9%85%8D%E7%BD%AEubuntu/Screenshot.png)

# unity 转 gnome
可以看出来，扁平化是好看了点，但是太占内存！而且桌面系统不稳定，叹！

>GNOME Shell，是GNOME桌面环境3.0及其后续版本中的核心用户界面，取代了GNOME 2.0版本中的GNOME Panel与其他相关程序。GNOME shell于2011年4月6日发布。GNOME shell提供窗口切换、载入应用程序等基本功能。GNOME Shell使用mutter作为窗口管理器，Clutter工具箱提供视觉特效与硬件加速。
>gnome强大在插件，配置之后深有体会。
>插件位置*~/.local/share/gnome-shell/extensions*

1. `sudo apt-get install ubuntu-gnome-desktop`
2. reboot 进入 gnome-desktop
3. `gnome-shell --version`
4. 安装google插件**GNOME Shell integration**
5. [https://extensions.gnome.org/](https://extensions.gnome.org/)
6. 下载theme，使用gnome-tweak-tool进行配置
[OSX-Arc-White](https://github.com/LinxGem33/OSX-Arc-White)
[更多主题下载](https://www.gnome-look.org)
7. 一些插件
TopIcons Plus
Dash to Dock
Drop Down Terminal
Coverflow Alt-Tab
Suspend Button

8. 移除 unity桌面
`sudo apt-get remove ubuntu-desktop`
`sudo apt-get remove unity`
`sudo apt-get remove  unity-asset-pool`
`sudo apt-get remove 'unity*'`
`sudo apt-get autoremove`
`sudo apt-get install gdm`
>GNOME是一个DE(desktop environment),GNOME shell 是一个官方的 user interface; unity 是一个 graphical shell。gdm (GNOME Display Manager) 是显示管理器，即你同时装了GNOME shel 和 unity 两个桌面，通过它可以管理用哪个桌面登陆。
>ubuntu默认的桌面是unity，默认的管理器是Unity Greeter([lightdm](https://en.wikipedia.org/wiki/LightDM)的一种)。卸载unity就不能再用unity greeter了，所以换成gdm。

9. 修改锁屏背景
`cd /usr/share/images/desktop-base`
我的屏幕大小是1920*1080，拷一张图片到此目录中，修改lines-lockscreen.xml

```xml
<!--size width="1920" height="1080">/usr/share/images/desktop-base/lines-lockscreen_1920x1080.svg</size-->
<size width="1920" height="1080">/usr/share/images/desktop-base/dragon_girl_forest_art_96504_1920x1080.jpg</size>
```
![](/blog/2017/08/17/%E4%B8%80%E7%AB%99%E5%BC%8F%E9%85%8D%E7%BD%AEubuntu/Screenshot3.jpg)


![](/blog/2017/08/17/%E4%B8%80%E7%AB%99%E5%BC%8F%E9%85%8D%E7%BD%AEubuntu/Screenshot2.png)

折腾这么多，为何不直接下[Ubuntu GNOME](https://ubuntugnome.org/download/)?

总结：
个人感觉ubunut源比debian源更多，资源列表同步于阿里云ubuntu，折腾的就少了些。不过gnome没有想象的那么稳定，gnome-shell也会报内部错误但是卡一会儿还能恢复过来，听说arch linux不错。。。



