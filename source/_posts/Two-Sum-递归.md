---
title: Two Sum(递归)
date: 2018-04-01 00:03:25
category:
tags: 递归
---
HDU可能是人太多，服务器撑不住总是挂，故转战 LeetCode。
LeetCode 可以看到测试数据，方便debug，这一点真是太赞了。
这道题我提交了13次，花了。。。3 个小时？哈哈，醉了，弱爆了。看来以后有空可以多刷刷题。


Given an array of integers, return indices of the two numbers such that they add up to a specific target.
You may assume that each input would have exactly one solution, and you may not use the same element twice.

Example:
```
Given nums = [2, 7, 11, 15], target = 9,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].
```

有且只有两个数的和 = target
那么树的深度最多2层，虽然是暴力搜索，这道题不暴力还真不行，这么小的深度再加上剪枝肯定没问题。
花了那么久，到后面才想起来用一个flag来做剪枝。

[LeetCode](https://leetcode.com/problems/two-sum/description/)
`AC code`
```java
class Solution {
    int[] tmp = new int[2];
    int[] res = new int[2];
    boolean finished = false;  // 剪枝

    public int sum(int[] nums, int i, int j) {
        return nums[i] + nums[j];
    }

    public void solve(int[] nums, int i, int target, int[] tmp, int j) {
        if (finished) return;
        if (j == 2) {
            if (sum(nums, tmp[0], tmp[1]) == target) {
                finished = true;
                System.arraycopy(tmp, 0, res, 0, 2);
            }
            return;
        }
        if (i == nums.length) return;
        solve(nums, i + 1, target, tmp, j);
        tmp[j] = i;
        solve(nums, i + 1, target, tmp, j + 1);
    }

    public int[] twoSum(int[] nums, int target) {
        solve(nums, 0, target, tmp, 0);
        for (int i = 0; i < res.length; i++) System.out.println(res[i]);
        return res;
    }
}
```
