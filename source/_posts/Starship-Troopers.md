---
title: Starship Troopers
date: 2016-06-29 21:34:07
category: hdu
tags: 树形DP
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1011)
Problem Description
You, the leader of Starship Troopers, are sent to destroy a base of the bugs. The base is built underground. It is actually a huge cavern, which consists of many rooms connected with tunnels. Each room is occupied by some bugs, and their brains hide in some of the rooms. Scientists have just developed a new weapon and want to experiment it on some brains. Your task is to destroy the whole base, and capture as many brains as possible.

To kill all the bugs is always easier than to capture their brains. A map is drawn for you, with all the rooms marked by the amount of bugs inside, and the possibility of containing a brain. The cavern's structure is like a tree in such a way that there is one unique path leading to each room from the entrance. To finish the battle as soon as possible, you do not want to wait for the troopers to clear a room before advancing to the next one, instead you have to leave some troopers at each room passed to fight all the bugs inside. The troopers never re-enter a room where they have visited before.

A starship trooper can fight against 20 bugs. Since you do not have enough troopers, you can only take some of the rooms and let the nerve gas do the rest of the job. At the mean time, you should maximize the possibility of capturing a brain. To simplify the problem, just maximize the sum of all the possibilities of containing brains for the taken rooms. Making such a plan is a difficult job. You need the help of a computer.
 

Input
The input contains several test cases. The first line of each test case contains two integers N (0 < N <= 100) and M (0 <= M <= 100), which are the number of rooms in the cavern and the number of starship troopers you have, respectively. The following N lines give the description of the rooms. Each line contains two non-negative integers -- the amount of bugs inside and the possibility of containing a brain, respectively. The next N - 1 lines give the description of tunnels. Each tunnel is described by two integers, which are the indices of the two rooms it connects. Rooms are numbered from 1 and room 1 is the entrance to the cavern.

The last test case is followed by two -1's.
 

Output
For each test case, print on a single line the maximum sum of all the possibilities of containing brains for the taken rooms.
 

Sample Input
5 10
50 10
40 10
40 20
65 30
70 30
1 2
1 3
2 4
2 5
1 1
20 7
-1 -1
 

Sample Output
50
7

有一个山洞,里面有N个房间,每个房间有一些bugs和brains,房间之间互通,入口是1号房.有M人想得到brains,1个人可以消灭20个bugs.问最多可获取多少brains.
<hr/>

树形DP分两类,最常见的是从叶向根递推求解.
设<b>dp[i][j]</b>为向节点i投入j个人可获得的brains个数.则dp的状态转移式为:
<b>dp[i][k] = max(dp[i][k], dp[i][m-k]+dp[v][k])</b>,其中v是与i相连的子节点.
max()中第二项的dp[i][m-k]可看成是第i个节点与除v之外的子节点所能获取的最大值.
为保证经计算的dp不被混乱累计,m应该从M开始递减,因为这个状态转换式不是严格正确的,加上目标是求dp[1][M], 所以m从M开始,从而规避了那些冗余的统计.给个例子吧:
2 7
60 10
40 20
1 2
你可以自己手动模拟一下就明白了.
不理解也没关系,先放一放,去A其它的题.

```c
#include<cstdio>
#include<cstring>
#include<algorithm>
#include<set>
#include<queue>
#include<vector>
#include<cmath>
#include<cstdlib>
#define MAX 102
//#define TEST

using namespace std;

int N, M;
int dp[MAX][MAX];    //dynamic programming matrix
bool visit[MAX];
vector<int> r[MAX];  //保存边的关系

typedef struct node
{
    int troopers, brains;
    void init(int bugs, int brain)
    {
        troopers = (bugs + 19) / 20; //一个trooper可以kill20个bug
        brains = brain;
    }
} Node;

Node room[MAX];

/**
* @name dp求解
* u为当前节点
*/
void fun(int u)
{
    //fill(dp[u]+room[u].troopers, dp[u]+M, room[u].brains);
    visit[u] = true;
    //如果是叶节点,并且troopers=0就需要去1个人取brains
    if(r[u].size() == 1 && room[u].troopers == 0 && u !=1 )room[u].troopers = 1;
    //初始化dp[u]
    for(int i = room[u].troopers; i <= M; i++)
    {
        dp[u][i] = room[u].brains;
    }
    //与u连接的点依次访问,以u为根,从叶节点向其做dp[][]统计
    for(int i = 0, v; i < r[u].size(); i++)
    {
        v = r[u][i];
        if(visit[v])continue;
        fun(v);
        //必须从M开始,递减,否则dp[][]是错误的
        //因为若j递增,u的同一子结点可能会被累加多次.
        for(int j = M; j >= room[u].troopers; j--)
        {
            for(int k = 1; j-k >= room[u].troopers; k++)
            {
                dp[u][j] = max(dp[u][j], dp[u][j-k] + dp[v][k]);
            }
        }
    }
}

void init()
{
    memset(dp, 0, sizeof(dp));
    memset(visit, 0, sizeof(visit));
    memset(room, 0, sizeof(room));
    for(int i = 0; i < MAX; i++)
    {
        r[i].clear();
    }
}

int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
    //freopen("out.txt", "w", stdout);
#endif
    int bug, bra;
    while(~scanf("%d %d", &N, &M), N!=-1 || M!=-1)
    {
        init();
        for(int i=1; i<=N; i++)
        {
            scanf("%d %d", &bug, &bra);
            room[i].init(bug, bra);
        }
        for(int i=1; i<N; i++)
        {
            scanf("%d %d", &bug, &bra);
            r[bug].push_back(bra);
            r[bra].push_back(bug);
        }
        if(M==0) //很重要, 因为dp[1][0]有可能大于1
        {
            puts("0");
            continue;
        }
        fun(1);
        printf("%d\n", dp[1][M]);
    }
#ifdef TEST
    fclose(stdin);
    //fclose(stdout);
#endif // TEST
    return 0;
}

```