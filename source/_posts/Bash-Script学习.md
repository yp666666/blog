---
title: Bash Script学习
date: 2017-05-09 22:58:50
category:
tags: shell
---
>不看[TLCL](http://linuxcommand.org/index.php),学会shell script也惘然！

#### 重定向
```
0 标准输入
1 标准输出
2 错误

2>err.log 
>&2 错误输入到/var/log/auth.log

ls * > mylog 2>&1 或 ls * &>mylog

2>/dev/null 不处理 

> 清空再写入
>> 追加到行末
```

#### 正则表达式
基础表达式
`^ $ . [ ] *`
扩展表达式
`( ) { } ? + |`
```
grep -E 
```


[tutorial网站](http://ryanstutorials.net/bash-scripting-tutorial/bash-if-statements.php)

#### if statement
```sh
if [ <some test> ]
then
<commands>
fi
```

Operator |	Description
--------|-----------------
! EXPRESSION |	The EXPRESSION is false.
-n STRING |	The length of STRING is greater than zero.
-z STRING |	The lengh of STRING is zero (ie it is empty).
STRING1 = STRING2	| STRING1 is equal to STRING2
STRING1 != STRING2	| STRING1 is not equal to STRING2
INTEGER1 -eq INTEGER2 |	INTEGER1 is numerically equal to INTEGER2
INTEGER1 -gt INTEGER2 |	INTEGER1 is numerically greater than INTEGER2
INTEGER1 -lt INTEGER2 |	INTEGER1 is numerically less than INTEGER2
-d FILE | FILE exists and is a directory.
-e FILE	| FILE exists.
-r FILE	| FILE exists and the read permission is granted.
-s FILE	| FILE exists and it's size is greater than zero (ie. it is not empty).
-w FILE	| FILE exists and the write permission is granted.
-x FILE	| FILE exists and the execute permission is granted.


#### 追踪
全部
```
#！/bin/bash -x

```
部分
```
#！/bin/bash

set -x    # turn on tracing

set +x    # turn off tracing

```

#### 数据提取
文件f1
1 a
2 b
3 c
文件f2
3
2
```
#!/bin/bash
cnt=$(grep -c "" f2)
echo $cnt
while ((cnt > 0))
do
  read key
  res=$(grep $key f1 | cut -c 3-3)
  echo $res | tee -a res.log
  cnt=$((cnt-1))
done < f2
```

#### 学以致用: 一个统计加班时长的脚本
统计每个人每月的加班情况
要求：加班结束时间必须大于等于19：30, 加班时长=（加班结束时间-18:30）/8, 保留2位小数，小数位不进位。

加班记录的文档：record
```
张三            2016/5/1 19:30
李四  2017/5/1 20:30
jack    2016/6/1  21:29
张三            2016/3/1 15:30
李四  2017/9/1 22:10
jack    2015/2/1  21:29
张三            2016/5/10 23:30
李四  2017/5/12 21:00
```
每一列分别代表：姓名、日期、下班时间，中间既可以是n空格，也可以是n个tab，或者二者的组合。

处理脚本：cal_work.sh
```sh
#!/bin/bash

# read me
echo -e "输入文件格式必须满足：\n\
user	2016/4/1 17:33\n" ## 大致格式是这样，只要有空格或tab隔开就行

log="work.log"  ## 日志记录

file=$1

# 备份之前结果
if [[ -e result_day ]]; then
  bak_time=`date +%Y%m%d%H%M%S`
  mv result_day result_day.bak.${bak_time}
  mv result_month result_month.bak.${bak_time}
  echo "`date "+%F %T"` back result_day result_month" >> $log
fi

echo "展示格式化之后的文档:" 
awk -F '[/:\t" "]' '{gsub("\t", " ");gsub(" +", " ")} {print NR, $1, $2, $3, $4, $5, $6, NF}' $file | head -n5

echo -e "\n`date "+%F %T"` start process file : $file" | tee -a $log
awk -F '[/:\t" "]' '{gsub("\t", " ");gsub(" +", " ")} {total=0;hour=$5-19;minute=$6-30; if(minute<0) {minute=30;hour-=1;} else {minute=0;}; if(hour>=0 && minute>=0) {total=hour*60+minute+60;}} {if(total>0) {total=total/480;total=substr(total, 1, index(total, ".")+2);print NR, $1, $2, $3, $4, hour, minute, total}}' $file > result_temp1

# 提取user year day到文档temp2
awk '{print $2, $3, $4}' result_temp1 | sort -u > result_temp2

while read line
  do
    ## awk 正则匹配 变量：外面''，里面""
    ## awk printf 变量：外面"",中间'',里面""
    awk 'BEGIN {total=0;} {if($0~/'"$line"'/) {total=total+$8;}} END {printf("%s %.2f\n", "'"$line"'", total)}' result_temp1 >> result_temp3
done < result_temp2

# human readable format
awk '{printf("%s %d/%d/%d %.2f\n", $2, $3, $4, $5, $8)}' result_temp1 > result_day
awk '{printf("%s %d/%d %.2f\n", $1, $2, $3, $4)}' result_temp3 > result_month

rm -f result_temp1 result_temp2 result_temp3
echo -e "`date "+%F %T"` process done : result_day result_month" | tee -a $log
```

统计结果:
jack 2015 2 0.31
jack 2016 6 0.31
张三 2016 5 0.74
李四 2017 5 0.56
李四 2017 9 0.43
注：每人每个月加班时长，单位(天)

#### 随即字符串和数字
生成不大于120的正整数
```sh
expr `cat /dev/urandom | od -An -N1 -tu1` % 120 
```
生成长度最小为3的字符串
```sh
cat /dev/urandom | sed 's/[^a-zA-Z]//g' | strings -n3 | head -n1
```