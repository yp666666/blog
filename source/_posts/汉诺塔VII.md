---
title: 汉诺塔VII
date: 2016-06-23 18:01:47
category: hdu
tags: 递归
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=2&sectionid=2&problemid=3)
Problem Description
n个盘子的汉诺塔问题的最少移动次数是2^n-1,即在移动过程中会产生2^n个系列。由于发生错移产生的系列就增加了，这种错误是放错了柱子，并不会把大盘放到小盘上，即各柱子从下往上的大小仍保持如下关系 ： 
n=m+p+q
a1>a2>...>am
b1>b2>...>bp
c1>c2>...>cq
ai是A柱上的盘的盘号系列，bi是B柱上的盘的盘号系列， ci是C柱上的盘的盘号系列，最初目标是将A柱上的n个盘子移到C盘. 给出1个系列，判断它是否是在正确的移动中产生的系列.
例1：n=3
3
2
1
是正确的
例2：n=3
3
1
2
是不正确的。
注：对于例2如果目标是将A柱上的n个盘子移到B盘. 则是正确的.
 

Input
包含多组数据，首先输入T,表示有T组数据.每组数据4行，第1行N是盘子的数目N<=64.
后3行如下
m a1 a2 ...am
p b1 b2 ...bp
q c1 c2 ...cq
N=m+p+q,0<=m<=N,0<=p<=N,0<=q<=N,
 

Output
对于每组数据，判断它是否是在正确的移动中产生的系列.正确输出true，否则false
 

Sample Input
6
3
1 3
1 2
1 1
3
1 3
1 1
1 2
6
3 6 5 4
1 1
2 3 2
6
3 6 5 4
2 3 2
1 1
3
1 3
1 2
1 1
20
2 20 17
2 19 18
16 16 15 14 13 12 11 10 9 8 7 6 5 4 3 2 1
 

Sample Output
true
false
false
false
true
true
<hr/>

首先膜拜递归高手,无论是解题人还是出题人!

![](http://o6ibfi17w.bkt.clouddn.com/images/hannoi.png)

将盘子从A柱移到C柱:
最大值永远不可能出现在B柱.
当最大值在A柱时,其上的n-1个盘子正在经历从A--->B的过程;
当最大值在C柱时,其上的n-1个盘子在经历从B--->C的过程.

解析:从图中可以看出,当最大值在A时,次大值不可能在C.当最大值在C时,次大值不可能在A.也就是意味着在整个过程中,次大值永远处在过渡柱子之上.如果你根据最大值是否在A或C上,然后再去比较次大值会发现,和上面的算法的递归是一模一样的.

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<cmath>
#include<cstdlib>
#define MAX 66

using namespace std;


bool hanoi(int len, int *A, int *B, int *C)
{
    if(len == 0)return true;
    if(B[0] && B[0]==len)return false;
    if(A[0] && A[0] == len)     //最大在a上
    {
        return hanoi(len-1, ++A, C, B);
    }
    else
    {
        return hanoi(len-1, B, A, ++C);
    }
}


int main()
{
    int x, y, T;
    int a[MAX], n, alen, blen, clen;
    scanf("%d", &T);
    while(T--)
    {
        memset(a, 0, sizeof(a));
        x = 0;
        scanf("%d", &n);
        scanf("%d", &alen);
        for(int i=0; i<alen; i++)
        {
            scanf("%d", &a[x++]);
        }
        scanf("%d", &blen);
        for(int i=0; i<blen; i++)
        {
            scanf("%d", &a[x++]);
        }
        scanf("%d", &clen);
        for(int i=0; i<clen; i++)
        {
            scanf("%d", &a[x++]);
        }
        if(hanoi(n, &a[0], &a[alen], &a[alen+blen]))
        {
            printf("true\n");
        }
        else
        {
            printf("false\n");
        }
    }
    return 0;
}

```

[参考链接](http://www.cnblogs.com/xuxueyang/p/4290930.html)