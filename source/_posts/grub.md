---
title: grub
date: 2017-10-14 11:31:10
category:
tags:
---
>目的：制作一个Linux和windows启动盘。

[grub官网](https://www.gnu.org/software/grub/)
[grub命令修复系统](https://www.linux.com/learn/how-rescue-non-booting-grub-2-Linux)
[多合一启动盘制作工具 WinSetupFromUSB](http://www.winsetupfromusb.com/downloads/)[【WinSetupFromUSB教程】](http://www.iplaysoft.com/winsetupfromusb.html)
[MultiSystem – Create a MultiBoot USB from Linux](https://www.pendrivelinux.com/multiboot-create-a-multiboot-usb-from-linux/)[【MultiSystem教程】](http://www.mintos.org/skill/multisystem.html)
**GNU GRUB**是一个系统开机引导应用。

### 命名规则
(fd0) :  fd 表示floppy disk，0 表示drive number，driver号从0开始。
(hd0,msdos2) :  hd 表示hard disk drive，msdos 表示partition scheme，2表示partition number， partition number从1开始。
(hd0,msdos5) :  5表示hd0的第一个逻辑分区。(一个系统只能有4个主分区)
(hd1,msdos1,bsd1) :  BSD系统中，第二个硬盘第一个slice的'a'分区。
如何指定一个文件？
(hd0,msdos1)/vmlinuz :  第一个硬盘的第一个主分区的vmlinuz文件。
### 如何用GRUB引导OS
**GRUB有两种不同的引导方式：直接引导和chain-load（引导另一种boot loader，让它去load OS）。**
Multiboot是GRUB原生支持的，它可以直接引导Linux, FreeBSD, NetBSD and OpenBSD等系统。
不支持Multiboot及GRUB没有明确表示支持的系统只能通过chain-load引导。

Chain-loading is only supported on PC BIOS and EFI platforms.


### GRUB SHELL
#### 如何用grub命令手动引导？
1.进入`grub>`;
ubuntu/debian系统开机出现画面时按一下shift键。
如果开机时没有选择界面，直接到输入密码界面，则需要修改/etc/default/grub文件
`GRUB_HIDDEN_TIMEOUT=10`取消注释并设置成10
`GRUB_GFXMODE=640x480`取消注释
修改完执行`update-grub`
2.在shell中
```sh
grub>ls
列出当前系统中的磁盘分区代号
(hd0) (hd0,msdos6) (hd0,msdos5) (hd0,msdos1)
grub>ls (hd0,msdos6)/
列出分区中的文件，可看出此分区为 /
bin    dev   initrd.img      lib32       media  proc  sbin  sys  var
boot   etc   initrd.img.old  lib64       mnt    root  snap  tmp  vmlinuz
cdrom  home  lib             lost+found  opt    run   srv   usr  vmlinuz.old
grub> ls (hd0,msdos1)
会列出分区信息：文件系统类型、UUID、分区大小等。
grub>ls (hd0,msdos1)/
可看出此分区为 /boot
abi-4.10.0-19-generic         memtest86+.bin
abi-4.10.0-35-generic         memtest86+.elf
abi-4.10.0-37-generic         memtest86+_multiboot.bin
config-4.10.0-19-generic      System.map-4.10.0-19-generic
config-4.10.0-35-generic      System.map-4.10.0-35-generic
config-4.10.0-37-generic      System.map-4.10.0-37-generic
efi                           vmlinuz-4.10.0-19-generic
grub                          vmlinuz-4.10.0-35-generic
initrd.img-4.10.0-19-generic  vmlinuz-4.10.0-35-generic.efi.signed
initrd.img-4.10.0-35-generic  vmlinuz-4.10.0-37-generic
initrd.img-4.10.0-37-generic  vmlinuz-4.10.0-37-generic.efi.signed
grub>set root=(hd0,msdos6)
grub>linux (hd0,msdos1)/vmlinuz-4.10.0-35-generic root=/dev/sda6
grub>initrd (hd0,msdos1)/initrd.img-4.10.0-35-generic
grub>boot
```
通过ls可以查到哪个分区是/boot，哪个分区是/。然后set root=(hd0,msdos6)，指定根目录。然后linux (hd0,msdos1)/vmlinuz-4.10.0-35-generic告诉GRUB加载哪个kernel，root=/dev/sda6指定根目录。然后initrd (hd0,msdos1)/initrd.img-4.10.0-35-generic指定initrd file。最后boot。
如果是x86系统，对应的linux16、initrd16。initrd file是加载kernel后的启动参数。
在*grub rescue>*模式下可参考：
```sh
grub rescue> set prefix=(hd0,1)/boot/grub
grub rescue> set root=(hd0,1)
grub rescue> insmod normal
grub rescue> normal
grub rescue> insmod linux
grub rescue> linux /boot/vmlinuz-3.13.0-29-generic root=/dev/sda1
grub rescue> initrd /boot/initrd.img-3.13.0-29-generic
grub rescue> boot
```
等成功进入系统后，执行
```sh
#update-grub
#grub-install /dev/sda
```
grub-install /dev/sda只需指定boot的所在driver，不要partition number，所以do not use a partition number like /dev/sda1.
如果还不行，就用其它工具[Super Grub2 Disk](http://www.supergrubdisk.org/).

以上是引导/修复GNU/Linux，如果是DOS/Windows,请参考[5.3.4 DOS/Windows](https://www.gnu.org/software/grub/manual/grub/grub.html#Configuration)

### 写一个configuration file
#### Simple configuration
最推荐的一种方式，可以应对绝大多数情况。
使用grub-mkconfig命令生成grub.cfg文件，/etc/default/grub文件控制grub-mkconfig。生成grub.cfg后，如果修改了/etc/default/grub文件，需要`update-grub`来更新一下/boot/grub/grub.cfg文件。grub-mkconfig使用的模板在/usr/local/etc/grub.d中。
/etc/default/grub中是标准的键-值对，值中如果有空格则需双引号括起来。
#### Shell-like scripting
#### Multi-boot manual config
#### Embedded configuration
