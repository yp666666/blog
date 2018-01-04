---
title: Leftmost Digit
date: 2016-06-22 17:08:07
category: hdu
tags: 
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=2&sectionid=1&problemid=11)
Leftmost Digit

Time Limit: 2000/1000 MS (Java/Others) Memory Limit: 65536/32768 K (Java/Others)
Total Submission(s): 3331 Accepted Submission(s): 1464

Problem Description
Given a positive integer N, you should output the leftmost digit of N^N.
 

Input
The input contains several test cases. The first line of the input is a single integer T which is the number of test cases. T test cases follow.
Each test case contains a single positive integer N(1<=N<=1,000,000,000).
 

Output
For each test case, you should output the leftmost digit of N^N.
 

Sample Input
2
3
4
 

Sample Output
2
2

Hint

In the first case, 3 * 3 * 3 = 27, so the leftmost digit is 2.
In the second case, 4 * 4 * 4 * 4 = 256, so the leftmost digit is 2.
<hr />

> 给参考博主点赞!感觉我的数学已经废了,忘记log函数了.
> 对double类型取整要用long long 类型, 否则AC不过.

```c
#include<cstdio>
#include<iostream>
#include<cstring>
#include<algorithm>
#include<set>
#include<cmath>
#include<cstdlib>
#define MAX 1000001
using namespace std;


int leftMostDigit(long long d)
{
    double p = d * log10(d);
    p -= (long long) p;
    return pow(10, p);
}

int main()
{
    int n, d;
    scanf("%d", &n);
    while(n--)
    {
        scanf("%d", &d);
        printf("%d\n", leftMostDigit(d));
    }

    return 0;
}

```

[参考链接](http://blog.sina.com.cn/s/blog_64e467d60100zznb.html)
