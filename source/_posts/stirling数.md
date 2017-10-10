---
title: stirling数
date: 2016-06-25 16:35:51
category: hdu
tags: 组合数学
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=2&sectionid=2&problemid=11)
Examining the Rooms

Time Limit: 2000/1000 MS (Java/Others) Memory Limit: 32768/32768 K (Java/Others)
Total Submission(s): 801 Accepted Submission(s): 437

Problem Description
A murder happened in the hotel. As the best detective in the town, you should examine all the N rooms of the hotel immediately. However, all the doors of the rooms are locked, and the keys are just locked in the rooms, what a trap! You know that there is exactly one key in each room, and all the possible distributions are of equal possibility. For example, if N = 3, there are 6 possible distributions, the possibility of each is 1/6. For convenience, we number the rooms from 1 to N, and the key for Room 1 is numbered Key 1, the key for Room 2 is Key 2, etc.
To examine all the rooms, you have to destroy some doors by force. But you don’t want to destroy too many, so you take the following strategy: At first, you have no keys in hand, so you randomly destroy a locked door, get into the room, examine it and fetch the key in it. Then maybe you can open another room with the new key, examine it and get the second key. Repeat this until you can’t open any new rooms. If there are still rooms un-examined, you have to randomly pick another unopened door to destroy by force, then repeat the procedure above, until all the rooms are examined.
Now you are only allowed to destroy at most K doors by force. What’s more, there lives a Very Important Person in Room 1. You are not allowed to destroy the doors of Room 1, that is, the only way to examine Room 1 is opening it with the corresponding key. You want to know what is the possibility of that you can examine all the rooms finally.
 

Input
The first line of the input contains an integer T (T ≤ 200), indicating the number of test cases. Then T cases follow. Each case contains a line with two numbers N and K. (1 < N ≤ 20, 1 ≤ K < N)
 

Output
Output one line for each case, indicating the corresponding possibility. Four digits after decimal point are preserved by rounding.
 

Sample Input
3
3 1
3 2
4 2
 

Sample Output
0.3333
0.6667
0.6250
Hint

Sample Explanation

When N = 3, there are 6 possible distributions of keys:

  Room 1	Room 2	Room 3	Destroy Times
\#1	Key 1	Key 2	Key 3	Impossible
\#2	Key 1	Key 3	Key 2	Impossible
\#3	Key 2	Key 1	Key 3	Two
\#4	Key 3	Key 2	Key 1	Two
\#5	Key 2	Key 3	Key 1	One
\#6	Key 3	Key 1	Key 2	One

In the first two distributions, because Key 1 is locked in Room 1 itself and you can’t destroy Room 1, it is impossible to open Room 1. 
In the third and forth distributions, you have to destroy Room 2 and 3 both. In the last two distributions, you only need to destroy one of Room 2 or Room 

n个房间,n把钥匙,每个房间放一把.开始时所有房间的门是锁着的,你有k次机会砸开门,但是第一个房间不能砸,求可以将门全部打开的概率是多少.
<hr />

stirling数可以解决n个房间k个闭环的问题.
当n=3, k=1时,满足条件的有两个:

|房间1|房间2|房间3
|-------|:---------:|--------:
|2|3|1
|3|1|2

它们的闭环路径分别是:**1** *2* --> **2** *3* --> **3** *1*; 1 3 --> 3 2 --> 2 1.
闭环是说你打开环上的任一扇门,其它门就都可以打开.

所以k次砸门的机会指的是n个房间形成的闭环个数不会大于k.

定义S(n, k)为解, 则S(n, 0)=0, S(1, 1)=1,
当第n+1, m时:
1. n个房间形成m-1个闭环, 则有S(n, m-1)种情况;
2. n个房间形成m个闭环, 则将第n+1任一插到某数之前, 有 n * S(n, m)种情况.
综上: S(n, k) = S(n-1, k-1) + (n-1)*S(n-1, k).

> 本题第一扇门不能砸, 所以要减去第一扇门独自成环的情况


```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<cmath>
#include<cstdlib>
#define MAX 21

using namespace std;

double a[MAX][MAX];  //保留结果
//k*n
long long stirling[MAX][MAX], facto[MAX], total; //stirling数, factorial阶乘

void init()
{
    memset(a, 0, sizeof(a));
    memset(stirling, 0, sizeof(stirling));
    memset(facto, 0, sizeof(facto));
    stirling[1][1]=1;
    facto[1] = 1;
    for(int i=2; i<MAX; i++)
    {
        facto[i] = i * facto[i-1];
        stirling[i][i] = 1;
        for(int j=1; j<i; j++)
        {
            stirling[j][i] = stirling[j-1][i-1] + (i-1)*stirling[j][i-1];
        }
    }
}

int main()
{
    int TC, m, k;

    init();
    scanf("%d", &TC);
    while(TC--)
    {
        scanf("%d %d", &m, &k);
        if(0 == a[m][k])
        {
            total = 0;
            for(int i=1; i<=k; i++) //要减去 除第1扇门外m-1所组成的闭环数
            {
                total += stirling[i][m] - stirling[i-1][m-1];
            }
            a[m][k] = (double)total / facto[m];
        }
        printf("%.4f\n", a[m][k]);
    }
    return 0;
}

``` 