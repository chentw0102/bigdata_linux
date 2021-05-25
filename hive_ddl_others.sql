-------------------Database 数据库 DDL操作---------------------------------------
--创建数据库
create database if not exists itheima
comment "this is my first db"
with dbproperties ('createdBy'='Allen');

--描述数据库信息
describe database itheima;
describe database extended itheima;
desc database extended itheima;

--切换数据库
use default;
use itheima;
create table t_1(id int);

--删除数据库
--注意 CASCADE关键字慎重使用
DROP (DATABASE|SCHEMA) [IF EXISTS] database_name [RESTRICT|CASCADE];
drop database itheima cascade ;


--更改数据库属性
ALTER (DATABASE|SCHEMA) database_name SET DBPROPERTIES (property_name=property_value, ...);
--更改数据库所有者
ALTER (DATABASE|SCHEMA) database_name SET OWNER [USER|ROLE] user_or_role;
--更改数据库位置
ALTER (DATABASE|SCHEMA) database_name SET LOCATION hdfs_path;


-------------------Table 表 DDL操作---------------------------------------

--查询指定表的元数据信息
describe formatted ;
desc  formatted t_user_double_p ;

--1、更改表名
ALTER TABLE table_name RENAME TO new_table_name;
--2、更改表属性
ALTER TABLE table_name SET TBLPROPERTIES (property_name = property_value, ... );
--更改表注释
ALTER TABLE student SET TBLPROPERTIES ('comment' = "new comment for student table");
--3、更改SerDe属性
ALTER TABLE table_name SET SERDE serde_class_name [WITH SERDEPROPERTIES (property_name = property_value, ... )];
ALTER TABLE table_name [PARTITION partition_spec] SET SERDEPROPERTIES serde_properties;
ALTER TABLE table_name SET SERDEPROPERTIES ('field.delim' = ',');
--移除SerDe属性
ALTER TABLE table_name [PARTITION partition_spec] UNSET SERDEPROPERTIES (property_name, ... );

--4、更改表的文件存储格式 该操作仅更改表元数据。现有数据的任何转换都必须在Hive之外进行。
ALTER TABLE table_name  SET FILEFORMAT file_format;
--5、更改表的存储位置路径
ALTER TABLE table_name SET LOCATION "new location";

--6、更改列名称/类型/位置/注释
CREATE TABLE test_change (a int, b int, c int);

// First change column a's name to a1.
ALTER TABLE test_change CHANGE a a1 INT;

// Next change column a1's name to a2, its data type to string, and put it after column b.
ALTER TABLE test_change CHANGE a1 a2 STRING AFTER b;

// The new table's structure is:  b int, a2 string, c int.
// Then change column c's name to c1, and put it as the first column.
ALTER TABLE test_change CHANGE c c1 INT FIRST;
// The new table's structure is:  c1 int, b int, a2 string.
// Add a comment to column a1
ALTER TABLE test_change CHANGE a1 a1 INT COMMENT 'this is column a1';

--7、添加/替换列
--使用ADD COLUMNS，您可以将新列添加到现有列的末尾但在分区列之前。
--REPLACE COLUMNS 将删除所有现有列，并添加新的列集。
ALTER TABLE table_name ADD|REPLACE COLUMNS (col_name data_type,...);


-------------------Partition分区 DDL操作---------------------------------------
--1、增加分区
--step1: 创建表 手动加载分区数据

drop table if exists t_user_province;
create table t_user_province (
    num int,
    name string,
    sex string,
    age int,
    dept string) partitioned by (province string)
	row format delimited fields terminated by ',';

load data local inpath '/root/hivedata/students.txt' into table t_user_province partition(province ="SH");

--step2：添加一个分区
ALTER TABLE t_user_province ADD PARTITION (province='BJ') location
    '/user/hive/warehouse/itcast.db/t_user_province/province=BJ';

--step3:必须自己把数据加载到增加的分区中 hive不会帮你添加


----此外还支持一次添加多个分区
ALTER TABLE table_name ADD PARTITION (dt='2008-08-08', country='us') location '/path/to/us/part080808'
    PARTITION (dt='2008-08-09', country='us') location '/path/to/us/part080809';


--2、重命名分区
ALTER TABLE t_user_province PARTITION (province ="SH") RENAME TO PARTITION (province ="Shanghai");

--3、删除分区
ALTER TABLE table_name DROP [IF EXISTS] PARTITION (dt='2008-08-08', country='us');
ALTER TABLE table_name DROP [IF EXISTS] PARTITION (dt='2008-08-08', country='us') PURGE; --直接删除数据 不进垃圾桶


--4、修改分区
--更改分区文件存储格式
ALTER TABLE table_name PARTITION (dt='2008-08-09') SET FILEFORMAT file_format;
--更改分区位置
ALTER TABLE table_name PARTITION (dt='2008-08-09') SET LOCATION "new location";





--1、显示所有数据库 SCHEMAS和DATABASES的用法 功能一样
show databases;
show schemas;

--2、显示当前数据库所有表
show tables;
SHOW TABLES [IN database_name]; --指定某个数据库

--3、显示表分区信息，分区按字母顺序列出，不是分区表执行该语句会报错
show partitions table_name;
show partitions itheima.student_partition;

--4、显示表/分区的扩展信息
SHOW TABLE EXTENDED [IN|FROM database_name] LIKE table_name;
show table extended like student;
describe formatted itheima.student;

--5、显示表的属性信息
show tblproperties student;

--6、显示表
show create table student;

--9、显示表中的所有列，包括分区列。
SHOW COLUMNS (FROM|IN) table_name [(FROM|IN) db_name];
show columns  in student;

--10、显示当前支持的所有自定义和内置的函数
show functions;

--11、Describe desc
--查看表信息
desc extended table_name;
--查看表信息（格式化美观）
desc formatted table_name;
--查看数据库相关信息
describe database database_name;