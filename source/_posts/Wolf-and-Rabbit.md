---
title: Wolf and Rabbit
date: 2016-06-23 22:52:21
category: hdu
tags: 
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=2&sectionid=2&problemid=4)
Problem Description
There is a hill with n holes around. The holes are signed from 0 to n-1.


A rabbit must hide in one of the holes. A wolf searches the rabbit in anticlockwise order. The first hole he get into is the one signed with 0. Then he will get into the hole every m holes. For example, m=2 and n=6, the wolf will get into the holes which are signed 0,2,4,0. If the rabbit hides in the hole which signed 1,3 or 5, she will survive. So we call these holes the safe holes.
 

Input
The input starts with a positive integer P which indicates the number of test cases. Then on the following P lines,each line consists 2 positive integer m and n(0<m,n<2147483648).
 

Output
For each input m n, if safe holes exist, you should output "YES", else output "NO" in a single line.
 

Sample Input
2
1 2
2 2
 

Sample Output
NO
YES
<hr/>
> 找规律

当m,n互质的时候狼可以遍历一遍.


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

int gcd(int x, int y)
{
    return y?gcd(y, x%y):x;
}

int main()
{
    int P, m, n;
    scanf("%d", &P);
    while(P--)
    {
        scanf("%d %d", &m, &n);
        if(gcd(m, n)==1)
        {
            printf("NO\n");
        }
        else
        {
            printf("YES\n");
        }
    }
    return 0;
}

```