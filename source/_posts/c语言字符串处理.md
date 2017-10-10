---
title: c语言字符串处理
date: 2016-06-21 01:38:39
category: hdu
tags: 字符串处理
---
[题目链接](http://acm.hdu.edu.cn/game/entry/problem/show.php?chapterid=1&sectionid=2&problemid=14)
**The Seven Percent Solution**

Problem Description
Uniform Resource Identifiers (or URIs) are strings like http://icpc.baylor.edu/icpc/, mailto:foo@bar.org, ftp://127.0.0.1/pub/linux, or even just readme.txt that are used to identify a resource, usually on the Internet or a local computer. Certain characters are reserved within URIs, and if a reserved character is part of an identifier then it must be percent-encoded by replacing it with a percent sign followed by two hexadecimal digits representing the ASCII code of the character. A table of seven reserved characters and their encodings is shown below. Your job is to write a program that can percent-encode a string of characters.

Character  Encoding
" " (space)  %20
"!" (exclamation point)  %21
"$" (dollar sign)  %24
"%" (percent sign)  %25
"(" (left parenthesis)  %28
")" (right parenthesis)  %29
"*" (asterisk)  %2a
 

Input
The input consists of one or more strings, each 1–79 characters long and on a line by itself, followed by a line containing only "#" that signals the end of the input. The character "#" is used only as an end-of-input marker and will not appear anywhere else in the input. A string may contain spaces, but not at the beginning or end of the string, and there will never be two or more consecutive spaces.
 

Output
For each input string, replace every occurrence of a reserved character in the table above by its percent-encoding, exactly as shown, and output the resulting string on a line by itself. Note that the percent-encoding for an asterisk is %2a (with a lowercase "a") rather than %2A (with an uppercase "A").
 

Sample Input
Happy Joy Joy!
http://icpc.baylor.edu/icpc/
plain_vanilla
(**)
?
the 7% solution
#
 

Sample Output
Happy%20Joy%20Joy%21
http://icpc.baylor.edu/icpc/
plain_vanilla
%28%2a%2a%29
?
the%207%25%20solution

题目大意就是将字符串中某些特殊字符用另一些字符串替换.
<hr/>

> **scanf**的高级用法, 可以加[]做过滤条件;
> **char[]**数组中字符串以**'\0'**结尾;
> **单个char转char[],末尾加'\0'**;
> **memset**初始化数组,比特全0或全1;

```c
#include<cstdio>
#include<iostream>
#include<cstring>
#include<algorithm>

using namespace std;

int main()
{
    char a[240],b[240], c[2]={' ','\0'};
    int slen;
    while(true)
    {
        scanf("%[^\n]", &a);
        getchar();
        if(a[0]=='#')break;
        memset(b, 0,sizeof(b));
        slen = strlen(a);
        for(int i=0, j=0; i<slen; i++)
        {
            switch(a[i])
            {
            case ' ':
                strcat(b, "%20");
                break;
            case '!':
                strcat(b, "%21");
                break;
            case '$':
                strcat(b, "%24");
                break;
            case '%':
                strcat(b, "%25");
                break;
            case '(':
                strcat(b, "%28");
                break;
            case ')':
                strcat(b, "%29");
                break;
            case '*':
                strcat(b, "%2a");
                break;
            default:
                c[0] = a[i];
                strcat(b, c);
            }
        }
        printf("%s\n", b);
    }

    return 0;
}

```