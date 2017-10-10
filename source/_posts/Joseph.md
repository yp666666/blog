---
title: Joseph
date: 2016-06-23 13:37:53
category: hdu
tags: 约瑟夫环
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=2&sectionid=2&problemid=2)
Problem Description
The Joseph\\\\\\\'s problem is notoriously known. For those who are not familiar with the original problem: from among n people, numbered 1, 2, . . ., n, standing in circle every mth is going to be executed and only the life of the last remaining person will be saved. Joseph was smart enough to choose the position of the last remaining person, thus saving his life to give us the message about the incident. For example when n = 6 and m = 5 then the people will be executed in the order 5, 4, 6, 2, 3 and 1 will be saved.

Suppose that there are k good guys and k bad guys. In the circle the first k are good guys and the last k bad guys. You have to determine such minimal m that all the bad guys will be executed before the first good guy.
 

Input
The input file consists of separate lines containing k. The last line in the input file contains 0. You can suppose that 0 < k < 14.
 

Output
The output file will consist of separate lines containing m corresponding to k in the input file.
 

Sample Input
3
4
0
 

Sample Output
5
30
<hr/>

编号1~2*k个人组成环,好人坏人各一半,k+1~2*k为坏人;每次报数为m的人被kill,求坏人全部先死掉的m的最小值.

设pre为前一个报数人的编号.初始值为0.
当k=3,m=5时,
5%6 = 5, 从pre向后数5个,即第5个人被kill.pre=5;
5%(6-1)=0, 即 pre的前一个人,即4被kill.pre=4;
5%(6-2)=1,即pre的后一个人, 即6被kill.pre=6;
至此k个坏人全部先于好人被kill.则m=5即为所求.

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<cmath>
#include<cstdlib>
#define MAX 29

using namespace std;

int ans[15]= {0,2,};//保留计算值

bool visited[MAX];

int main()
{
    int k, pre, m, n;
    while(scanf("%d",&k)&&k!=0)
    {
        if(ans[k])
        {
            printf("%d\n", ans[k]);
        }
        else
        {
            memset(visited, 0, sizeof(visited));
            pre = 0;   //上一个访问点
            visited[0] = true;
            m = 1;     //要求的答案
            n = k * 2;
            for(int i=0, j; i<k; i++)
            {
                j = m % (n - i);
                if(j)    //大于0,想下寻找j个未访问点
                {
                    while(j)
                    {
                        if(!visited[++pre])
                        {
                            j--;
                        }
                        if(pre > n) pre = 1;
                    }
                    visited[pre] = true;
                }
                else     //等于0,向前寻找第一个未访问点
                {
                    if(pre == 0)pre = n;
                    while(visited[pre])
                    {
                        pre--;
                        if(pre == 0)pre = n;
                    }
                    visited[pre] = true;
                }
                if(pre<=k)    //在前k项中如果有比k小的人被kill,将参数重置,m+1
                {
                    memset(visited, 0, sizeof(visited));
                    pre = 0;
                    visited[0] = true;
                    m++;
                    i=-1;
                }
            }
            ans[k] = m;
            printf("%d\n", ans[k]);
        }
    }
    return 0;
}

```
