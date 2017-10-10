---
title: Ignatius and the Princess III
date: 2016-07-03 05:23:05
category: hdu
tags: 递归
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1028)
Problem Description
"Well, it seems the first problem is too easy. I will let you know how foolish you are later." feng5166 says.

"The second problem is, given an positive integer N, we define an equation like this:
  N=a[1]+a[2]+a[3]+...+a[m];
  a[i]>0,1<=m<=N;
My question is how many different equations you can find for a given N.
For example, assume N is 4, we can find:
  4 = 4;
  4 = 3 + 1;
  4 = 2 + 2;
  4 = 2 + 1 + 1;
  4 = 1 + 1 + 1 + 1;
so the result is 5 when N is 4. Note that "4 = 3 + 1" and "4 = 1 + 3" is the same in this problem. Now, you do it!"
 

Input
The input contains several test cases. Each test case contains a positive integer N(1<=N<=120) which is mentioned above. The input is terminated by the end of file.
 

Output
For each test case, you have to output a line contains an integer P which indicate the different equations you have found.
 

Sample Input
4
10
20
 

Sample Output
5
42
627

求整数n的划分个数.
<hr/>
[递推与分治练习](https://carl-zk.github.io/blog/2016/06/26/%E7%AC%AC2%E7%AB%A0-%E9%80%92%E5%BD%92%E4%B8%8E%E5%88%86%E6%B2%BB%E7%AD%96%E7%95%A5/)

主要用了记忆搜索,即将搜索结果保存到矩阵中.

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<list>
#include<set>
#include<queue>
#include<stack>
#include<vector>
#include<cmath>
#include<cstdlib>
#define MAX 121
#define INF 1<<20
#define TEST

using namespace std;

int a[MAX][MAX];

int fun(int n, int m)
{
    if(n<=0 || m <= 0)return 0;
    if(m < n)
    {
        if(!a[n-m][m])
        {
            a[n-m][m] = fun(n-m, m);
        }
        if(!a[n][m-1])
        {
            a[n][m-1] = fun(n, m-1);
        }
        return a[n-m][m] + a[n][m-1];
    }
    if(m>n)
    {
        if(!a[n][n])
        {
            a[n][n] = fun(n, n);
        }
        return a[n][n];
    }
    if(m == 1) return 1;
    if(m ==n)
    {
        if(!a[n][n-m])
        {
            a[n][m-1] = fun(n, m-1);
        }
        return 1 + a[n][m-1];
    }
}

int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
#endif
    memset(a, 0, sizeof(a));
    int n;
    while(~scanf("%d", &n))
    {
        printf("%d\n", fun(n, n));
    }
#ifdef TEST
    fclose(stdin);
#endif // TEST
    return 0;
}

```