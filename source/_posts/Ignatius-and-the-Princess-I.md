---
title: Ignatius and the Princess I
date: 2016-07-02 15:30:45
category: hdu
tags: BFS
---
[题目链接](http://acm.hdu.edu.cn/showproblem.php?pid=1026)
Problem Description
The Princess has been abducted by the BEelzebub feng5166, our hero Ignatius has to rescue our pretty Princess. Now he gets into feng5166's castle. The castle is a large labyrinth. To make the problem simply, we assume the labyrinth is a N*M two-dimensional array which left-top corner is (0,0) and right-bottom corner is (N-1,M-1). Ignatius enters at (0,0), and the door to feng5166's room is at (N-1,M-1), that is our target. There are some monsters in the castle, if Ignatius meet them, he has to kill them. Here is some rules:

1.Ignatius can only move in four directions(up, down, left, right), one step per second. A step is defined as follow: if current position is (x,y), after a step, Ignatius can only stand on (x-1,y), (x+1,y), (x,y-1) or (x,y+1).
2.The array is marked with some characters and numbers. We define them like this:
. : The place where Ignatius can walk on.
X : The place is a trap, Ignatius should not walk on it.
n : Here is a monster with n HP(1<=n<=9), if Ignatius walk on it, it takes him n seconds to kill the monster.

Your task is to give out the path which costs minimum seconds for Ignatius to reach target position. You may assume that the start position and the target position will never be a trap, and there will never be a monster at the start position.
 

Input
The input contains several test cases. Each test case starts with a line contains two numbers N and M(2<=N<=100,2<=M<=100) which indicate the size of the labyrinth. Then a N*M two-dimensional array follows, which describe the whole labyrinth. The input is terminated by the end of file. More details in the Sample Input.
 

Output
For each test case, you should output "God please help our poor hero." if Ignatius can't reach the target position, or you should output "It takes n seconds to reach the target position, let me show you the way."(n is the minimum seconds), and tell our hero the whole path. Output a line contains "FINISH" after each test case. If there are more than one path, any one is OK in this problem. More details in the Sample Output.
 

Sample Input
5 6
.XX.1.
..X.2.
2...X.
...XX.
XXXXX.
5 6
.XX.1.
..X.2.
2...X.
...XX.
XXXXX1
5 6
.XX...
..XX1.
2...X.
...XX.
XXXXX.
 

Sample Output
It takes 13 seconds to reach the target position, let me show you the way.
1s:(0,0)->(1,0)
2s:(1,0)->(1,1)
3s:(1,1)->(2,1)
4s:(2,1)->(2,2)
5s:(2,2)->(2,3)
6s:(2,3)->(1,3)
7s:(1,3)->(1,4)
8s:FIGHT AT (1,4)
9s:FIGHT AT (1,4)
10s:(1,4)->(1,5)
11s:(1,5)->(2,5)
12s:(2,5)->(3,5)
13s:(3,5)->(4,5)
FINISH
It takes 14 seconds to reach the target position, let me show you the way.
1s:(0,0)->(1,0)
2s:(1,0)->(1,1)
3s:(1,1)->(2,1)
4s:(2,1)->(2,2)
5s:(2,2)->(2,3)
6s:(2,3)->(1,3)
7s:(1,3)->(1,4)
8s:FIGHT AT (1,4)
9s:FIGHT AT (1,4)
10s:(1,4)->(1,5)
11s:(1,5)->(2,5)
12s:(2,5)->(3,5)
13s:(3,5)->(4,5)
14s:FIGHT AT (4,5)
FINISH
God please help our poor hero.
FINISH

N*M的迷宫,找出一条从maze[0][0]到maze[N-1][M-1]的路.
'X'表示不通;'.'表示可走;'数字1-9'表示野怪.
maze[0][0]没有野怪, 途中遇到野怪必须消灭.
如果路径有多条,打印一条就可以.
<hr/>
此题有坑,并非任一路径都可以,必须是最短路.
说下感受,OJ并不给提供任何出错信息,这让想入门ACM的菜鸟,也就是我非常绝望.但是等我找出问题解决后我又有很大的成就感,"世上无难事"并非只是说说而已.

为什么是BFS(Breadth-First-Search)而不是DFS(Depth-First-Search),因为BFS是按照层级遍历,所以首先遍历到的是距离根节点最近的, 而DFS解决类似一个问题是否有解的问题.

我踩的坑.由于要输出路径,所以每个node节点有个指针指向父节点, 这个值在node入队列前设置.
刚开始我是将node出队列,然后visited置为true.这就会引发一个问题------node的指针可能会被更新多次,而最后一次会指向花费最大的那个父节点.
例矩阵:
.  2
3 4
<队列状态>(进入一格需1s, 从起点开始)
```c
<3, 4>  maze[0][[1].pre -->[0][0], [1][0] -->[0][0]
<4, 8> [1][1]-->[0][1]
<8, 9> [1][1]-->[1][0]
```
(x == N-1 && y == M-1) 条件满足,退出.(此时[1][1]的pre 指向的是 [1][0], 路径是错误的.)
正确的BFS应该是在node放入队列前将其visited置为true.

由指针求下标:
矩阵a[N][M], 有*p = &a[i][j], 则
i = (p - &a[0][0]) / M;
j = (p - &a[0][0]) % M;

历时1.5天,终于解决了.从time limit exceeded(用的DFS)到Stack over flow(STL的queue不够)到wrong answer(不是最短路径).一点一点摸索怎么节省内存,到底哪里溢出,终于都解决后看到的是wa.可想而知我的内心是崩溃的,题目明明说的任一路径都可以.刚开始我没有发现写的BFS有问题,也算是没有 白白浪费时间,毕竟搞清楚了是visited的问题.wrong到死的感觉,崩溃到几乎要怀疑人生.
然而当终于发现问题在哪并解决之后,才知道一切都是值得的.

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
#define MAX 101
#define INF 1<<20
#define TEST


using namespace std;

char labyrinth[MAX][MAX];
int N, M, sec;
bool finish;
int dx[4] = {1, 0, -1, 0}, dy[4] = {0, 1, 0, -1};

typedef struct node
{
    int step;  //到此节点时用的步数(or时间)
    node *pre;  //指向父节点
    void init(int s, node *p)
    {
        step = s;
        pre = p;
    }
    bool operator < (const node &x) const
    {
        return step > x.step; //在队列中按从小到大排列
    }
} Node;

struct cmp
{
    bool operator () (const Node *x, const Node *y)
    {
        return x->step >= y->step;
    }
};

Node maze[MAX][MAX];
bool visited[MAX][MAX];
priority_queue<Node*, vector<Node*>, cmp> pri;

void init()
{
    memset(visited, 0, sizeof(visited));
    //memset(maze, 0, sizeof(maze));
    //memset(labyrinth, 0, sizeof(labyrinth));
    finish = false;
    sec = 0;
    while(!pri.empty())pri.pop();
    for(int i = 0; i < N; i++)
    {
        scanf("%s", &labyrinth[i]);
    }
}

int monsters(int x, int y)
{
    if(labyrinth[x][y]>'0'&&labyrinth[x][y]<='9')
    {
        return labyrinth[x][y] - '0';
    }
    else return 0;
}


void bfs()
{
    visited[0][0] = true;
    pri.push(&maze[0][0]);
    Node *p;
    int px, py;
    while(!pri.empty())
    {
        p = pri.top();
        pri.pop();
        px = (p - &maze[0][0]) / MAX; //获取指针在矩阵中的下标
        py = (p - &maze[0][0]) % MAX;
        if(px == N-1 && py == M-1)
        {
            finish = true;
            return;
        }
        //visited[p.x][p.y] = true;  我在这里犯了一个错误
        int x, y;
        for(int i=0; i<4; i++)
        {
            x = px + dx[i];
            y = py + dy[i];
            if(x>-1&&x<N&&y>-1&&y<M && labyrinth[x][y]!='X' && !visited[x][y])
            {
                visited[x][y] = true;  //应该在放入队列前将其置为true,否则可能一个节点会被放入两次
                maze[x][y].init(p->step + monsters(x, y) + 1, &maze[px][py]);
                pri.push(&maze[x][y]);
            }
        }
    }
}

void showTrace(int x, int y)
{
    if(x!=0 || y!=0)
    {
        showTrace((maze[x][y].pre - &maze[0][0]) / MAX, (maze[x][y].pre - &maze[0][0]) % MAX);
        printf("%ds:(%d,%d)->(%d,%d)\n", ++sec, (maze[x][y].pre - &maze[0][0]) / MAX, (maze[x][y].pre - &maze[0][0]) % MAX, x, y);
        while(labyrinth[x][y]>'0' && labyrinth[x][y]<='9')
        {
            labyrinth[x][y]--;
            printf("%ds:FIGHT AT (%d,%d)\n", ++sec, x, y);
        }
    }
    else
    {
        printf("It takes %d seconds to reach the target position, let me show you the way.\n", maze[N-1][M-1].step);
    }
}

int main()
{
#ifdef TEST
    freopen("in.txt", "r", stdin);
    //freopen("out.txt", "w", stdout);
#endif

    while(scanf("%d %d", &N, &M)!=EOF)
    {
        init();
        bfs();
        if(!finish)
        {
            printf("God please help our poor hero.\n");
        }
        else
        {
            showTrace(N-1, M-1);
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