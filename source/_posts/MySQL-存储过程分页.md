---
title: MySQL 存储过程分页
date: 2018-09-23 17:19:40
category:
tags: MySQL
---
[https://www.w3resource.com/mysql/mysql-procedure.php](https://www.w3resource.com/mysql/mysql-procedure.php)
[https://dev.mysql.com/doc/refman/8.0/en/string-functions.html#function_substr](https://dev.mysql.com/doc/refman/8.0/en/string-functions.html#function_substr)
[]()

`MySQL version: 5.7.9`

```sql

drop procedure if exists pagination;
create procedure pagination(in i_query varchar(8000), in i_page int, in i_size int, out o_total int)
  begin
    set @limit_start = (i_page - 1) * i_size;
    set @limit_size = i_size;
    set @tmp_query = concat('select * from (', i_query, ') t limit ?, ?');

    set @tmp_total = 0;
    set @tmp_stat = concat('select count(1) into @tmp_total from (', i_query, ') t ');

    prepare stmt_query from @tmp_query;
    execute stmt_query using @limit_start, @limit_size;

    prepare stmt_count from @tmp_stat;
    execute stmt_count;
    set o_total = @tmp_total;
  end;
```

参照之前写的 Oracle 版的分页，思路是一样的；比较坑的是从括号里传的变量前面不加@，在拼接SQL的时候需要另外定义变量才能使用 select count(1) into 。

`show VARIABLES like '%max_allowed_packet%';` SQL长度限制，单位 byte.


```java
public class Test {
    public static void main(String[] args) throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection connect = DriverManager
                .getConnection("jdbc:mysql://localhost:3306/mydb?"
                        + "user=root&password=password");
        int total = 0;
        CallableStatement callableStatement = connect.prepareCall("{call pagination(?,?,?,?)}");
        callableStatement.setString(1, "select * from tbl_user order by id desc");
        callableStatement.setInt(2, 1);
        callableStatement.setInt(3, 6);
        callableStatement.registerOutParameter(4, MysqlType.INT);
        ResultSet resultSet = callableStatement.executeQuery();
        total = callableStatement.getInt(4);
        System.out.println("total = " + total);
        while (resultSet.next()) {
            System.out.println(resultSet.getInt("id") + ", " + resultSet.getString("name"));
        }
        connect.close();
    }
}
```