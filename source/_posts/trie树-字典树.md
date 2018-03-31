---
title: trie树(字典树)
date: 2018-03-31 14:24:04
category: 数据结构
tags:
---
字典树就是根据字母查单词，假设全都是小写字母，
根节点的 key = ' '，在第一层;
第二层最多26个节点，即 key = a 到 z;
第三层最多26^26个节点，以此类推，最底层的高度为最长单词的长度。

[hdu1004](http://acm.hdu.edu.cn/showproblem.php?pid=1004)
`AC code`
```java
import java.io.*;

/**
 * @author hero
 */
public class Main implements Runnable {

    public void solve() {
        int N;
        while ((N = nextInt()) != 0) {
            String result = null;
            int max = -1;
            Node root = new Node(' ');
            for (int i = 0; i < N; i++) {
                String balloon = nextString();
                Node t = put(root, balloon);
                if (t.count > max) {
                    max = t.count;
                    result = balloon;
                }
            }
            out.println(result);
        }
    }

    public Node put(Node root, String s) {
        return put(root, s.toCharArray(), 0);
    }

    private Node put(Node root, char[] chars, int i) {
        if (root.next[chars[i] - 'a'] == null) {
            root.next[chars[i] - 'a'] = new Node(chars[i]);
        }
        Node t = root.next[chars[i] - 'a'];
        if (i + 1 == chars.length) {
            t.count += 1;
            return t;
        } else {
            return put(t, chars, i + 1);
        }
    }

    static class Node {
        char key;
        int count;
        Node[] next;

        public Node(char key) {
            this.key = key;
            this.count = 0;
            this.next = new Node[26];  //26个小写字母
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
            in.nextToken();
            return (int) in.nval;
        } catch (IOException e) {
            throw new Error(e);
        }
    }

    public String nextString() {
        try {
            in.nextToken();
            return in.sval;
        } catch (IOException e) {
            throw new Error(e);
        }
    }
}

```

只是想尝试一下，没想到竟真的支持Lambda了！
```java
import java.io.*;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * @author hero
 */
public class Main implements Runnable {

    public void solve() {
        int N;
        while ((N = nextInt()) != 0) {
            Map<String, Integer> map = new LinkedHashMap<>();
            for (int i = 0; i < N; i++) {
                String balloon = nextString();
                map.replace(balloon, map.computeIfAbsent(balloon, e -> 0) + 1);
            }
            String result = map.entrySet().stream()
                    .max(Comparator.comparingInt(Map.Entry::getValue))
                    .get()
                    .getKey();
            out.println(result);
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
            in.nextToken();
            return (int) in.nval;
        } catch (IOException e) {
            throw new Error(e);
        }
    }

    public String nextString() {
        try {
            in.nextToken();
            return in.sval;
        } catch (IOException e) {
            throw new Error(e);
        }
    }
}

```