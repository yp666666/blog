---
title: Ignatius and the Princess II
date: 2016-07-03 02:58:25
category: hdu
tags: 排列
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1027)
Problem Description
Now our hero finds the door to the BEelzebub feng5166. He opens the door and finds feng5166 is about to kill our pretty Princess. But now the BEelzebub has to beat our hero first. feng5166 says, "I have three question for you, if you can work them out, I will release the Princess, or you will be my dinner, too." Ignatius says confidently, "OK, at last, I will save the Princess."

"Now I will show you the first problem." feng5166 says, "Given a sequence of number 1 to N, we define that 1,2,3...N-1,N is the smallest sequence among all the sequence which can be composed with number 1 to N(each number can be and should be use only once in this problem). So it's easy to see the second smallest sequence is 1,2,3...N,N-1. Now I will give you two numbers, N and M. You should tell me the Mth smallest sequence which is composed with number 1 to N. It's easy, isn't is? Hahahahaha......"
Can you help Ignatius to solve this problem?
 

Input
The input contains several test cases. Each test case consists of two numbers, N and M(1<=N<=1000, 1<=M<=10000). You may assume that there is always a sequence satisfied the BEelzebub's demand. The input is terminated by the end of file.
 

Output
For each test case, you only have to output the sequence satisfied the BEelzebub's demand. When output a sequence, you should print a space between two numbers, but do not output any spaces after the last number.
 

Sample Input
6 4
11 8
 

Sample Output
1 2 3 5 6 4
1 2 3 4 5 6 7 9 8 11 10

数列[1,2,...,n],按照从小到大排列,求第m个排列.如:n=3, m=6:
123
132
213
231
312
321
所以第6个排列是321.
<hr/>
没有所谓的"水题",这道题可以用next_premutation函数或康拓逆展开来做,但我用的是双向链表.只有用数据结构+算法的方式才是真的ACMER,不求甚解无法成为大牛.

我刚开始用的是之前写过的permutation方式,一直以为它就是按从小到大的排列来排的,结果发现完全不是.例如123时,3和1交换后是321,然后会先打印出321,再打印312.由于之前没有好好理解所以这次浪费了很多时间.
从这个基础上稍微改改就可以变成是按 smallest sequence排列了,因为原数列已经是从小到大排列好的,所以可以把交换变成插入.这样原交换点的左右就都是从小到大排序的了.

双向链表也没有理想中的那么好写,尤其是当你认为所有逻辑都正确但始终报错的时候.要排查NULL指针异常.

附上我可能以后再也不会看的代码.相信我下次写会很轻松.
第二份代码是更加优美的,因为m<=10000,所以只需要交换a[N]的后8项就可以.

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
#define MAX 1002
#define INF 1<<20
#define TEST

using namespace std;

int N, n, M, m;
bool finish;

typedef struct node
{
    int value;
    node *pre, *next;  //前驱和后继
} Node;

Node mylist[MAX];

void permu(Node *here)
{
    if(finish)return;
    Node *p, *q, *r;
    int v;
    //如果当前指针为空,说明已产生一个新的排列
    if(here == NULL)
    {
        m++;
        if(m == M)
        {
            finish = true;
            p = mylist[0].next;
            while(p->next != NULL)
            {
                printf("%d ", p->value);
                p = p->next;
            }
            printf("%d\n", p->value);
        }
        return;
    }
    //从当前节点开始,其后每个节点都与它交换一次位置
    //由于排列需要按大小顺序,所以后面的应该直接插入到当前位置
    r = here;
    while(r)
    {
        if(r!=here)
        {
            p = r->pre;
            q=r->next;
            r->pre->next=r->next;
            //后继q有可能为NULL
            if(q != NULL)q->pre=r->pre;
            here->pre->next=r;
            r->pre=here->pre;
            r->next=here;
            here->pre=r;
            permu(r->next);
            r->pre->next=r->next;
            r->next->pre=r->pre;
            p->next=r;
            r->pre=p;
            if(q != NULL)q->pre=r;
            r->next = q;
        }
        else
        {
            permu(r->next);
        }
        r = r->next;
    }
}

int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
#endif

    while(scanf("%d %d", &N, &M) != EOF)
    {
        //mylist[0][0]充当list的头节点
        mylist[0].next=&mylist[1];
        mylist[0].pre=NULL;
        for(int i=1; i<N; i++)
        {
            mylist[i].value = i;
            mylist[i].pre = &mylist[i-1];
            mylist[i].next = &mylist[i+1];
        }
        mylist[N].pre=&mylist[N-1];
        mylist[N].next=NULL;
        mylist[N].value=N;
        finish = false;
        m = 0;
        permu(mylist[0].next);
    }
#ifdef TEST
    fclose(stdin);
#endif // TEST
    return 0;
}

```

这种方式不必使用双向链表,而且简洁优美.
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
#define MAX 1002
#define INF 1<<20
#define TEST

using namespace std;

int a[MAX], N, n, M, m, start;
bool visited[MAX], finish;

void permu(int idx)
{
    if(finish)return;
    if(idx == N+1)
    {
        m++;
        if(m == M)
        {
            finish = true;
            for(int i=1; i<N; i++)
            {
                printf("%d ", a[i]);
            }
            printf("%d\n", a[N]);
        }
        return;
    }
    for(int i=start; i<=N; i++)
    {
        if(!visited[i])
        {
            visited[i] = true;
            a[idx] = i;
            permu(idx + 1);
            visited[i] = false;
        }
    }
}

int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
#endif

    while(scanf("%d %d", &N, &M) != EOF)
    {
        memset(visited, 0, sizeof(visited));
        for(int i=1; i<=N; i++)a[i]=i;
        finish = false;
        m = 0;
        if(N<9)
        {
            start = 1;
            permu(1);
        }
        else
        {
            start = N-7;
            permu(start);
        }
    }
#ifdef TEST
    fclose(stdin);
#endif // TEST
    return 0;
}

```