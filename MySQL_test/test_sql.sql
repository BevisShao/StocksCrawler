create table student(
    sno varchar(20) primary key ,
    sname varchar (20) not null ,
    ssex varchar (10) not null ,
    sbirthday date,
    class varchar (20)

);

create table teacher(
    tno varchar (20) primary key ,
    tname varchar (20) not null ,
    tsex varchar (10) not null ,
    tbirthday date ,
    prof varchar (20) not null,
    depart varchar (20) not null
);

create table course(
    cno varchar (20) primary key ,
    cname varchar (20) not null ,
    tno varchar (20) not null ,
    foreign key (tno) references teacher(tno)
);

create table score(
    sno varchar (20)  not null ,
    cno varchar (20) not null ,
    degree decimal ,
    foreign key (sno) references student (sno),
    foreign key (cno) references course(cno),
    primary key (sno, cno)
);
# 添加学生表
insert into student values ('101', '曾华', '男', '1977-09-01', '95033');
insert into student values ('102', '匡明', '男', '1975-10-02', '95031');
insert into student values ('103', '王丽', '女', '1976-01-23', '95033');
insert into student values ('104', '李军', '男', '1976-02-20', '95033');
insert into student values ('105', '王芳', '女', '1975-02-10', '95031');
insert into student values ('106', '陆君', '男', '1974-06-03', '95031');
insert into student values ('107', '王尼玛', '男', '1976-02-20', '95033');
insert into student values ('108', '张全蛋', '男', '1975-02-10', '95031');
insert into student values ('109', '赵铁柱', '男', '1974-06-03', '95031');

# 添加教师表
insert into teacher values ('804', '李诚', '男', '1958-12-02', '副教授', '计算机系');
insert into teacher values ('856', '张旭', '男', '1969-03-12', '讲师', '电子工程系');
insert into teacher values ('825', '王萍', '女', '1972-05-05', '助教', '计算机系');
insert into teacher values ('831', '刘冰', '女', '1977-08-14', '助教', '电子工程系');

# 添加课程表
insert into course values ('3-105', '计算机导论', '825');
insert into course values ('3-245', '操作系统', '804');
insert into course values ('6-166', '数字电路', '856');
insert into course values ('9-888', '高等数学', '831');

# 添加成绩表

insert into score values ('103', '3-105', '92');
insert into score values ('103', '3-245', '86');
insert into score values ('103', '6-166', '85');
insert into score values ('105', '3-105', '88');
insert into score values ('105', '3-245', '75');
insert into score values ('105', '6-166', '79');
insert into score values ('109', '3-105', '76');
insert into score values ('109', '3-245', '68');
insert into score values ('109', '6-166', '81');


-- 1.查询student表里的所有记录。
mysql> select * from student;
+-----+-----------+------+------------+-------+
| sno | sname     | ssex | sbirthday  | class |
+-----+-----------+------+------------+-------+
| 101 | 曾华      | 男   | 1977-09-01 | 95033 |
| 102 | 匡明      | 男   | 1975-10-02 | 95031 |
| 103 | 王丽      | 女   | 1976-01-23 | 95033 |
| 104 | 李军      | 男   | 1976-02-20 | 95033 |
| 105 | 王芳      | 女   | 1975-02-10 | 95031 |
| 106 | 陆君      | 男   | 1974-06-03 | 95031 |
| 107 | 王尼玛    | 男   | 1976-02-20 | 95033 |
| 108 | 张全蛋    | 男   | 1975-02-10 | 95031 |
| 109 | 赵铁柱    | 男   | 1974-06-03 | 95031 |
+-----+-----------+------+------------+-------+
9 rows in set (0.01 sec)

-- 2.查询student表里的素有记录的sname、ssex 和class列。
mysql> select sname,ssex,class from student;
+-----------+------+-------+
| sname     | ssex | class |
+-----------+------+-------+
| 曾华      | 男   | 95033 |
| 匡明      | 男   | 95031 |
| 王丽      | 女   | 95033 |
| 李军      | 男   | 95033 |
| 王芳      | 女   | 95031 |
| 陆君      | 男   | 95031 |
| 王尼玛    | 男   | 95033 |
| 张全蛋    | 男   | 95031 |
| 赵铁柱    | 男   | 95031 |
+-----------+------+-------+
9 rows in set (0.00 sec)

