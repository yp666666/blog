---
title: '哈哈,发现hdu错题一道'
date: 2016-06-24 02:01:12
category: hdu
tags:
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=2&sectionid=2&problemid=8)
Number Sequence

Time Limit: 2000/1000 MS (Java/Others) Memory Limit: 65536/32768 K (Java/Others)
Total Submission(s): 1762 Accepted Submission(s): 675

Problem Description
A number sequence is defined as follows:

f(1) = 1, f(2) = 1, f(n) = (A * f(n - 1) + B * f(n - 2)) mod 7.

Given A, B, and n, you are to calculate the value of f(n).
 

Input
The input consists of multiple test cases. Each test case contains 3 integers A, B and n on a single line (1 <= A, B <= 1000, 1 <= n <= 100,000,000). Three zeros signal the end of input and this test case is not to be processed.
 

Output
For each test case, print the value of f(n) on a single line.
 

Sample Input
1 1 3
1 2 10
0 0 0
 

Sample Output
2
5
<hr />

AC代码如下:

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<cmath>
#include<cstdlib>
#define MAX 50

using namespace std;

int f[MAX] = {0,1,1,};

int circ(int a, int b, int n)
{
    //f[0]=0;   取消注释测试会有惊喜哦
    //f[0]=1;
    f[1] = f[2] = 1;
    for(int i=3; i<MAX; i++)
    {
        f[i] = (a*f[i-1]+b*f[i-2]) % 7;
    }
    return f[n%49];
}


int main()
{
    int A,B,n;
    while(scanf("%d %d %d", &A, &B, &n),A!=0 || B!=0 ||n!=0)
    {
        printf("%d\n", circ(A,B,n));

    }
    return 0;
}

```

是这样的,看到这道题的第一感觉肯定是以为找规律题,没错!BUT,你能猜到周期是几吗?
因为f=(x+y)%7, x和y又都<7,所以x和y的组合不过只有7*7=49种情况,照这样编码,so easy!?

解释一下,出题人显然没搞懂**周期**的概念,最大情况49是没错,错就错在它并不能代表周期的倍数,同时你也不知道周期是从第几个开始的.举个例子:当A=5,B=7时,周期从第2个开始;当A=6,B=8时,周期从1开始.
1. A=5, B=7的情况:


|n  |f[n]的真实值| f[0] = 1时| f[0] = 0时|
|----|:---------:|:--------------:|------------:|
|49|3|1|0|
|50|1|1|1
|51|5|1|1
|52|4|5|5


LOOK,可以AC的代码竟然会出现这样的结果!
真正的答案应该是找出周期T和周期开始位置S,结束位置E.根据实际情况去计算.

不过猜想题主的用意是利用周期,所以可能没在意这些细节吧!这题折磨我好久,终于可以安心的睡了.
