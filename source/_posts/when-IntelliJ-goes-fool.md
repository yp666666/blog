---
title: when IntelliJ goes fool
date: 2018-04-18 00:20:47
category:
tags:
---
> hehe
>

当已经被公认是最好用的工具后，并且你已经使用了很久，而且它也从未让你感到失望。
直到出现某一时刻，它卡顿了，它莫名其妙的提示一些你关也关不掉的信息，
你终于被弄疯掉了！！！

这就是我这次使用IDEA的感受。

建的包‘moc.oreh’在没有mark源文件root时只是作为了一个文件夹的名字！这样idea就死活找不到某个类，提示信息只是‘can not resolve symbol 'moc' ’，懵懂的我可能太较真，关不掉这个提示信息让我无法忍受，所以我尝试了漫长的求知之旅。
我去`/Applications/IntelliJ IDEA.app/Contents`，
`/Users/hero/Library/Preferences/IntelliJIdea2018.1`,
`/Users/hero/Library/Caches/IntelliJIdea2018.1/caches` 
各个目录下备份、删除，才终于发现问题完美的重现，看来并不是配置搞错了，但是idea15的提示信息是如此的简洁，让我摸不到头脑，直到我安装了最新版本的idea，这个提示信息一下子让我明白了原来是两个包名成了一个文件名。

从这件事上可以学到：
1. 工具是如此的便利，但同时它也让你丢失了很多能力。
2. 习惯一旦养成，就会按着期望去做事，不愿改变也不愿思考。
3. 工具可能会由好变得更好，但人的演化是相反的。
4. 第4点还没想好，不过我得先睡觉了。

最好的编译器：idea；
最好的笔记本：Mac；
这些拿到了“最好的”头衔的东西，用起来还是会让人失望。