-- 3.查询教师所有的单位即不重复的depart列。
mysql> select distinct depart from teacher;
+-----------------+
| depart          |
+-----------------+
| 计算机系        |
| 电子工程系      |
+-----------------+
2 rows in set (0.01 sec)

-- 4.查询score表中成绩在60到80之间的所有记录。
mysql> select * from score where degree between 60 and 80;
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 105 | 3-245 |     75 |
| 105 | 6-166 |     79 |
| 109 | 3-105 |     76 |
| 109 | 3-245 |     68 |
+-----+-------+--------+
4 rows in set (0.01 sec)

-- 5.查询socre表中成绩为85，86或者88的记录。
mysql> select * from score where degree in (85, 86, 88);
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 3-245 |     86 |
| 103 | 6-166 |     85 |
| 105 | 3-105 |     88 |
+-----+-------+--------+
3 rows in set (0.00 sec)

-- 6.查询student表中‘95031’班或者性别为‘女’的同学记录。
mysql> select * from student where  class='95031' or ssex='女';
+-----+-----------+------+------------+-------+
| sno | sname     | ssex | sbirthday  | class |
+-----+-----------+------+------------+-------+
| 102 | 匡明      | 男   | 1975-10-02 | 95031 |
| 103 | 王丽      | 女   | 1976-01-23 | 95033 |
| 105 | 王芳      | 女   | 1975-02-10 | 95031 |
| 106 | 陆君      | 男   | 1974-06-03 | 95031 |
| 108 | 张全蛋    | 男   | 1975-02-10 | 95031 |
| 109 | 赵铁柱    | 男   | 1974-06-03 | 95031 |
+-----+-----------+------+------------+-------+
6 rows in set (0.00 sec)

-- 7.以class降序查询student表的所有记录。
mysql> select * from student order by class desc;
+-----+-----------+------+------------+-------+
| sno | sname     | ssex | sbirthday  | class |
+-----+-----------+------+------------+-------+
| 101 | 曾华      | 男   | 1977-09-01 | 95033 |
| 103 | 王丽      | 女   | 1976-01-23 | 95033 |
| 104 | 李军      | 男   | 1976-02-20 | 95033 |
| 107 | 王尼玛    | 男   | 1976-02-20 | 95033 |
| 102 | 匡明      | 男   | 1975-10-02 | 95031 |
| 105 | 王芳      | 女   | 1975-02-10 | 95031 |
| 106 | 陆君      | 男   | 1974-06-03 | 95031 |
| 108 | 张全蛋    | 男   | 1975-02-10 | 95031 |
| 109 | 赵铁柱    | 男   | 1974-06-03 | 95031 |
+-----+-----------+------+------------+-------+
9 rows in set (0.01 sec)

-- 8.以cno升序、degree降序查询socre表的所有记录。
mysql> select * from score order by cno asc , degree desc ;
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 3-105 |     92 |
| 105 | 3-105 |     88 |
| 109 | 3-105 |     76 |
| 103 | 3-245 |     86 |
| 105 | 3-245 |     75 |
| 109 | 3-245 |     68 |
| 103 | 6-166 |     85 |
| 109 | 6-166 |     81 |
| 105 | 6-166 |     79 |
+-----+-------+--------+
9 rows in set (0.00 sec)

-- 9.查询‘95031’班的学生人数。
mysql> select count(*) from student where class='95031';
+----------+
| count(*) |
+----------+
|        5 |
+----------+
1 row in set (0.01 sec)

