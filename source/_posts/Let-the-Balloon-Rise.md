---
title: Let the Balloon Rise
date: 2016-06-27 11:58:21
category: hdu
tags: trie树
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1004)
Problem Description
Contest time again! How excited it is to see balloons floating around. But to tell you a secret, the judges' favorite time is guessing the most popular problem. When the contest is over, they will count the balloons of each color and find the result.

This year, they decide to leave this lovely job to you. 
 

Input
Input contains multiple test cases. Each test case starts with a number N (0 < N <= 1000) -- the total number of balloons distributed. The next N lines contain one color each. The color of a balloon is a string of up to 15 lower-case letters.

A test case with N = 0 terminates the input and this test case is not to be processed.
 

Output
For each case, print the color of balloon for the most popular problem on a single line. It is guaranteed that there is a unique solution for each test case.
 

Sample Input
5
green
red
blue
red
red
3
pink
orange
pink
0
 

Sample Output
red
pink

统计字符串个数, 打印出最多的, 有且只有一个哦.
<hr/>

trie树又叫字典树, 最大深度也不过是最长单词的长度,所以查询很快.
唯一要注意的就是指针的操作, 以及防止内存泄露.

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<cmath>
#include<cstdlib>
#define MAX 20
#define MIN -1001

using namespace std;

/**
* trie树结构体
*/
typedef struct node
{
    int value;
    char c;
    node *next[26];
    void init(char ch)
    {
        value = 0;
        c = ch;
        memset(next, 0, sizeof(next));
    }
} Node;

Node *trie;

/**
* 构建trie树
*/
int fun(char *A, int len)
{
    if(trie == NULL)
    {
        trie = (Node*)malloc(sizeof(Node));
        trie->init(' ');
    }
    Node *next = trie, *p;
    for(int i=0; i<len; i++)
    {
        p = next;
        next = next->next[A[i]-'a'];
        if(next == NULL)  //这里的指针需要注意
        {
            next = (Node*)malloc(sizeof(Node));
            next->init(A[i]);
            p->next[A[i]-'a'] = next; //需要指回原结点指针
        }
    }
    next->value++;
    return next->value;
}

void distr(Node *nx) //防止内存泄露
{
    if(nx != NULL)
    {
        //printf("free %c, \n", nx->c);
        for(int i=0; i<26; i++)
        {
            distr(nx->next[i]);
        }
        free(nx);
    }
}

int main()
{
    int n, mx, t;
    char ball[MAX], mxball[MAX];
    while(scanf("%d", &n), n!=0)
    {
        trie = NULL;  //free之后重新指向NULL,防止野指针
        mx = 0;
        while(n--)
        {
            scanf("%s", &ball);
            t = fun(ball, strlen(ball));
            if(t > mx)
            {
                mx = t;
                strcpy(mxball, ball);
            }
        }
        printf("%s\n",mxball);
        distr(trie);
    }
    return 0;
}

```