---
title: Fibonacci
date: 2016-06-23 00:32:40
category: hdu
tags: 
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=2&sectionid=2&problemid=1)
Problem Description
2007年到来了。经过2006年一年的修炼，数学神童zouyu终于把0到100000000的Fibonacci数列
(f[0]=0,f[1]=1;f[i] = f[i-1]+f[i-2](i>=2))的值全部给背了下来。
接下来，CodeStar决定要考考他，于是每问他一个数字，他就要把答案说出来，不过有的数字太长了。所以规定超过4位的只要说出前4位就可以了，可是CodeStar自己又记不住。于是他决定编写一个程序来测验zouyu说的是否正确。
 

Input
输入若干数字n(0 <= n <= 100000000)，每个数字一行。读到文件尾。
 

Output
输出f[n]的前4个数字（若不足4个数字，就全部输出）。
 

Sample Input
0
1
2
3
4
5
35
36
37
38
39
40
 

Sample Output
0
1
1
2
3
5
9227
1493
2415
3908
6324
1023
<hr />

[参考链接](http://blog.csdn.net/xh_reventon/article/details/8747670)
> Fibonacci的通项公式：
**F(n)=(1/√5)*[((1+√5)/2)^n-((1-√5)/2)^n]**  ------------------    (1)
(1-√5)/2很小，所以当n大的时候，((1-√5)/2)^n为0，可以忽律不计
可以通过打表得出前20项都是小于等于4位，直接输出。
后面通过取10的对数，然后去掉整数部分，然后取10的指数，取前四位即可

> F(n)可以写成 a*10^b, 对公式(1)取对数可得:
> **lga+b=-lg√5-n*lg2(1+√5)=t**
> b是t的整数部分,即[t]
> 所以a = 10^(t-[t]);


```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<cmath>
#include<cstdlib>
#define MAX 21

using namespace std;

/**
* Fibonacci通项公式:
* F(n) = (1/√5)*[((1+√5)/2)^n-((1-√5)/2)^n]
*/

int a[MAX];

const double sqrt5 = sqrt(5);

void init()
{
    a[0] = 0;
    a[1] = 1;
    for(int i=2; i<MAX; i++)
    {
        a[i] = a[i-1]+a[i-2];
    }
}

void fibonac(int x)
{
    double t,y;
    t = -log10(sqrt5) + log10(0.5+0.5*sqrt5) * x;
    y = pow(10, t - (long long)t);
    printf("%d\n", (int)(y*1000));
}

int main()
{
    init();
    int x;
    while(scanf("%d", &x)!=EOF)
    {
        if(x<21)
        {
            printf("%d\n",a[x]);
        }
        else
        {
            fibonac(x);
        }
    }
    return 0;
}


```