---
title: Largest prime factor
date: 2016-06-22 17:45:58
category: hdu
tags:
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=2&sectionid=1&problemid=5)
Problem Description
Everybody knows any number can be combined by the prime number.
Now, your task is telling me what position of the largest prime factor.
The position of prime 2 is 1, prime 3 is 2, and prime 5 is 3, etc.
Specially, LPF(1) = 0.
 

Input
Each line will contain one integer n(0 < n < 1000000).
 

Output
Output the LPF(n).
 

Sample Input
1
2
3
4
5
 

Sample Output
0
1
2
1
3
<hr/>

求一个数的最大质因数!
我看完题目后理解成了,一个数可以由质数组合而成,求组合的最大质数.结果就陷入了无尽的深渊,什么整数划分动态规划都想了,结果一搜原来是求的最大质因数.kill me.

> 这里直接将下标写为最大质数的下标.

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


int prime[MAX];

void init()
{
    memset(prime, 0, sizeof(prime));
    for(int i = 2, k = 1; i<MAX; i++)
    {
        if(!prime[i])
        {
            prime[i] = k++;
            for(int j = 2; j * i < MAX; j++)
            {
                prime[j * i] = prime[i];
            }
        }
    }
}

int main()
{
    int n;
    init();
    while(scanf("%d", &n)!=EOF)
    {
        printf("%d\n", prime[n]);
    }
    return 0;
}


```