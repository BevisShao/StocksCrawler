SQL的4种连接查询
内连接
inner join 或者 join

外连接
1.左连接 left join 或者left outer join
2.优连接 right join 或者 right outer join
3.完全外连接 full join 或者 full outer join

创建两个表
-- person 表
id,
name,
cardID
create table person(
    id int,
    name varchar(20),
    cardID int
);
-- card 表
id,
name
create table card(
    id int,
    name varchar (20)
);
insert into card values (1, '饭卡');
insert into card values (2, '建行卡');
insert into card values (3, '农行卡');
insert into card values (4, '工商卡');
insert into card values (5, '邮政卡');

insert into person values (1, '张三', 1);
insert into person values (2, '李四', 3);
insert into person values (3, '王五', 6);

mysql> select * from person;
+------+--------+--------+
| id   | name   | cardID |
+------+--------+--------+
|    1 | 张三   |      1 |
|    2 | 李四   |      3 |
|    3 | 王五   |      6 |
+------+--------+--------+
3 rows in set (0.01 sec)

mysql> select * from card;
+------+-----------+
| id   | name      |
+------+-----------+
|    1 | 饭卡      |
|    2 | 建行卡    |
|    3 | 农行卡    |
|    4 | 工商卡    |
|    5 | 邮政卡    |
+------+-----------+

-- 并没有创建外键，
-- 1.inner join 查询(内连接)
select * from person inner join card on person.cardID=card.id;
+------+--------+--------+------+-----------+
| id   | name   | cardID | id   | name      |
+------+--------+--------+------+-----------+
|    1 | 张三   |      1 |    1 | 饭卡      |
|    2 | 李四   |      3 |    3 | 农行卡    |
+------+--------+--------+------+-----------+
2 rows in set (0.01 sec)
-- 内联查询，其实就是两张表种的数据，通过某个字段相连，查询出相关记录数据。
select * from person join  card on person.cardID=card.id;

--2.left join(左外连接)
select * from person left join card on person.cardID=card.id;
+------+--------+--------+------+-----------+
| id   | name   | cardID | id   | name      |
+------+--------+--------+------+-----------+
|    1 | 张三   |      1 |    1 | 饭卡      |
|    2 | 李四   |      3 |    3 | 农行卡    |
|    3 | 王五   |      6 | NULL | NULL      |
+------+--------+--------+------+-----------+
3 rows in set (0.00 sec)
-- 左外连接，会把左边表里的所有数据取出来，而右边表中的数据，如果有相等的，就显示出来
-- 如果没有，就会补 NULL

-- 3.right join（右外连接）
select * from person right join card on person.cardID=card.id;
+------+--------+--------+------+-----------+
| id   | name   | cardID | id   | name      |
+------+--------+--------+------+-----------+
|    1 | 张三   |      1 |    1 | 饭卡      |
|    2 | 李四   |      3 |    3 | 农行卡    |
| NULL | NULL   |   NULL |    2 | 建行卡    |
| NULL | NULL   |   NULL |    4 | 工商卡    |
| NULL | NULL   |   NULL |    5 | 邮政卡    |
+------+--------+--------+------+-----------+
5 rows in set (0.00 sec)
-- 右外连接，会把右边表里的所有数据取出来，而左边表中的数据，如果有相等的，就显示出来
-- 如果没有，就会补 NULL
select * from person right outer join card on person.cardID=card.id;

-- 4. full join(全外连接)
mysql>select from person full join card on person.cardID=card.id;
ERROR 1054 (42S22): Unknown column 'person.cardID' in 'on clause'
-- mysql 不支持full join
select * from person left join card on person.cardID=card.id
union
select * from person right join card on person.cardID=card.id;
+------+--------+--------+------+-----------+
| id   | name   | cardID | id   | name      |
+------+--------+--------+------+-----------+
|    1 | 张三   |      1 |    1 | 饭卡      |
|    2 | 李四   |      3 |    3 | 农行卡    |
|    3 | 王五   |      6 | NULL | NULL      |
| NULL | NULL   |   NULL |    2 | 建行卡    |
| NULL | NULL   |   NULL |    4 | 工商卡    |
| NULL | NULL   |   NULL |    5 | 邮政卡    |
+------+--------+--------+------+-----------+
6 rows in set (0.00 sec)
