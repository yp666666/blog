---
title: Median of Two Sorted Arrays
date: 2018-04-01 11:32:59
category:
tags: LeetCode
---

我相信这道题肯定不是让用这种方法，但是块拷贝的确比分析情况简单多了。

There are two sorted arrays nums1 and nums2 of size m and n respectively.

Find the median of the two sorted arrays. The overall run time complexity should be O(log (m+n)).

Example 1:
nums1 = [1, 3]
nums2 = [2]

The median is 2.0
Example 2:
nums1 = [1, 2]
nums2 = [3, 4]

The median is (2 + 3)/2 = 2.5

[median-of-two-sorted-arrays](https://leetcode.com/problems/median-of-two-sorted-arrays/description/)
`AC code`
```java
class Solution {
    public double findMedianSortedArrays(int[] nums1, int[] nums2) {
        int len = nums1.length + nums2.length, mid = len >> 1;
        int[] nums = new int[len];
        System.arraycopy(nums1, 0, nums, 0, nums1.length);
        System.arraycopy(nums2, 0, nums, nums1.length, nums2.length);
        Arrays.sort(nums);
        double res = nums[mid];
        
        if (len % 2 == 0) {
            res += nums[mid - 1];
            res /= 2;
        }
        return res;
    }
}
```