-- 10.查询score表中的最高分的学生学号和课程号。（子查询或者排序）
mysql> select sno, cno from score where degree=(select max(degree) from score);
+-----+-------+
| sno | cno   |
+-----+-------+
| 103 | 3-105 |
+-----+-------+
1 row in set (0.00 sec)
-- 排序的做法：
-- limit 第一个数字表示从x开始，第二个数字表示查询x条；
mysql> select sno,cno,degree from score order by degree desc limit 0,1 ;
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 3-105 |     92 |
+-----+-------+--------+
1 row in set (0.00 sec)
--
-- 11.查询每门课的平均成绩。
mysql> select * from course;
+-------+-----------------+-----+
| cno   | cname           | tno |
+-------+-----------------+-----+
| 3-105 | 计算机导论      | 825 |
| 3-245 | 操作系统        | 804 |
| 6-166 | 数字电路        | 856 |
| 9-888 | 高等数学        | 831 |
+-------+-----------------+-----+
4 rows in set (0.01 sec)

mysql> select avg(degree) from score where  cno='3-105';
+-------------+
| avg(degree) |
+-------------+
|     85.3333 |
+-------------+
1 row in set (0.00 sec)
-- 分组查询group by
mysql> select cno, avg(degree)from score group by cno;
+-------+-------------+
| cno   | avg(degree) |
+-------+-------------+
| 3-105 |     85.3333 |
| 3-245 |     76.3333 |
| 6-166 |     81.6667 |
+-------+-------------+
3 rows in set (0.01 sec)

-- 12 查询score表中至少有2名学生选修的并以3开头的课程的平均分数。
-- group by 条件语句要用 having 而不用 where
mysql> select cno,avg(degree)from score group by cno having count(cno)>=2 and cno like '3%' ;
+-------+-------------+
| cno   | avg(degree) |
+-------+-------------+
| 3-105 |     85.3333 |
| 3-245 |     76.3333 |
+-------+-------------+
2 rows in set (0.00 sec)

-- 13 查询分数大鱼70，小于90的sno列
mysql> select sno,degree from score where degree>70 and degree<90;
+-----+--------+
| sno | degree |
+-----+--------+
| 103 |     86 |
| 103 |     85 |
| 105 |     88 |
| 105 |     75 |
| 105 |     79 |
| 109 |     76 |
| 109 |     81 |
+-----+--------+
7 rows in set (0.00 sec)

-- 14 查询所有学生的sname、con和degree列
-- 双表查询
mysql> select sname,cno,degree from student,score where student.sno=score.sno;
+-----------+-------+--------+
| sname     | cno   | degree |
+-----------+-------+--------+
| 王丽      | 3-105 |     92 |
| 王丽      | 3-245 |     86 |
| 王丽      | 6-166 |     85 |
| 王芳      | 3-105 |     88 |
| 王芳      | 3-245 |     75 |
| 王芳      | 6-166 |     79 |
| 赵铁柱    | 3-105 |     76 |
| 赵铁柱    | 3-245 |     68 |
| 赵铁柱    | 6-166 |     81 |
+-----------+-------+--------+
9 rows in set (0.00 sec)

-- 15 查询所有学生的sno、cname、和degree列。
mysql> select sno,cname,degree from course,score where course.cno=score.cno;
+-----+-----------------+--------+
| sno | cname           | degree |
+-----+-----------------+--------+
| 103 | 计算机导论      |     92 |
| 105 | 计算机导论      |     88 |
| 109 | 计算机导论      |     76 |
| 103 | 操作系统        |     86 |
| 105 | 操作系统        |     75 |
| 109 | 操作系统        |     68 |
| 103 | 数字电路        |     85 |
| 105 | 数字电路        |     79 |
| 109 | 数字电路        |     81 |
+-----+-----------------+--------+
9 rows in set (0.00 sec)

-- 16 查询所有学生的sname、cname和dgree列。
-- as 语句给字段取个别名
mysql> select sname,cname,degree,student.sno as stu_sno  from student,course,score where score.sno=student.sno and score.cno=course.cno;
+-----------+-----------------+--------+---------+
| sname     | cname           | degree | stu_sno |
+-----------+-----------------+--------+---------+
| 王丽      | 计算机导论      |     92 | 103     |
| 王丽      | 操作系统        |     86 | 103     |
| 王丽      | 数字电路        |     85 | 103     |
| 王芳      | 计算机导论      |     88 | 105     |
| 王芳      | 操作系统        |     75 | 105     |
| 王芳      | 数字电路        |     79 | 105     |
| 赵铁柱    | 计算机导论      |     76 | 109     |
| 赵铁柱    | 操作系统        |     68 | 109     |
| 赵铁柱    | 数字电路        |     81 | 109     |
+-----------+-----------------+--------+---------+
9 rows in set (0.00 sec)

