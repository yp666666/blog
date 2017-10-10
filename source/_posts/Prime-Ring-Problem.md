---
title: Prime Ring Problem
date: 2016-06-30 04:35:20
category: hdu
tags: 递归
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1016)
Problem Description
A ring is compose of n circles as shown in diagram. Put natural number 1, 2, ..., n into each circle separately, and the sum of numbers in two adjacent circles should be a prime.

Note: the number of first circle should always be 1.


 

Input
n (0 < n < 20).
 

Output
The output format is shown as sample below. Each row represents a series of circle numbers in the ring beginning from 1 clockwisely and anticlockwisely. The order of numbers must satisfy the above requirements. Print solutions in lexicographical order.

You are to write a program that completes above process.

Print a blank line after each case.
 

Sample Input
6
8

给定素数环的大小n,列举出满足条件的排列.
<hr/>


n最大为19,19!=121645100408832000,所以不能用全排列的方法.可以使用DFS.
我的方法在尝试前以为会超时,调试发现速度飞快.时间复杂度什么东东已经不会算了.
n<20,所以最大和为37,列举前12个素数, 用素数减去环上前一个数,然后依次递归即可.
最后只需判断第一个和最后一个之和是否满足条件.
如果没算错,时间复杂度应该是12^n,可能是条件太苛刻了吧.

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<vector>
#include<cmath>
#include<cstdlib>
#define MAX 21
#define TEST

using namespace std;

int prime[12] = {2,3,5,7,11,13,17,19,23,29,31,37};
int a[MAX], n;
bool visit[MAX];

bool isAPri(int p)
{
    int left = 0, right = 11, mid;
    while(left < right)
    {
        mid = (left + right) >> 1;
        if(prime[mid]==p)return true;
        else if(prime[mid]>p)
        {
            right = mid -1;
        }
        else
        {
            left = mid + 1;
        }
    }
    return prime[left]==p;
}

void fun(int *A, int idx)
{
    if(idx == n)
    {
        //只需判断首尾之和是否是素数
        if(!isAPri(A[0]+A[n-1]))return;
        for(int i=0; i<n-1; i++)
        {
            printf("%d ", A[i]);
        }
        printf("%d\n", A[n-1]);
        return;
    }
    //用素数去求下一位
    for(int i=0, j; i<12; i++)
    {
        j = prime[i] - A[idx-1];
        if(j>1 && j<=n && !visit[j])
        {
            visit[j] = true;
            A[idx] = j;
            fun(A, idx+1);
            visit[j] = false;
        }
    }
}

int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
    //freopen("out.txt", "w", stdout);
#endif
    int tc = 1;
    a[0] = 1;
    while(~scanf("%d", &n))
    {
        memset(visit, 0, sizeof(visit));
        printf("Case %d:\n", tc++);
        fun(a, 1);
        printf("\n");
    }

#ifdef TEST
    fclose(stdin);
    //fclose(stdout);
#endif // TEST
    return 0;
}

```