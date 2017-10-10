---
title: The 3n + 1 problem
date: 2016-07-04 11:06:31
category: hdu
tags:
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1032)
Problem Description
Problems in Computer Science are often classified as belonging to a certain class of problems (e.g., NP, Unsolvable, Recursive). In this problem you will be analyzing a property of an algorithm whose classification is not known for all possible inputs.

Consider the following algorithm T: 


    1.      input n

    2.      print n

    3.      if n = 1 then STOP

    4.           if n is odd then n <- 3n + 1

    5.           else n <- n / 2

    6.      GOTO 2


Given the input 22, the following sequence of numbers will be printed 22 11 34 17 52 26 13 40 20 10 5 16 8 4 2 1 

It is conjectured that the algorithm above will terminate (when a 1 is printed) for any integral input value. Despite the simplicity of the algorithm, it is unknown whether this conjecture is true. It has been verified, however, for all integers n such that 0 < n < 1,000,000 (and, in fact, for many more numbers than this.) 

Given an input n, it is possible to determine the number of numbers printed (including the 1). For a given n this is called the cycle-length of n. In the example above, the cycle length of 22 is 16. 

For any two numbers i and j you are to determine the maximum cycle length over all numbers between i and j. 
 

Input
The input will consist of a series of pairs of integers i and j, one pair of integers per line. All integers will be less than 1,000,000 and greater than 0. 

You should process all pairs of integers and for each pair determine the maximum cycle length over all integers between and including i and j. 

You can assume that no opperation overflows a 32-bit integer.
 

Output
For each pair of input integers i and j you should output i, j, and the maximum cycle length for integers between and including i and j. These three numbers should be separated by at least one space with all three numbers on one line and with one line of output for each line of input. The integers i and j must appear in the output in the same order in which they appeared in the input and should be followed by the maximum cycle length (on the same line). 
 

Sample Input
1 10
100 200
201 210
900 1000
 

Sample Output
1 10 20
100 200 125
201 210 89
900 1000 174

整数n按照给定算法T会得到一个数列.求两个整数间最长数列的长度.
<hr/>
主要是用到了记录计算结果.a[i]是整数为i时数列的长度.
如:n=6时,则数列是6,3,10,5,16,8,4,2,1.会有
a[6] = a[3] + 1.
a[3] = a[10] + 1.
a[10] = a[5] + 1.
a[5] = a[16] + 1.
a[16] = a[8] + 1.
a[8] = a[4] + 1.
a[4] = a[2] + 1.
a[2] = a[1] + 1.
a[1] = 1. 
题目中埋的坑是输入的两个整数不是从小到大的,需要做比较,而当输出时,是按照输入的顺序.

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
#define MAX 1000010
#define INF 1<<20
#define TEST

using namespace std;

long long a[MAX];

long long algo(long long n)
{
    if(n < MAX && a[n])return a[n];
    else if(n == 1) return 1;
    else if(n%2 == 1)
    {
        n = 3*n+1;
        if(n<MAX && a[n] == 0)
        {
            a[n] = algo(n);
            return a[n]+1;
        }
        else if(n<MAX && a[n] != 0)
        {
            return a[n]+1;
        }
        else return 1 + algo(n);
    }
    else
    {
        n = n>>1;
        if(n<MAX && a[n] == 0)
        {
            a[n] = algo(n);
            return a[n] + 1;
        }
        else if(n<MAX && a[n] != 0)
        {
            return a[n]+1;
        }
        else
        {
            return 1 + algo(n);
        }
    }
}
int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
#endif
    long n = 0, t, s, e, ss, ee;
    memset(a, 0, sizeof(a));
    //为保证打印的数字1和数字2是按照输入顺序,故另设两个变量代替,以便于大小交换
    while(~scanf("%d %d", &ss, &ee))
    {
        s = ss, e = ee;
        if(s>e)
        {
            swap(s, e);
        }
        n = 0;
        for(int i=s; i<=e; i++)
        {
            t = algo(i);
            if(n<t)n=t;
        }
        printf("%ld %ld %ld\n", ss, ee, n);
    }

#ifdef TEST
    fclose(stdin);
#endif // TEST
    return 0;
}

```