-- 17 查询‘95031’班学生每门课的平均分。
select course.cno,course.cname,avg(degree) from score,student,course where student.class='95031' group by course.cno;
+-------+-----------------+-------------+   错误的结果
| cno   | cname           | avg(degree) |
+-------+-----------------+-------------+
| 3-105 | 计算机导论      |     81.1111 |
| 3-245 | 操作系统        |     81.1111 |
| 6-166 | 数字电路        |     81.1111 |
| 9-888 | 高等数学        |     81.1111 |
+-------+-----------------+-------------+
-- 应该分段分析：
select * from student where class='95031';   -- 先查出本班学生的所有学号sno，并在查询socre总表的时候作为条件
mysql> select score.cno,avg(degree) from score,course where sno in (select sno from student where class='95031') group by score.
cno;
+-------+-------------+   正确的结果，但是语法冗余
| cno   | avg(degree) |
+-------+-------------+
| 3-105 |     82.0000 |
| 3-245 |     71.5000 |
| 6-166 |     80.0000 |
+-------+-------------+
3 rows in set (0.00 sec)
mysql> select course.cno,avg(degree) from score,course where sno in (select sno from student where class='95031') group by cours
e.cno;
+-------+-------------+     错误的结果  这是字段错误导致的
| cno   | avg(degree) |
+-------+-------------+
| 3-245 |     77.8333 |
| 3-105 |     77.8333 |
| 9-888 |     77.8333 |
| 6-166 |     77.8333 |
+-------+-------------+
4 rows in set (0.00 sec)
-- select后面的字段一定要明确来自于哪个表，一旦是多个表，需要明确字段的表名以免混淆
select cno,avg(degree) from score where sno in (select sno from student where class='95031') group by cno;
+-------+-------------+   正确的结果，语法简练
| cno   | avg(degree) |
+-------+-------------+
| 3-105 |     82.0000 |
| 3-245 |     71.5000 |
| 6-166 |     80.0000 |
+-------+-------------+
3 rows in set (0.00 sec)

-- 18 查询选修‘3-105’课程的成绩高于‘109’号同学‘3-105’成绩的所有同学的记录。
select degree from score where sno='109'and cno='3-105';
mysql> select * from score where degree> (select degree from score where sno='109'and cno='3-105') and cno='3-105';
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 3-105 |     92 |
| 105 | 3-105 |     88 |
+-----+-------+--------+
2 rows in set (0.00 sec)

-- 19 查询成绩高于学号为‘109’、课程号为‘3-105’的成绩的所有记录。
select degree from score where sno='109' and cno='3-105';
mysql> select * from score where degree>(select degree from score where sno='109' and cno='3-105') ;
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 3-105 |     92 |
| 103 | 3-245 |     86 |
| 103 | 6-166 |     85 |
| 105 | 3-105 |     88 |
| 105 | 6-166 |     79 |
| 109 | 6-166 |     81 |
+-----+-------+--------+
6 rows in set (0.00 sec)

-- 20 查询和学号为108、101的同学同年出生的所有同学的sno、sname和sbirthday列。
select year(sbirthday) from student where sno in (108,101);
mysql> select sno,sname,sbirthday from student where year(sbirthday) in (select year(sbirthday) from student where sno in (108,1
01));
+-----+-----------+------------+   year()函数取出生日里的年份值
| sno | sname     | sbirthday  |
+-----+-----------+------------+
| 101 | 曾华      | 1977-09-01 |
| 102 | 匡明      | 1975-10-02 |
| 105 | 王芳      | 1975-02-10 |
| 108 | 张全蛋    | 1975-02-10 |
+-----+-----------+------------+
4 rows in set (0.00 sec)

