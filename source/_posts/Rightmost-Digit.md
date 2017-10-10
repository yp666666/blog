---
title: Rightmost Digit
date: 2016-06-20 22:38:20
category: hdu 
tags: 
---

[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=1&sectionid=2&problemid=12)
Problem Description
Given a positive integer N, you should output the most right digit of N^N.
 

Input
The input contains several test cases. The first line of the input is a single integer T which is the number of test cases. T test cases follow.
Each test case contains a single positive integer N(1<=N<=1,000,000,000).
 

Output
For each test case, you should output the rightmost digit of N^N.
 

Sample Input
2
3
4
 

Sample Output
7
6

Hint

In the first case, 3 * 3 * 3 = 27, so the rightmost digit is 7.
In the second case, 4 * 4 * 4 * 4 = 256, so the rightmost digit is 6.

<hr />

在维基百科查到这样一段代码:
```c
   double power (double a, unsigned int n)
   {
        double y = 1;
        double f = a;
        unsigned int k = n;
        while (k != 0) {
           if (k % 2 == 1) y *= f;
           k >>= 1;
           f *= f;
        }
        return y;
   }
```
> 当 a=n=5时:

|5    |      2     |  1 |
|:------:|:---------:|:-------:|
|5^2   | 5^4|

> 当a=n=8时:

|8   |   4   |   2|   1 |
|:-------:|:-------:|:--------:|:-------:|
|8^2|8^4|8^8|

这个算法真的达到了指数级增长,时间复杂度仅为**O**(log *n* ),代码优美.

由此修改就可得到AC代码:
```c
#include<cstdio>
#include<iostream>
#include<math.h>
#include<algorithm>

using namespace std;

int myPow(int a, int n)
{
    int k = n;
    int x = a % 10, y = 1;
    while(k != 0)
    {
        if(k % 2 == 1)
        {
            y = (y * x) % 10;
        }
        x = (x * x) % 10;
        k >>= 1;
    }
    return y;
}

int main()
{
    int t, y;
    scanf("%d", &t);
    while(t--)
    {
        scanf("%d", &y);
        printf("%d\n", myPow(y, y));
    }

    return 0;
}

```