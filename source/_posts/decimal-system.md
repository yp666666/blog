---
title: decimal system
date: 2016-06-21 08:52:17
category: hdu
tags:
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=1&sectionid=2&problemid=18)
**decimal system**
Problem Description
As we know , we always use the decimal system in our common life, even using the computer. If we want to calculate the value that 3 plus 9, we just import 3 and 9.after calculation of computer, we will get the result of 12.
But after learning <<The Principle Of Computer>>,we know that the computer will do the calculation as the following steps:
1 computer change the 3 into binary formality like 11;
2 computer change the 9 into binary formality like 1001;
3 computer plus the two number and get the result 1100;
4 computer change the result into decimal formality like 12;
5 computer export the result;

In the computer system there are other formalities to deal with the number such as hexadecimal. Now I will give several number with a kind of change method, for example, if I give you 1011(2), it means 1011 is a number in the binary system, and 123(10) means 123 if a number in the decimal system. Now I will give you some numbers with any kind of system, you guys should tell me the sum of the number in the decimal system.
 

Input
There will be several cases. The first line of each case contains one integers N, and N means there will be N numbers to import, then there will be N numbers at the next N lines, each line contains a number with such form : X1….Xn.(Y), and 0<=Xi<Y, 1<Y<=10. I promise you that the sum will not exceed the 100000000, and there will be at most 100 cases and the 0<N<=1000.

Output
There is only one line output case for each input case, which is the sum of all the number. The sum must be expressed using the decimal system.


Sample Input
3
1(2)
2(3)
3(4)

4
11(10)
11(2)
11(3)
11(4)
 

Sample Output
6
23

题目大意: 给定一个随意进制的数组,求和;

<hr/>


```c
#include<cstdio>
#include<iostream>
#include<cstring>
#include<algorithm>

using namespace std;


int convertToDecimal(char a[], int idxE, int f)
{
    int dec = 0;
    for(int i=0; i<idxE; i++)
    {
        dec = dec * f + (a[i]-'0');
    }
    return dec;
}

int strToNum(char str[], int idxS, int idxE)
{
    int num = 0;
    while(idxS < idxE)
    {
        num = num * 10 + (str[idxS++] - '0');
    }
    return num;
}

int main()
{
    char a[20];
    int t, j, len, sum;
    while(scanf("%d", &t) != EOF)
    {
        sum = 0;
        while(t--)
        {
            scanf("%s", &a);
            len = strlen(a);
            j = 0;
            while(a[j]!='(')j++;
            sum += convertToDecimal(a, j, strToNum(a, j+1, len-1));
        }
        printf("%d\n", sum);
    }
    return 0;
}

```