-- 21 查询‘张旭’教师任课的学生成绩。
select tno from teacher where tname='张旭';
select cno from course where tno=(select tno from teacher where tname='张旭');
mysql> select * from score where cno=(select cno from course where tno=(select tno from teacher where tname='张旭'));
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 6-166 |     85 |
| 105 | 6-166 |     79 |
| 109 | 6-166 |     81 |
+-----+-------+--------+
3 rows in set (0.00 sec)

-- 22 查询选修某课程的同学多于5人的教师姓名。
insert into score values ('101', '3-105', '90');
insert into score values ('102', '3-105', '91');
insert into score values ('104', '3-105', '89');

select cno from score group by cno having count(*)> 5 ;
select tno from course where cno in (select cno from score group by cno having count(*)> 5);
mysql> select * from teacher where tno in(select tno from course where cno in (select cno from score group by cno having count(*)>
 5));
+-----+--------+------+------------+--------+--------------+
| tno | tname  | tsex | tbirthday  | prof   | depart       |
+-----+--------+------+------------+--------+--------------+
| 825 | 王萍   | 女   | 1972-05-05 | 助教   | 计算机系     |
+-----+--------+------+------------+--------+--------------+
1 row in set (0.00 sec)

-- 23 查询95033班和95031班全体同学的记录。
insert into student values ('110', '张飞', '男', '1974-06-03', '95038');

mysql> select * from student where class in ('95033', '95031');
+-----+-----------+------+------------+-------+
| sno | sname     | ssex | sbirthday  | class |
+-----+-----------+------+------------+-------+
| 101 | 曾华      | 男   | 1977-09-01 | 95033 |
| 102 | 匡明      | 男   | 1975-10-02 | 95031 |
| 103 | 王丽      | 女   | 1976-01-23 | 95033 |
| 104 | 李军      | 男   | 1976-02-20 | 95033 |
| 105 | 王芳      | 女   | 1975-02-10 | 95031 |
| 106 | 陆君      | 男   | 1974-06-03 | 95031 |
| 107 | 王尼玛    | 男   | 1976-02-20 | 95033 |
| 108 | 张全蛋    | 男   | 1975-02-10 | 95031 |
| 109 | 赵铁柱    | 男   | 1974-06-03 | 95031 |
+-----+-----------+------+------------+-------+
9 rows in set (0.00 sec)
mysql> select * from score,student where student.sno in (select student.sno from student where class in ('95033', '95031')) and
student.sno=score.sno;
+-----+-------+--------+-----+-----------+------+------------+-------+
| sno | cno   | degree | sno | sname     | ssex | sbirthday  | class |
+-----+-------+--------+-----+-----------+------+------------+-------+
| 101 | 3-105 |     90 | 101 | 曾华      | 男   | 1977-09-01 | 95033 |
| 102 | 3-105 |     91 | 102 | 匡明      | 男   | 1975-10-02 | 95031 |
| 103 | 3-105 |     92 | 103 | 王丽      | 女   | 1976-01-23 | 95033 |
| 103 | 3-245 |     86 | 103 | 王丽      | 女   | 1976-01-23 | 95033 |
| 103 | 6-166 |     85 | 103 | 王丽      | 女   | 1976-01-23 | 95033 |
| 104 | 3-105 |     89 | 104 | 李军      | 男   | 1976-02-20 | 95033 |
| 105 | 3-105 |     88 | 105 | 王芳      | 女   | 1975-02-10 | 95031 |
| 105 | 3-245 |     75 | 105 | 王芳      | 女   | 1975-02-10 | 95031 |
| 105 | 6-166 |     79 | 105 | 王芳      | 女   | 1975-02-10 | 95031 |
| 109 | 3-105 |     76 | 109 | 赵铁柱    | 男   | 1974-06-03 | 95031 |
| 109 | 3-245 |     68 | 109 | 赵铁柱    | 男   | 1974-06-03 | 95031 |
| 109 | 6-166 |     81 | 109 | 赵铁柱    | 男   | 1974-06-03 | 95031 |
+-----+-------+--------+-----+-----------+------+------------+-------+
12 rows in set (0.00 sec)

