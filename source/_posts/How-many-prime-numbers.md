---
title: How many prime numbers
date: 2016-06-21 22:25:22
category: hdu
tags:
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=2&sectionid=1&problemid=2)
Problem Description
Give you a lot of positive integers, just to find out how many prime numbers there are.
 

Input
There are a lot of cases. In each case, there is an integer N representing the number of integers to find. Each integer won’t exceed 32-bit signed integer, and each of them won’t be less than 2.
 

Output

            For each case, print the number of prime numbers you have found out.
 

Sample Input
3
2 3 4
 

Sample Output
2
题目大意: 数质数的个数;
<hr />

```c
#include<cstdio>
#include<iostream>
#include<cstring>
#include<algorithm>
#include<set>
#include<cmath>
#include<cstdlib>
#define MAX (1 << 20)
using namespace std;

bool a[MAX];

void init()
{
    fill(a, a+MAX, true);
    for(int i=2; i< MAX; i++)
    {
        if(a[i])
        {
            for(int j=2; j*i<MAX; j++)
            {
                a[i * j] = false;
            }
        }
    }
}

int main()
{
    int m, n, t, k;
    bool b;
    init();
    while(scanf("%d", &t)!=EOF)
    {
        n = 0;
        for(int i=0; i<t; i++)
        {
            scanf("%d", &m);
            if(m<MAX)
            {
                if(a[m])
                {
                    n++;
                }
            }
            else
            {
                b = true;
                k = (int)(0.5+sqrt(m));
                for(int j=2; j<=k; j++)
                {
                    if(m % j==0)
                    {
                        b = false;
                        break;
                    }
                }
                if(b)
                {
                    n++;
                }
            }
        }
        printf("%d\n", n);
    }
    return 0;
}

```