---
title: Train Problem I
date: 2016-06-30 14:30:04
category: hdu
tags:
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1022)
Problem Description
As the new term comes, the Ignatius Train Station is very busy nowadays. A lot of student want to get back to school by train(because the trains in the Ignatius Train Station is the fastest all over the world ^v^). But here comes a problem, there is only one railway where all the trains stop. So all the trains come in from one side and get out from the other side. For this problem, if train A gets into the railway first, and then train B gets into the railway before train A leaves, train A can't leave until train B leaves. The pictures below figure out the problem. Now the problem for you is, there are at most 9 trains in the station, all the trains has an ID(numbered from 1 to n), the trains get into the railway in an order O1, your task is to determine whether the trains can get out in an order O2.

 

Input
The input contains several test cases. Each test case consists of an integer, the number of trains, and two strings, the order of the trains come in:O1, and the order of the trains leave:O2. The input is terminated by the end of file. More details in the Sample Input.
 

Output
The output contains a string "No." if you can't exchange O2 to O1, or you should output a line contains "Yes.", and then output your way in exchanging the order(you should output "in" for a train getting into the railway, and "out" for a train getting out of the railway). Print a line contains "FINISH" after each test case. More details in the Sample Output.
 

Sample Input
3 123 321
3 123 312
 

Sample Output
Yes.
in
in
in
out
out
out
FINISH
No.
FINISH

判断列车出栈顺序是否正确.
<hr/>


虽然说只有9列车,但不代表最大字符串就是9.

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<stack>
#include<vector>
#include<cmath>
#include<cstdlib>
#define MAX 60
#define TEST

using namespace std;

char a[MAX], b[MAX], trace[MAX][4];
stack<char> s;
int n;

int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
    //freopen("out.txt", "w", stdout);
#endif
    while(~scanf("%d %s %s", &n, &a, &b))
    {
        //清空栈s
        while(!s.empty())s.pop();
        for(int i=0, j=0, k=0; i<n;)
        {
            if(a[i]==b[j])
            {
                i++;
                j++;
                strcpy(trace[k++], "in");
                strcpy(trace[k++], "out");
                while(!s.empty() && s.top() == b[j])
                {
                    strcpy(trace[k++], "out");
                    s.pop();
                    j++;
                }
            }
            else
            {
                s.push(a[i++]);
                strcpy(trace[k++], "in");
            }
        }
        if(s.empty())
        {
            printf("Yes.\n");
            for(int i=0; i<n*2; i++)
            {
                puts(trace[i]);
            }
        }
        else
        {
            printf("No.\n");
        }
        printf("FINISH\n");
    }

#ifdef TEST
    fclose(stdin);
    //fclose(stdout);
#endif // TEST
    return 0;
}

```