-- 24 查询存在有85分以上成绩的课程Con。
mysql> select distinct cno  from score where degree>85;
+-------+
| cno   |
+-------+
| 3-105 |
| 3-245 |
+-------+
2 rows in set (0.00 sec)

-- 25 查询出‘计算机系’教师所教课程的成绩表。
select tno from teacher where depart='计算机系';
select cno from course where tno in(select tno from teacher where depart='计算机系');
select * from score where cno in (select cno from course where tno in(select tno from teacher where depart='计算机系'));
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 3-245 |     86 |
| 105 | 3-245 |     75 |
| 109 | 3-245 |     68 |
| 101 | 3-105 |     90 |
| 102 | 3-105 |     91 |
| 103 | 3-105 |     92 |
| 104 | 3-105 |     89 |
| 105 | 3-105 |     88 |
| 109 | 3-105 |     76 |
+-----+-------+--------+

-- 26 查询‘计算机系’与‘电子工程系’不同职称的教师的tanme和prof
select * from teacher where depart in ('计算机系', '电子工程系');  -- 此语句不符题意，而题意本就模糊，知道此题是用来考察union和not in的用法就好。
select * from teacher where depart='计算机系' and prof not in (select prof from teacher where depart='电子工程系')
union
select * from teacher where depart='电子工程系' and prof not in (select prof from teacher where depart='计算机系');
+-----+--------+------+------------+-----------+-----------------+  其实就是取交集以外的并集。
| tno | tname  | tsex | tbirthday  | prof      | depart          |
+-----+--------+------+------------+-----------+-----------------+
| 804 | 李诚   | 男   | 1958-12-02 | 副教授    | 计算机系        |
| 856 | 张旭   | 男   | 1969-03-12 | 讲师      | 电子工程系      |
+-----+--------+------+------------+-----------+-----------------+
2 rows in set (0.00 sec)

-- 27 查询选修编号为‘3-105’课程且成绩至少高于选修编号为‘3-245’的同学的cno、sno、和degree，并按degree从高到低次序排序 。
select * from score where cno ='3-105' and degree>any(select degree from score where cno ='3-245')
order by degree desc ;
+-----+-------+--------+    any 至少一个
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 3-105 |     92 |
| 102 | 3-105 |     91 |
| 101 | 3-105 |     90 |
| 104 | 3-105 |     89 |
| 105 | 3-105 |     88 |
| 109 | 3-105 |     76 |
+-----+-------+--------+
6 rows in set (0.01 sec)

-- 28 查询选修编号为‘3-105’且成绩高于选修编号‘3-245’课程的同学的cno、sno、和degree。
select * from score where cno ='3-105' and degree>all(select degree from score where cno ='3-245')
order by degree desc ;
+-----+-------+--------+    all :且
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 3-105 |     92 |
| 102 | 3-105 |     91 |
| 101 | 3-105 |     90 |
| 104 | 3-105 |     89 |
| 105 | 3-105 |     88 |
+-----+-------+--------+
5 rows in set (0.00 sec)

-- 29 查询所有教师和同学的name、sex、和birthday。
select sname as name ,ssex as sex,sbirthday as birthday from student
union
select tname as name ,tsex as sex,tbirthday as birthday from teacher;   -- 第二段语句的as可以不用写，默认第一段语句的字段
+-----------+-----+------------+  as 取别名。
| name      | sex | birthday   |
+-----------+-----+------------+
| 曾华      | 男  | 1977-09-01 |
| 匡明      | 男  | 1975-10-02 |
| 王丽      | 女  | 1976-01-23 |
| 李军      | 男  | 1976-02-20 |
| 王芳      | 女  | 1975-02-10 |
| 陆君      | 男  | 1974-06-03 |
| 王尼玛    | 男  | 1976-02-20 |
| 张全蛋    | 男  | 1975-02-10 |
| 赵铁柱    | 男  | 1974-06-03 |
| 张飞      | 男  | 1974-06-03 |
| 李诚      | 男  | 1958-12-02 |
| 王萍      | 女  | 1972-05-05 |
| 刘冰      | 女  | 1977-08-14 |
| 张旭      | 男  | 1969-03-12 |
+-----------+-----+------------+
14 rows in set (0.00 sec)

