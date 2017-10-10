---
title: FatMouse' Trade
date: 2016-06-21 09:52:52
category: hdu
tags:
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=1&sectionid=3&problemid=1)
Problem Description
FatMouse prepared M pounds of cat food, ready to trade with the cats guarding the warehouse containing his favorite food, JavaBean.
The warehouse has N rooms. The i-th room contains J[i] pounds of JavaBeans and requires F[i] pounds of cat food. FatMouse does not have to trade for all the JavaBeans in the room, instead, he may get J[i]* a% pounds of JavaBeans if he pays F[i]* a% pounds of cat food. Here a is a real number. Now he is assigning this homework to you: tell him the maximum amount of JavaBeans he can obtain.
 

Input
The input consists of multiple test cases. Each test case begins with a line containing two non-negative integers M and N. Then N lines follow, each contains two non-negative integers J[i] and F[i] respectively. The last test case is followed by two -1's. All integers are not greater than 1000.
 

Output
For each test case, print in a single line a real number accurate up to 3 decimal places, which is the maximum amount of JavaBeans that FatMouse can obtain.
 

Sample Input
5 3
7 2
4 3
5 2
20 3
25 18
24 15
15 10
-1 -1
 

Sample Output
13.333
31.500
题目大意:M斤食物,换取最大N个房间的javaBean;
<hr/>

> struct可以像class一样写构造函数,还可以写内置方法;

```c
#include<cstdio>
#include<iostream>
#include<cstring>
#include<algorithm>

using namespace std;

typedef struct node
{
    int J, F;
    double rate;
    bool operator < (node x) const
    {
        return rate > x.rate;
    }
    node() {}
    void init(int j, int f)
    {
        J = j;
        F = f;
        rate = (double)J/(double)F;
    }
} Room;

Room room[1002];

int main()
{
    int M, N, j, f;
    double sum ;
    while(scanf("%d %d", &M, &N) && M != -1)
    {
        sum = 0;
        for(int i=0; i<N; i++)
        {
            scanf("%d %d", &j, &f);
            room[i].init(j, f);
        }
        sort(room, room+N);
        for(int i=0; i<N; i++)
        {
            if(M>=room[i].F)
            {
                sum += room[i].J;
                M -= room[i].F;
            }
            else
            {
                sum += (room[i].rate * M);
                break;
            }
        }
        printf("%.3f\n", sum);
    }
    return 0;
}

```

<hr/>

一个类似的题目,直接贴在这里好了.
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=1&sectionid=3&problemid=3)
```c
#include<cstdio>
#include<iostream>
#include<cstring>
#include<algorithm>

using namespace std;

typedef struct node
{
    int timeS, timeE;
    bool operator < (node x) const
    {
        return timeE < x.timeE;
    }
    node() {}
    void init(int s, int e)
    {
        timeS = s;
        timeE = e;
    }
} Show;

Show show[102];

int main()
{
    int t, sum, ts, te, s;
    while(scanf("%d", &t) && t != 0)
    {
        sum = 0;
        for(int i=0; i<t; i++)
        {
            scanf("%d %d", &ts, &te);
            show[i].init(ts, te);
        }
        sort(show, show+t);
        s = -1;
        for(int i=0; i<t; i++)
        {
            if(show[i].timeS>=s)
            {
                sum++;
                s = show[i].timeE;
            }
        }
        printf("%d\n", sum);
    }
    return 0;
}

```