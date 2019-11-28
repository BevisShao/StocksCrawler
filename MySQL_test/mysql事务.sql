-- mysql 事务
mysql中,事务其实是一个最小的不可分割的工作单元,事务能够保证一个业务的完整性,
比如我们的银行转账,
a -> -100
update user set money=money-100 where name='a';
b -> +100
update user set money=money+100 where name='b';
--实际程序中，如果只有一条语句执行成功了，而另一条没有执行成功：
--出现数据前后不一致。
update user set money=money-100 where name='a';
update user set money=money+100 where name='b';
-- 多条sql语句， 可能会有同时成功的要求，要么就同时失败。

-- mysql 中如何控制事务？
1.mysql 默认是开启事务的(自动提交).
mysql> select @@autocommit;
+--------------+
| @@autocommit |
+--------------+
|            1 |
+--------------+
1 row in set (0.00 sec)
-- 默认事务开启的作用是什么？
--当我们去执行一个sql语句的时候，效果会立即体现出来，且不能回滚。
create database bank;
create table user(
  id  int primary key ,
  name varchar (20),
  money int
);
insert into user values (1, 'a', 1000);
insert into user values (2, 'b', 1000);
-- 设置sql的自动提交为false
mysql> set autocommit=0;
Query OK, 0 rows affected (0.00 sec)

mysql> insert into user values (2, 'b', 1000);
Query OK, 1 row affected (0.00 sec)

mysql> select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
2 rows in set (0.00 sec)
-- 回滚操作
mysql> rollback;
Query OK, 0 rows affected (0.02 sec)

mysql> select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
+----+------+-------+
1 row in set (0.00 sec)

mysql> insert into user values (2, 'b', 1000);  临时表
Query OK, 1 row affected (0.00 sec)
-- 手动提交后不可以rollback（持久性）
mysql> commit;
Query OK, 0 rows affected (0.03 sec)

mysql> rollback;
Query OK, 0 rows affected (0.00 sec)

mysql> select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
2 rows in set (0.00 sec)
-- 自动提交？ @@autocommit=1
-- 手动提交？ commit;
-- 事务回滚？ rollback;
-- 如果说这个时候转装：
update user set money=money-100 where name='a';
update user set money=money+100 where name='b';

mysql> select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |   900 |
|  2 | b    |  1100 |
+----+------+-------+
2 rows in set (0.00 sec)

mysql> rollback;
Query OK, 0 rows affected (0.08 sec)

mysql> select * from user;
+----+------+-------+
| id | name | money |
+----+------+-------+
|  1 | a    |  1000 |
|  2 | b    |  1000 |
+----+------+-------+
2 rows in set (0.00 sec)
-- 事务给我们提供一个返回的机会。

set autocommit=1;
-- 开启事务1
begin;
update user set money=money-100 where name='a';
update user set money=money+100 where name='b';   可以回滚
- 开启事务2
start transaction ;
update user set money=money-100 where name='a';
update user set money=money+100 where name='b';   可以回滚

commit;  提交事务后不可以回滚

事务的4大特征:
A 原子性: 事务时最小的单位,不可以再分割.
B 一致性: 事务要求,同一事务中的sql语句,必须保证同时成功或者同时失败.
I 隔离性: 事务1 和事务2 之间是具有隔离性的.
D 持久性: 事务一旦结束(commit, rollback ) ,就不可以返回.

事务开启:
    1.修改默认提交 set autocommit=0;
    2. begin;
    3. start transaction ;
事务手动提交:
    commit;
事务手动回滚:
    rollback ;


-- 事务的隔离性：
 1. read uncommitted ;  读未提交的         脏读
 2. read committed ;    读可以提交的      不可重复读现象
 3. repeatable read ;   可以重复读         幻读
 4. serializable ;       串行化            卡住

1-read uncommitted
如果有事务a,和事务b,
a 事务对数据进行操作,在操作的过程中,事务并没有被提交,但是b可以看到a的操作结果.
bank 数据库user表
insert into user values (3, '小明', 1000);
insert into user values (4, '淘宝店', 1000);
mysql> select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
+----+-----------+-------+
4 rows in set (0.00 sec)

-- 如何查看数据库的隔离级别？
mysql 8.0:
系统级别
select @@global.transaction_isolation;
会话级别
select @@transaction_isolation
mysql> select @@global.transaction_isolation;
+--------------------------------+    mysql 默认隔离级别
| @@global.transaction_isolation |
+--------------------------------+
| REPEATABLE-READ                |
+--------------------------------+
1 row in set (0.00 sec)

mysql 5.x:
select @@global.tx_isolation;
select @@tx_isolation;

-- 如何修改隔离级别？
set global transaction isolation level read uncommitted ;

-- 转账：小明在淘宝店买鞋子：800块钱，
    小明 -> 成都 ATM
    淘宝店 -> 广州 ATM
begin ;
update user set money=money-800 where name='小明';
update user set money=money+800 where name='淘宝店';
-- 发货
rollback ;
-- 晚上请女朋友吃饭
-- 1800
-- 结账的时候发现钱不够

-- 如果两个不同的地方，都在进行操作，如果事务a开启后，他的数据就可以被其他事务读到。
-- 这样就会出现（脏读）
-- 脏读： 一个事务读到了另外一个事务没有提交的数据，就会叫做脏读。
-- 实际开发是不允许脏读实现的。

2-read committed  读已经提交的
set global transaction isolation level read committed ;
select @@global.transaction_isolation;
小张:银行的会计
start transaction ;
select * from user;
+----+-----------+-------+
| id | name      | money |
+----+-----------+-------+
|  1 | a         |   900 |
|  2 | b         |  1100 |
|  3 | 小明      |  1000 |
|  4 | 淘宝店    |  1000 |
+----+-----------+-------+
4 rows in set (0.00 sec)
小张去抽根烟...

小王:
start transaction ;
insert into user values (5, 'c', 100);
commit;
小张:
mysql> select avg(money) from user;
+------------+  对于小张，获得的结果应该是1000，820是因为c用户的影响。也就是说小王的操作影响到了小张。
| avg(money) |
+------------+
|  820.0000 |
+------------+
1 row in set (0.01 sec)
-- 虽然我只能读到另一个事务提交的数据，但还是会出现问题，就是
-- 读取同一个表的数据，发现前后不一致。
-- 不可重复读现象： read committed;
-- 同一事务中，同一张表前后读取不一致。

3-repeatable read ;   可以重复读
set global  transaction isolation level repeatable read ;
select @@global.transaction_isolation;
-- 张全蛋-成都
start transaction ;


-- 王尼玛-北京
start transaction ;

-- 张全蛋-成都
insert  into user values (6, 'd', 1000);
commit;
-- 王尼玛--背景
insert  into user values (6, 'd', 1000);
ERROR 1062 (23000): Duplicate entry '6' for key 'PRIMARY'
-- 这种现象叫做幻读；
-- 事务a和事务b 同时操作一张表，事务a提交的数据，也不能被事务b读到，就可以造成幻读。

4-serializable 串行化
set global  transaction isolation level serializable ;
select @@global.transaction_isolation;
两个或者两个以上的终端访问同一个数据库会阻塞等待...

