---
title: Safecracker
date: 2016-06-30 02:39:42
category: hdu
tags: 
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1015)
Problem Description
=== Op tech briefing, 2002/11/02 06:42 CST === 
"The item is locked in a Klein safe behind a painting in the second-floor library. Klein safes are extremely rare; most of them, along with Klein and his factory, were destroyed in World War II. Fortunately old Brumbaugh from research knew Klein's secrets and wrote them down before he died. A Klein safe has two distinguishing features: a combination lock that uses letters instead of numbers, and an engraved quotation on the door. A Klein quotation always contains between five and twelve distinct uppercase letters, usually at the beginning of sentences, and mentions one or more numbers. Five of the uppercase letters form the combination that opens the safe. By combining the digits from all the numbers in the appropriate way you get a numeric target. (The details of constructing the target number are classified.) To find the combination you must select five letters v, w, x, y, and z that satisfy the following equation, where each letter is replaced by its ordinal position in the alphabet (A=1, B=2, ..., Z=26). The combination is then vwxyz. If there is more than one solution then the combination is the one that is lexicographically greatest, i.e., the one that would appear last in a dictionary." 

v - w^2 + x^3 - y^4 + z^5 = target 

"For example, given target 1 and letter set ABCDEFGHIJKL, one possible solution is FIECB, since 6 - 9^2 + 5^3 - 3^4 + 2^5 = 1. There are actually several solutions in this case, and the combination turns out to be LKEBA. Klein thought it was safe to encode the combination within the engraving, because it could take months of effort to try all the possibilities even if you knew the secret. But of course computers didn't exist then." 

=== Op tech directive, computer division, 2002/11/02 12:30 CST === 

"Develop a program to find Klein combinations in preparation for field deployment. Use standard test methodology as per departmental regulations. Input consists of one or more lines containing a positive integer target less than twelve million, a space, then at least five and at most twelve distinct uppercase letters. The last line will contain a target of zero and the letters END; this signals the end of the input. For each line output the Klein combination, break ties with lexicographic order, or 'no solution' if there is no correct combination. Use the exact format shown below."
 

Sample Input
1 ABCDEFGHIJKL
11700519 ZAYEXIWOVU
3072997 SOUGHT
1234567 THEQUICKFROG
0 END
 

Sample Output
LKEBA
YOXUZ
GHOST
no solution

找保险箱密码,给定整数target和大写字符串, 求满足等式v - w^2 + x^3 - y^4 + z^5 = target的5个字符,其中A=1, B=2, ..., Z=26.若结果有多个,只打印字典序最大的那个(LKEBA大于FIECB).
<hr/>

1. 将字符串降序排列.
2. 枚举5个字符,带入等式.

这里从N个数中取M个进行枚举.
用到了memcpy截取前5个字符.也可用strncpy(ans, A, 5);

这里的swap形式的枚举得到的并不是严格按照字典序排列的,之所以这样写会AC完全是因为有公式的限制,实属巧合而已.

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<vector>
#include<cmath>
#include<cstdlib>
#define MAX 12
#define TEST

using namespace std;

bool open;
char a[MAX], ans[5];
int len, tar;

bool cmp(char x, char y)
{
    return x > y;
}

bool equ(char *A)
{
    return tar == (A[0]-64 - pow(A[1]-64, 2) + pow(A[2]-64, 3) - pow(A[3]-64, 4) + pow(A[4]-64, 5));
}

void fun(char *A, int idx)
{
    if(idx > 5) return;
    if(open) return;
    if(idx == 5)
    {
        if(equ(A))
        {
            open = true;
            memcpy(ans, A, sizeof(char)*5);
        }
        return;
    }
    for(int i=0; i<len; i++)
    {
        swap(A[idx], A[i]);
        fun(A, idx+1);
        swap(A[idx], A[i]);
    }
}

int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
    //freopen("out.txt", "w", stdout);
#endif

    while(scanf("%d %s", &tar, &a), tar!=0 || 0!=strcmp(a, "END"))
    {
        len = strlen(a);
        open = false;
        sort(a, a+len, cmp);
        fun(a, 0);
        if(open)
        {
            printf("%s\n", ans);
        }
        else
        {
            printf("no solution\n");
        }
    }

#ifdef TEST
    fclose(stdin);
    //fclose(stdout);
#endif // TEST
    return 0;
}

```