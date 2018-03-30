---
title: 单源最短路径Dijkstra+PriorityQueue优化
date: 2018-03-30 23:04:17
category: 数据结构
tags:
---
无向图中，权值>=0，找出从节点s到t的最短距离：
令d[i]为从s到i的最短距离，则从s到i的最短路径不会再变更，以后再更新d，d[i]也不会改变，那么与i相邻的其它节点的最短距离也就随之确定：
d[j] = min(d[j], d[i] + (从i到j的权值))，j = 1，2，3....
更新完与i相邻的节点j后，d[j]也就固定下来了，再从d[j]中选取一个 **距离最小的 && 还未固定下来** 的节点，直到所有节点的距离都固定下来为止。
这就是Dijkstra算法。
```java
while(true){
	int u = -1;
	for( int i from 0 to N-1){
		if(!visited[i] && (u == -1 || d[i] < d[u])) u = i;
	}
	if(u == -1)break;
	visited[u] = true;
	for( int i from 0 to N-1){
		d[i] = min(d[i], d[u] + weight[u][i]);
	}
}
```
一共有N次循环，N为节点个数，每次循环的代价是 2\*N，所以Dijkstra的时间复杂度为O(N^2).

使用优先队列对其进行优化，将待固定节点i和d[i]封装成元素E(i, d[i])放入队列中，以d[i]升序排列，则每次取队首的代价是O(lgM)，M为边数，队列中最多有M个元素，总代价成了O(NlgM)。
这是使用邻接矩阵的优化时间复杂度，如果边数M比N小，换成邻接表，那么取出队首元素后遍历该元素的边，边数最多为M，那么时间复杂度就是O(MlgM)。

如果是稀疏图，就用邻接表，否则就用邻接矩阵。

[hdu1874](http://acm.hdu.edu.cn/showproblem.php?pid=1874)
`AC code`
```java
import java.io.*;
import java.util.PriorityQueue;

/**
 * @author hero
 */
public class Main implements Runnable {

    public void solve() {
        int MAX_DIST = 1 << 24;
        int N, M;
        while ((N = nextInt()) != -1) {
            M = nextInt();
            int[][] weight = new int[N][N];  //cost
            int[] dist = new int[N];  //distance
            boolean[] visited = new boolean[N];
            for (int i = 0; i < N; i++) {
                dist[i] = MAX_DIST;
                visited[i] = false;
                for (int j = 0; j <= i; j++)
                    weight[i][j] = weight[j][i] = MAX_DIST;
            }
            for (int i = 0; i < M; i++) {
                int u = nextInt(), v = nextInt(), w = nextInt();
                if (w < weight[u][v])
                    weight[u][v] = weight[v][u] = w;
            }
            int start = nextInt(), end = nextInt();
            dist[start] = 0;
            PriorityQueue<Edge> que = new PriorityQueue<>();
            que.add(new Edge(start, 0));
            while (!que.isEmpty()) {
                Edge e = que.poll();
                if (!visited[e.v]) {
                    visited[e.v] = true;
                    for (int i = 0; i < N; i++) {
                        if (!visited[i]) {
                            int w = dist[e.v] + weight[e.v][i];
                            if (w < dist[i]) {
                                dist[i] = w;
                                que.add(new Edge(i, dist[i]));
                            }
                        }
                    }
                }
            }
            if (dist[end] < MAX_DIST) {
                out.println(dist[end]);
            } else {
                out.println(-1);
            }
        }

    }

    static class Edge implements Comparable<Edge> {
        int v, w;

        public Edge(int v, int w) {
            this.v = v;
            this.w = w;
        }

        @Override
        public int compareTo(Edge o) {
            return this.w - o.w;
        }
    }

    public static void main(String[] args) {
        new Main().run();
    }

    @Override
    public void run() {
        init();
        solve();
        out.flush();
    }

    StreamTokenizer in;
    PrintWriter out;

    public void init() {
        in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        out = new PrintWriter(new OutputStreamWriter(System.out));
    }


    public int nextInt() {
        try {
            if (in.nextToken() == StreamTokenizer.TT_EOF) return -1;
            else return (int) in.nval;
        } catch (IOException e) {
            throw new Error(e);
        }
    }
}

```
java 读到文件末 in.nextToken() == StreamTokenizer.TT_EOF 只能这样判断，如果没有判断，返回的 in.nval 并不是-1，所以程序不会停止。