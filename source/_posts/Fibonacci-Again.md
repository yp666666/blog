---
title: Fibonacci Again
date: 2016-06-30 13:28:56
category: hdu
tags: 
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1021)
Problem Description
There are another kind of Fibonacci numbers: F(0) = 7, F(1) = 11, F(n) = F(n-1) + F(n-2) (n>=2).
 

Input
Input consists of a sequence of lines, each containing an integer n. (n < 1,000,000).
 

Output
Print the word "yes" if 3 divide evenly into F(n).

Print the word "no" if not.
 

Sample Input
0
1
2
3
4
5
 

Sample Output
no
no
yes
no
no
no

问F(n)能否被3整除.
<hr/>

寻找规律是件有意思的事情,发现规律是很令人鸡冻的.
n < 1,000,000, F(n)最大时已经不能用long long 表示.
能被3整除的数如123,各位数字相加也能被3整除.所以F(i)可化简为个位数字.
又F(i)的范围为[1, 9], 所以周期肯定在9*9=81之内, 又因为不会有两个9同时出现的情况,所以周期就是80.
计算前80项,然后n%80即可.

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<vector>
#include<cmath>
#include<cstdlib>
#define MAX 84
#define TEST

using namespace std;

int a[MAX] = {7, 2};

void init()
{
    for(int i=2; i<MAX; i++)
    {
        a[i] = a[i-1] + a[i-2];
        if(a[i]>9)
        {
            a[i] = a[i]/10+a[i]%10;
        }
    }
}

int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
    //freopen("out.txt", "w", stdout);
#endif
    int n,tc;
    init();
    while(~scanf("%d", &n))
    {
        if(a[n%80]%3)
        {
            printf("no\n");
        }
        else
        {
            printf("yes\n");
        }
    }

#ifdef TEST
    fclose(stdin);
    //fclose(stdout);
#endif // TEST
    return 0;
}

```