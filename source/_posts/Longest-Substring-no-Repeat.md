---
title: Longest Substring no Repeat
date: 2018-04-01 10:46:40
category:
tags: LeetCode
---
> 没有所谓的水题，只有解题的思想够不够先进。

Given a string, find the length of the longest substring without repeating characters.

Examples:
Given "abcabcbb", the answer is "abc", which the length is 3.
Given "bbbbb", the answer is "b", with the length of 1.
Given "pwwkew", the answer is "wke", with the length of 3. Note that the answer must be a substring, "pwke" is a subsequence and not a substring.

需要做两项工作：
1. 查字符是否与当前连续子串重复；
2. 计算当前子串长度；

用一个 HashMap<char, int> 来保存 <字符, 字符所在位置下标>，用 maxlen 来保存最长不重复子串长度，用 i 保存当前子串起始坐标，遍历字符串数组：
1. 根据 Integer loc = map.get(char), loc == null || loc < i 来判断是否重复;
2. 当重复时，子串长度不可能增加；当不重复时，更新最大长度 maxlen = max(maxlen, j-i+1);

[Longest Substring Without Repeating Characters](https://leetcode.com/problems/longest-substring-without-repeating-characters/description/)
`AC code`
```java
class Solution {
    public int lengthOfLongestSubstring(String s) {
        HashMap<Character, Integer> map = new HashMap<>();
        char[] chars = s.toCharArray();
        int maxlen = 0;
        int i = 0;
        for (int j = 0; j < chars.length; j++) {
            Integer k = map.get(chars[j]);
            if (k == null || k < i) {
                maxlen = Math.max(maxlen, j - i + 1);
            } else {
                i = k + 1;
            }
            map.put(chars[j], j);
        }
        return maxlen;
    }
}
```
