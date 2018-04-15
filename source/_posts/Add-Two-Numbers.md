---
title: Add Two Numbers
date: 2018-04-01 01:25:04
category:
tags: LeetCode
---
> 水题系列

You are given two non-empty linked lists representing two non-negative integers. The digits are stored in reverse order and each of their nodes contain a single digit. Add the two numbers and return it as a linked list.

You may assume the two numbers do not contain any leading zero, except the number 0 itself.

Example
```
Input: (2 -> 4 -> 3) + (5 -> 6 -> 4)
Output: 7 -> 0 -> 8
Explanation: 342 + 465 = 807.
```

两个 list 相加，考虑进位即可。

[add-two-numbers](https://leetcode.com/problems/add-two-numbers/description/)
`AC code`
```java
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
            public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        if (l1 == null) return l2;
        if (l2 == null) return l1;

        int upper = 0;
        ListNode list = new ListNode(l1.val + l2.val), t = list;
        if (list.val > 9) {
            list.val -= 10;
            upper = 1;
        }
        l1 = l1.next;
        l2 = l2.next;
        while (l1 != null && l2 != null) {
            int val = l1.val + l2.val + upper;
            if (val > 9) {
                upper = 1;
                val -= 10;
            } else {
                upper = 0;
            }
            ListNode next = new ListNode(val);
            t.next = next;
            t = next;
            l1 = l1.next;
            l2 = l2.next;
        }
        l1 = l1 == null ? l2 : l1;
        while (l1 != null) {
            l1.val += upper;
            if (l1.val > 9) {
                upper = 1;
                l1.val -= 10;
            } else {
                upper = 0;
            }
            t.next = l1;
            t = l1;
            l1 = l1.next;
        }
        if (upper > 0) {
            t.next = new ListNode(1);
        }
        return list;
    }
}
```