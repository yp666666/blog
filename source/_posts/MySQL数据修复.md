---
title: MySQL数据修复
date: 2018-04-27 22:43:44
category:
tags: MySQL
---
> A、B数据库使用otter实时同步，但是有数据不一致情况，需要做数据修复。
> 因为没有找到合适的工具，所以自己写了些脚本来做处理，配合人工检查和过滤，99.9%的数据得以修复。


## 思路： 
1. 以A、B中的同一张表t举例，首先拿到 A.t 和 B.t 的INSERT语句，提取ID相同的不同数据；
2. 拼接update语句：
   a. ID为奇数，取A.t中的数据；
   b. ID为偶数，取B.t中的数据；
3. 在A、B中执行此update即可。   

具体实现与思路不一致，下面是具体实现。

## 第一步，找不同
1. 取表名；
2. 导出每张表，提取数据，每行一条；
3. 比较出两个库不同的部分；
统计结果在stat.txt中，只包含ID相同value不同的情况。

```sh
#!/bin/bash
## 统计不同数据的表，分析

. /Users/hero/.zshrc

#1.取表名
echo "step 1 : 取表名"
echo `mysql -uroot -ppasswd -hlocalhost << EOF
use shanghai;
SELECT table_name FROM information_schema.tables where table_schema='shanghai' and table_name like 'nh%' and table_name not like '%_reference';

EOF` > tables.txt
sed -E -e 's/\t/ /g' -e 's/ +/\n/g' tables.txt | tail -n +2 > alltables
rm tables.txt

for i in `cat alltables`;do
  echo $i
done

#2.提取diff
echo 'step 2 : 提取diff'
#from
url_from=localhost
user_from=root
password_from=passwd
schema_from=shanghai
#to
url_to=localhost
user_to=root
password_to=passwd
schema_to=hongkong

rm -rf from
mkdir from
rm -rf to
mkdir to
rm -rf diff
mkdir diff

for i in `cat alltables`; do
  echo "`date '+%H:%M:%S'` compare table ---> "$i"\n"
  mysqldump -h$url_from -u$user_from -p$password_from --single-transaction $schema_from $i -r from/${i}
  mysqldump -h$url_to -u$user_to -p$password_to --single-transaction $schema_to $i -r to/${i}
  grep "^INSERT" from/${i} | sed -e 's/INSERT.*VALUES //g' -e 's/),/)\n/g' -e 's/);/)\n/g' > from/${i}.ok
  grep "^INSERT" to/${i} | sed -e 's/INSERT.*VALUES //g' -e 's/),/)\n/g' -e 's/);/)\n/g' > to/${i}.ok
  diff from/${i}.ok to/${i}.ok > diff/$i
done
find diff/ -empty -delete

#3.统计
echo '统计'
FILE=stat.txt
TMP=stat.txt.tmp
>$FILE
>$TMP
for i in `ls diff/`; do
  sh=`grep '^<' diff/$i | wc -l`
  ho=`grep '^>' diff/$i | wc -l`
  echo $i $sh $ho >> $TMP
done
sort -n -k 2 $TMP > $FILE
rm $TMP
echo '统计结果：stat.txt'

mv stat.txt stat.txt.old
cp stat.txt.old stat.txt.`date +%Y%m%d%H%M%S`

awk -F '[ ]' '{if($2==$3)printf("%s\n", $0)}' stat.txt.old >> stat.txt

```

## 第二步，根据ID奇偶取数
在取ID的时候有一个假设，即每个表的ID都是第一个字段。
这样有个问题，ID不在第一个的表无法拿到它的ID；不过问题不大，因为我会对batch.sql做筛选。
```sh
#!/bin/bash
## 根据id奇偶性获取不同数据表的insert语句
LOG=log
>$LOG
exec 1>>$LOG 2>&1

rm -rf extr
mkdir extr
for i in `ls diff/`; do
  grep '^>' diff/$i > extr/$i
done
find extr/ -empty -delete

rm -rf ids
mkdir ids
for i in `ls extr/`; do
  awk -F '[(,]' '{printf("%s\n", $2)}' extr/$i > ids/${i}.tmp
  cat ids/${i}.tmp | grep -v '^$' | sort | uniq > ids/$i
  rm ids/${i}.tmp
done

# 奇数 上海
>batch.sql
SHANG=shanghai
HONG=hongkong
rm -rf jiou
mkdir jiou
for i in `ls ids/`; do
  while read id; do
    echo "$id $i"
    if (( (( $id % 2 )) == 0 )); then
     schema=$HONG
    else
     schema=$SHANG
    fi
    echo "mysqldump -hlocalhost -uroot -ppasswd --single-transactione2 $schema $i --where=\"id=$id\" >> jiou/$i" >> batch.sql
  done < ids/$i
done


echo 'get batch.sql'
rm -rf jiou
mkdir jiou
 
echo '有问题的表：'
grep -arl "NULL" ids/
grep '^NULL' $LOG
echo '根据log筛选batch.sql, 然后执行 sh batch.sql'

```
**一定要记得根据log对batch.sql做筛除，然后执行batch.sql，这样就拿到了根据ID的奇偶性获取的元数据**

## 第三步，insert、update、remove_tmp脚本
对元数据处理，拿到insert语句。创建临时表xxx_tmp将数据插入临时表中，然后根据临时表来更新A(B)，最后删除临时表。
```sh
#!/bin/bash
# 整理表结构

rm -rf insert
mkdir insert

for i in `ls jiou/`; do
  grep -aoE 'INSERT .*);' jiou/$i > insert/$i
done


rm -rf struct
mkdir struct

for i in `ls insert/`; do
echo `mysql -uroot -ppasswd -hlocalhost <<-EOF
select column_name from information_schema.columns where table_schema='hongkong' and table_name='$i'

EOF` > struct/$i
gsed -e 's/ /\n/g' struct/$i | tail -n +3 > struct/${i}.ok
done


>update.sql
>insert.sql
>remove_tmp.sql
for i in `ls insert/`; do
 echo "create table ${i}_tmp as select * from $i where 1!=1;" >> insert.sql
 echo "drop table ${i}_tmp;" >> remove_tmp.sql
 gsed -i "s/${i}/${i}_tmp/g" insert/$i
 cat insert/$i >> insert.sql
 printf %s "update $i a, ${i}_tmp b set " >> update.sql
 awk '{printf("a.%s=b.%s,", $1, $1)}' struct/${i}.ok >> update.sql
 echo " where a.id=b.id;" >> update.sql
done
gsed -i 's/, where/ where/g' update.sql

echo '执行insert.sql-->update.sql--->remove_tmp.sql'

echo "mysql -uroot -ppasswd --binary-mode=1 < insert.sql"

```

## 验证
新建一个子目录，然后执行第一个脚本，拿到stat.txt验证数据修复结果。