-- 30 查询所有‘女’教师和‘女’同学的name、sex、和birthday。
select sname as name ,ssex as sex,sbirthday as birthday from student where ssex='女'
union
select tname as name ,tsex as sex,tbirthday as birthday from teacher where tsex='女';
+--------+-----+------------+
| name   | sex | birthday   |
+--------+-----+------------+
| 王丽   | 女  | 1976-01-23 |
| 王芳   | 女  | 1975-02-10 |
| 王萍   | 女  | 1972-05-05 |
| 刘冰   | 女  | 1977-08-14 |
+--------+-----+------------+
4 rows in set (0.00 sec)

-- 31 查询成绩比该课程平均成绩低的同学的成绩表。
select avg(degree) from score group by cno ;
select * from score a where degree < (select avg(degree) from score b where a.cno=b.cno) ;
+-----+-------+--------+    复制一个新表做条件查询。
| sno | cno   | degree |
+-----+-------+--------+
| 101 | 3-105 |     90 |
| 102 | 3-105 |     91 |
| 103 | 3-105 |     92 |
| 103 | 3-245 |     86 |
| 103 | 6-166 |     85 |
| 104 | 3-105 |     89 |
| 105 | 3-105 |     88 |
| 105 | 3-245 |     75 |
| 105 | 6-166 |     79 |
| 109 | 3-105 |     76 |
| 109 | 3-245 |     68 |
| 109 | 6-166 |     81 |
+-----+-------+--------+
12 rows in set (0.00 sec)

-- 32 查询所有任课教师的tname、和depart。
select tno from course;
select tname,depart from teacher where tno in(select tno from course);
+--------+-----------------+
| tname  | depart          |
+--------+-----------------+
| 李诚   | 计算机系        |
| 王萍   | 计算机系        |
| 刘冰   | 电子工程系      |
| 张旭   | 电子工程系      |
+--------+-----------------+
4 rows in set (0.00 sec)

-- 33 查询至少有2名男生的班号。
select class from student where ssex='男' group by class having count(*)>1 ;
+-------+
| class |
+-------+
| 95033 |
| 95031 |
+-------+
2 rows in set (0.01 sec)

-- 34 查询student表中不姓‘王’的同学记录。
select * from student where sname not like '王%';
+-----+-----------+------+------------+-------+
| sno | sname     | ssex | sbirthday  | class |
+-----+-----------+------+------------+-------+
| 101 | 曾华      | 男   | 1977-09-01 | 95033 |
| 102 | 匡明      | 男   | 1975-10-02 | 95031 |
| 104 | 李军      | 男   | 1976-02-20 | 95033 |
| 106 | 陆君      | 男   | 1974-06-03 | 95031 |
| 108 | 张全蛋    | 男   | 1975-02-10 | 95031 |
| 109 | 赵铁柱    | 男   | 1974-06-03 | 95031 |
| 110 | 张飞      | 男   | 1974-06-03 | 95038 |
+-----+-----------+------+------------+-------+
7 rows in set (0.00 sec)

-- 35 查询student表中每个学生的姓名和年龄。
select sname,year(now())-year(sbirthday) as age from student;
+-----------+------+
| sname     | age  |
+-----------+------+
| 曾华      |   42 |
| 匡明      |   44 |
| 王丽      |   43 |
| 李军      |   43 |
| 王芳      |   44 |
| 陆君      |   45 |
| 王尼玛    |   43 |
| 张全蛋    |   44 |
| 赵铁柱    |   45 |
| 张飞      |   45 |
+-----------+------+
10 rows in set (0.00 sec)

-- 36 查询student表中最大和最小的sbirthday日期值。
select max(sbirthday) as '最大', min(sbirthday) as '最小' from student;
+------------+------------+
| 最大       | 最小       |
+------------+------------+
| 1977-09-01 | 1974-06-03 |
+------------+------------+
1 row in set (0.00 sec)

