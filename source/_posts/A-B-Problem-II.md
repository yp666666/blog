---
title: A + B Problem II
date: 2016-06-26 10:35:08
category: hdu
tags:
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1002)
Problem Description
I have a very simple problem for you. Given two integers A and B, your job is to calculate the Sum of A + B.
 

Input
The first line of the input contains an integer T(1<=T<=20) which means the number of test cases. Then T lines follow, each line consists of two positive integers, A and B. Notice that the integers are very large, that means you should not process them by using 32-bit integer. You may assume the length of each integer will not exceed 1000.
 

Output
For each test case, you should output two lines. The first line is "Case #:", # means the number of the test case. The second line is the an equation "A + B = Sum", Sum means the result of A + B. Note there are some spaces int the equation. Output a blank line between two test cases.
 

Sample Input
2
1 2
112233445566778899 998877665544332211
 

Sample Output
Case 1:
1 + 2 = 3

Case 2:
112233445566778899 + 998877665544332211 = 1111111111111111110
<hr/>

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<cmath>
#include<cstdlib>
#define MAX 1005

using namespace std;

char a[MAX], b[MAX], ans[MAX], resa[MAX], resb[MAX];
int alen, blen, y;

void strrev(char *s, int len)
{
    char c;
    int mid = len >> 1;
    for(int i=0; i<mid; i++)
    {
        c = s[i];
        s[i] = s[len - 1 - i];
        s[len - 1 - i] = c;
    }
}

void strsum()
{
    int y = 0;
    for(int i=0; i<blen; i++)
    {
        y = y+ans[i]+b[i]-96;
        ans[i] = y%10 + 48;
        y/=10;
    }
    for(int i=blen; i<alen; i++)
    {
        y = y+ans[i]-48;
        ans[i] = y % 10 + 48;
        y/=10;
    }
    if(y)
    {
        printf("1");
    }
    for(int i=alen-1; i>-1; i--)
    {
        printf("%c", ans[i]);
    }
    printf("\n");
}

int main()
{
    int tc;
    scanf("%d", &tc);
    for(int i=1; i<=tc; i++)
    {
        memset(ans, 0, sizeof(ans));
        scanf("%s %s", &a, &b);
        strcpy(resa, a);
        strcpy(resb, b);
        strrev(a, strlen(a));
        strrev(b, strlen(b));
        if(strlen(a)>strlen(b))
        {
            strcpy(ans, a);
        }
        else
        {
            strcpy(ans, b);
            strcpy(b, a);
        }
        alen = strlen(ans);
        blen = strlen(b);
        printf("Case %d:\n%s + %s = ", i, resa, resb);
        strsum();
        if(i<tc)printf("\n");
    }
    return 0;
}

```