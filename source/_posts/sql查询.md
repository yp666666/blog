---
title: sql查询
date: 2016-06-19 12:17:30
category:
tags: sql
---

[Group By 和 Having, Where ,Order by语句的执行顺序：](http://tangwenchao86.iteye.com/blog/1107795)
Where> Group By> Having> Order by。首先where将最原始记录中不满足条件的记录删除(所以应该在where语句中尽量的将不符合条件的记录筛选掉，这样可以减少分组的次数)，然后通过Group By关键字后面指定的分组条件将筛选得到的视图进行分组，接着系统根据Having关键字后面指定的筛选条件，将分组视图后不满足条件的记录筛选掉，然后按照Order By语句对视图进行排序，这样最终的结果就产生了。在这四个关键字中，只有在Order By语句中才可以使用最终视图的列名，如： 　　SELECT FruitName, ProductPlace, Price, ID AS IDE, Discount 　　FROM T_TEST_FRUITINFO 　　WHERE (ProductPlace = N'china') 　　ORDER BY IDE 　　这里只有在ORDER BY语句中才可以使用IDE，其他条件语句中如果需要引用列名则只能使用ID，而不能使用IDE。 


# 删除重复数据

> Person表

|id  |name  |
|---|:---:|
|1|a|
|2|b|
|3|a|

```mysql
SET SQL_SAFE_UPDATES=0; #防止safe模式下where未指定disdinct column不能执行delete语句
delete from Person where id not in (select minId from (select min(id) as minId FROM Person group by name) as T); #delete不允许表同时在select条件中,故as一个新表
```

# 列出各个部门中工资高于本部门的平均
# 工资的员工数和部门号，并按部门号排序
department表结构: id, employee_id, salary;

```
select count(ta.employee_id), ta.id from summery.department ta right join (select avg(tb.salary) as avgs, tb.id as tbid from summery.department tb group by tb.id) as tc on ta.id=tc.tbid and ta.salary > tc.avgs group by ta.id desc;
```
思路: 先找出部门号和平均工资,然后join相同部门号并且工资>平均值的行,group by id即可.


# 取每组的前N条数据
参考:<http://huanghualiang.blog.51cto.com/6782683/1252630>

分自连接和半连接:
```sql
自连接:select * from t2 a where 3>(select count(*) from t2 where gid=a.gid and col2>a.col2) order by a.gid,a.col2 desc;
半连接:select * from t2 a where exists(select count(*) from t2 b where b.gid=a.gid and a.col2<b.col2 having(count(*))<3) order by a.gid,a.col2 desc
```
**这两种方法刚开始没懂,后来看懂了,才发现真是碉堡了.值得玩味.**

> 原文中一处错误--->
*N=1时：
自连接：降序排好后group by取每组最大的一条。
select * from (select * from t2 order by col2 desc)as a group by gid order by gid;

group by 要将 select 之后全部的非聚合列都加进来,所以这条语句已经不能用了.

[左连接，右连接，全连接，内连接，交叉连接，自连接](https://www.cnblogs.com/eflylab/archive/2007/06/25/794278.html)
左连接就是以左表为准，右连接就是以右表为准。select * from tbla, tblb:这里的,就是笛卡尔积。


mysql面试题
学生表
create table student(
    id int primary key auto_increment,
    group_id int,
    name nvarchar(250),
    score numeric(4, 1)
);
兴趣小组表
create table study_group(
    id int primary key auto_increment,
    name nvarchar(250)
);
student
sutdentId groupId sutdentName score
1 1 Tom1 65
2 2 Tom2 60
3 3 Tom3 70
4 2 Tom4 80
5 1 Tom5 75
6 3 Tom6 85
7 3 Tom7 78
8 1 Tom8 97
9 2 Tom9 88
10 4 Aaa1 88
11 4 Aaa2 56
12 5 Aaa3 76
13 5 Aaa4 77
14 2 Aaa5 90
15 4 Ddd3 45
16 5 Ddd2 78
17 3 Ddd1 90
18 1 Eee3 0
19 3 Ggg1 0
20 4 Ttt1 0
21 2 Rrr2 0
Study_group
groupId groupName
1 音乐小组
2 绘画小组
3 体育小组
4 养生小组
5 环卫小组
6 没有参加小组

可存在txt中导入mysql
 导入命令：
 mysql> load data infile '/home/lujing/student.txt' into table student
    -> fields terminated by' '
    -> lines terminated by'\n' (windows中换行为\r\n)

1、用一条sql查询出个小组成绩最优秀的学生，需要查询出小组名称，学生名称，成绩

```mysql
select tc.name,ta.name,ta.score from summery.student ta join summery.study_group tc on ta.group_id=tc.id where (ta.score, ta.group_id) in (select max(tb.score) as mxs, tb.group_id as gid from summery.student tb group by tb.group_id);
```
思路:先找每组的最高分,然后(ta.score, ta.group_id)匹配.
优化:要对student的group_id加索引.

​2、将所有没有参加的小组的学生的活动成绩更新为-1

update summery.student set score=-1 where group_id=6;

3、用一条sql语句查出所有学生参加兴趣小组的情况，需要查出学生名称，小组名称，如果学生没有参加小组，则小组名称返回“没有参加小组”

select ta.name, tb.name from summery.student ta join summery.study_group tb on ta.group_id=tb.id;


# union 和 union all 的区别
这俩个没怎么用过,http://www.5idev.com/p-mysql_union.shtml

# 选出20~40,40~80,80~100分数的学生人数
case when 条件 then 行名 else 行名 end as 列名
```sql
SELECT case when score > 70 then '>70' else '≤70' end as '范围', count(score) as '人数' FROM summery.student 
group by case when score>70 then '>70' else '≤70' end;
```

# 之前没想出来的sql
一个用户有多个保单，每个保单有一个机构号，保单有日期。
找出每个用户保单最多的那个机构，如果保单数目相同就取最近保单的那个机构。

```sql
CREATE TABLE TRY
(
  user_id    INTEGER,
  stock_code INTEGER,
  bank_id    INTEGER,
  ts         TIMESTAMP(0)
)
```
插入数据[data](/blog/2016/06/19/sql%E6%9F%A5%E8%AF%A2/data.sql.txt)
解决方案
```sql
SELECT *
  FROM (SELECT USER_ID, BANK_ID, COUNT(STOCK_CODE) CNT, MAX(TS) TS
          FROM TRY
         GROUP BY USER_ID, BANK_ID) A
 WHERE NOT EXISTS
 (SELECT 1
          FROM (SELECT USER_ID, BANK_ID, COUNT(STOCK_CODE) CNT, MAX(TS) TS
                  FROM TRY
                 GROUP BY USER_ID, BANK_ID) B
         WHERE A.USER_ID = B.USER_ID
           AND A.BANK_ID != B.BANK_ID
           AND (A.CNT < B.CNT OR (A.CNT = B.CNT AND A.TS < B.TS)))
```