-- 37 以班号和年龄从大到小的顺序查询student表中的全部记录。
select * from student order by class desc ,sbirthday asc ;
+-----+-----------+------+------------+-------+
| sno | sname     | ssex | sbirthday  | class |
+-----+-----------+------+------------+-------+
| 110 | 张飞      | 男   | 1974-06-03 | 95038 |
| 103 | 王丽      | 女   | 1976-01-23 | 95033 |
| 104 | 李军      | 男   | 1976-02-20 | 95033 |
| 107 | 王尼玛    | 男   | 1976-02-20 | 95033 |
| 101 | 曾华      | 男   | 1977-09-01 | 95033 |
| 106 | 陆君      | 男   | 1974-06-03 | 95031 |
| 109 | 赵铁柱    | 男   | 1974-06-03 | 95031 |
| 105 | 王芳      | 女   | 1975-02-10 | 95031 |
| 108 | 张全蛋    | 男   | 1975-02-10 | 95031 |
| 102 | 匡明      | 男   | 1975-10-02 | 95031 |
+-----+-----------+------+------------+-------+
10 rows in set (0.00 sec)

-- 38 查询‘男’教师及其所上的课程。
select tno from teacher where tsex='男';
select * from course where tno in (select tno from teacher where tsex='男');
+-------+--------------+-----+
| cno   | cname        | tno |
+-------+--------------+-----+
| 3-245 | 操作系统     | 804 |
| 6-166 | 数字电路     | 856 |
+-------+--------------+-----+
2 rows in set (0.00 sec)

-- 39 查询最高分同学的sno、cno、和degree列。
select max(degree) from score;
select * from score where degree=(select max(degree) from score);
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 103 | 3-105 |     92 |
+-----+-------+--------+
1 row in set (0.00 sec)

-- 40 查询和‘李军’同性别的所有同学的sname。
select ssex from student where sname='李军';
select sname from student where ssex=(select ssex from student where sname='李军');
+-----------+
| sname     |
+-----------+
| 曾华      |
| 匡明      |
| 李军      |
| 陆君      |
| 王尼玛    |
| 张全蛋    |
| 赵铁柱    |
| 张飞      |
+-----------+
8 rows in set (0.00 sec)

-- 41 查询和‘李军’同性别并同班的所有同学的sname。
select sname from student where ssex=(select ssex from student where sname='李军')
and class=(select class from student where sname='李军' );
| sname     |
+-----------+
| 曾华      |
| 李军      |
| 王尼玛    |
+-----------+
3 rows in set (0.00 sec)

-- 42 查询所有选修‘计算机导论’课程的‘男’同学的成绩表。
select cno from course where cname='计算机导论';
select sno from student where ssex='男';
select * from score where cno in (select cno from course where cname='计算机导论') and sno in (select sno from student where ssex='男');
+-----+-------+--------+
| sno | cno   | degree |
+-----+-------+--------+
| 101 | 3-105 |     90 |
| 102 | 3-105 |     91 |
| 104 | 3-105 |     89 |
| 109 | 3-105 |     76 |
+-----+-------+--------+
4 rows in set (0.00 sec)

-- 43 假设使用如下命令建立一个grade表：
create table grade(
    low int(3),
    upp int(3),
    grade char(1)
);
insert into grade values (90, 100, 'A');
insert into grade values (80, 89, 'B');
insert into grade values (70, 79, 'C');
insert into grade values (60, 69, 'D');
insert into grade values (0, 59, 'E');
-- 查询所有同学的sno、cno、和grade列。
select sno,cno,grade from score,grade where degree between low and upp;
+-----+-------+-------+   按等级查询
| sno | cno   | grade |
+-----+-------+-------+
| 101 | 3-105 | A     |
| 102 | 3-105 | A     |
| 103 | 3-105 | A     |
| 103 | 3-245 | B     |
| 103 | 6-166 | B     |
| 104 | 3-105 | B     |
| 105 | 3-105 | B     |
| 105 | 3-245 | C     |
| 105 | 6-166 | C     |
| 109 | 3-105 | C     |
| 109 | 3-245 | D     |
| 109 | 6-166 | B     |
+-----+-------+-------+
12 rows in set (0.00 sec)

55 SQL的四种连接查询