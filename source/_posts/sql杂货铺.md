---
title: sql杂货铺
date: 2017-09-17 12:06:51
category:
tags: oracle
---
> select \* from A left join B on ...以A为主表
select \* from A right join B on ...以B为主表

### oracle
#### 左、右连接
```sql
select * from student s, class c where s.cid = c.id(+);
select * from student s left join class c on s.cid=c.id;

select * from student s, class c where s.cid(+) = c.id;
select * from student s right join class c on s.cid = c.id;

select * from student s, class c where s.cid(+) = c.id and s.age < 20;
select * from student s right join class c on s.cid = c.id where s.age < 20;

select * from student s, class c where s.cid(+) = c.id and s.age(+) < 20;
select * from student s right join class c on s.cid = c.id and s.age < 20;
```
其中
```sql
select * from student s, class c where s.cid(+) = c.id and s.age < 20;
```
与
```sql
select * from student s, class c where s.cid(+) = c.id and s.age(+) < 20;
```
的区别在于前者先按age<20扫描student表，然后`内连接`class表。后者扫描class表，按条件与student表`右连接`。