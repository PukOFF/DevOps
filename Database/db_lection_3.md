## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

```bash
lex@userver:~$ docker run \
--name mysql \
-p 3306:3306 \
-v mysql:/data/mysql \
-e MYSQL_ROOT_PASSWORD=security \
-e MYSQL_DATABASE=test_db \
-d mysql:8.0.21

lex@userver:~$ docker ps -a
CONTAINER ID   IMAGE               COMMAND                  CREATED         STATUS                      PORTS                                                  NAMES
5d7758a2399f   mysql:8.0.21        "docker-entrypoint.s…"   8 minutes ago   Up 8 minutes                0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp   mysql
```
---

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и 
восстановитесь из него.
```bash
lex@userver:~$ docker exec -it mysql /bin/bash
root@5d7758a2399f:/# mysql test_db < /data/mysql/test_dump.sql -uroot -p
Enter password:
root@5d7758a2399f:/# 
```
---


Перейдите в управляющую консоль `mysql` внутри контейнера.

```bash
root@5d7758a2399f:/# mysql -uroot -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 14
Server version: 8.0.21 MySQL Community Server - GPL

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test_db            |
+--------------------+
5 rows in set (0.00 sec)

mysql>
```
---
Используя команду `\h` получите список управляющих команд.
```bash
mysql> \h

For information about MySQL products and services, visit:
   http://www.mysql.com/
For developer information, including the MySQL Reference Manual, visit:
   http://dev.mysql.com/
To buy MySQL Enterprise support, training, or other products, visit:
   https://shop.mysql.com/

List of all MySQL commands:
Note that all text commands must be first on line and end with ';'
?         (\?) Synonym for `help'.
clear     (\c) Clear the current input statement.
connect   (\r) Reconnect to the server. Optional arguments are db and host.
delimiter (\d) Set statement delimiter.
edit      (\e) Edit command with $EDITOR.
ego       (\G) Send command to mysql server, display result vertically.
exit      (\q) Exit mysql. Same as quit.
go        (\g) Send command to mysql server.
help      (\h) Display this help.
nopager   (\n) Disable pager, print to stdout.
notee     (\t) Don't write into outfile.
pager     (\P) Set PAGER [to_pager]. Print the query results via PAGER.
print     (\p) Print current command.
prompt    (\R) Change your mysql prompt.
quit      (\q) Quit mysql.
rehash    (\#) Rebuild completion hash.
source    (\.) Execute an SQL script file. Takes a file name as an argument.
status    (\s) Get status information from the server.
system    (\!) Execute a system shell command.
tee       (\T) Set outfile [to_outfile]. Append everything into given outfile.
use       (\u) Use another database. Takes database name as argument.
charset   (\C) Switch to another charset. Might be needed for processing binlog with multi-byte charsets.
warnings  (\W) Show warnings after every statement.
nowarning (\w) Don't show warnings after every statement.
resetconnection(\x) Clean session context.

For server side help, type 'help contents'

mysql>
```
---
Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.
```bash
mysql> status
--------------
mysql  Ver 8.0.21 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          14
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.0.21 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 17 min 5 sec

Threads: 4  Questions: 73  Slow queries: 0  Opens: 177  Flush tables: 3  Open tables: 97  Queries per second avg: 0.071
--------------
mysql>
```
---
Подключитесь к восстановленной БД и получите список таблиц из этой БД.
```bash
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql>
```
---
**Приведите в ответе** количество записей с `price` > 300.
```bash
mysql> select title,price from orders where price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)

mysql>
```

В следующих заданиях мы будем продолжать работу с данным контейнером.

***

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней 
- количество попыток авторизации - 3 
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"
```bash
mysql>CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass'
WITH MAX_QUERIES_PER_HOUR 100
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 3
ATTRIBUTE '{"fname":"James","lname":"Pretty"}';
```
---

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
```bash
mysql>GRANT SELECT ON test_db.* TO 'test'@'localhost'
```
---    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

```bash
mysql> select * from information_schema.user_attributes where user='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

mysql> select * from mysql.user where user='test' \G
*************************** 1. row ***************************
                    Host: localhost
                    User: test
             Select_priv: N
             Insert_priv: N
             Update_priv: N
             Delete_priv: N
             Create_priv: N
               Drop_priv: N
             Reload_priv: N
           Shutdown_priv: N
            Process_priv: N
               File_priv: N
              Grant_priv: N
         References_priv: N
              Index_priv: N
              Alter_priv: N
            Show_db_priv: N
              Super_priv: N
   Create_tmp_table_priv: N
        Lock_tables_priv: N
            Execute_priv: N
         Repl_slave_priv: N
        Repl_client_priv: N
        Create_view_priv: N
          Show_view_priv: N
     Create_routine_priv: N
      Alter_routine_priv: N
        Create_user_priv: N
              Event_priv: N
            Trigger_priv: N
  Create_tablespace_priv: N
                ssl_type:
              ssl_cipher: 0x
             x509_issuer: 0x
            x509_subject: 0x
           max_questions: 100
             max_updates: 0
         max_connections: 0
    max_user_connections: 0
                  plugin: caching_sha2_password
   authentication_string: $A$005$L;s3ecWq=
3or%sy5C2SfaStxtZJluDj9F6sG3asu4OTo9wy6oe.kuLoD
        password_expired: N
   password_last_changed: 2022-06-25 21:01:57
       password_lifetime: 180
          account_locked: N
        Create_role_priv: N
          Drop_role_priv: N
  Password_reuse_history: NULL
     Password_reuse_time: NULL
Password_require_current: NULL
         User_attributes: {"metadata": {"fname": "James", "lname": "Pretty"}, "Password_locking": {"failed_login_attempts": 3, "password_lock_time_days": 0}}
1 row in set (0.00 sec)

mysql>
```

***

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.
```bash
mysql> set profiling = 1;
Query OK, 0 rows affected, 1 warning (0.01 sec)

showmysql> show profiles;
+----------+------------+---------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                               |
+----------+------------+---------------------------------------------------------------------------------------------------------------------+
|        1 | 0.00124025 | select * from mysql.user where user='test'                                                                          |
|        2 | 0.03184500 | GRANT SELECT ON test_db.* TO 'test'@'localhost'                                                                     |
|        3 | 0.00084850 | select title,price from orders where price > 300                                                                    |
|        4 | 0.00058950 | select DATABASE(), USER() limit 1                                                                                   |
|        5 | 0.00064200 | select @@character_set_client, @@character_set_connection, @@character_set_server, @@character_set_database limit 1 |
+----------+------------+---------------------------------------------------------------------------------------------------------------------+
5 rows in set, 1 warning (0.00 sec)

mysql>
```
---
Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
```bash
mysql> show table status \G
*************************** 1. row ***************************
           Name: orders
         Engine: InnoDB
        Version: 10
     Row_format: Dynamic
           Rows: 5
 Avg_row_length: 3276
    Data_length: 16384
Max_data_length: 0
   Index_length: 0
      Data_free: 0
 Auto_increment: 6
    Create_time: 2022-06-25 20:14:09
    Update_time: 2022-06-25 20:14:09
     Check_time: NULL
      Collation: utf8mb4_0900_ai_ci
       Checksum: NULL
 Create_options:
        Comment:
1 row in set (0.01 sec)

mysql>
```
---

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
```bash
mysql> show profiles;
+----------+------------+---------------------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                               |
+----------+------------+---------------------------------------------------------------------------------------------------------------------+
|        2 | 0.03184500 | GRANT SELECT ON test_db.* TO 'test'@'localhost'                                                                     |
|        3 | 0.00084850 | select title,price from orders where price > 300                                                                    |
|        4 | 0.00058950 | select DATABASE(), USER() limit 1                                                                                   |
|        5 | 0.00064200 | select @@character_set_client, @@character_set_connection, @@character_set_server, @@character_set_database limit 1 |
|        6 | 0.00015425 | show engine                                                                                                         |
|        7 | 0.00288125 | show engines                                                                                                        |
|        8 | 0.11332400 | show table status                                                                                                   |
|        9 | 0.00037400 | show test_db status                                                                                                 |
|       10 | 0.01222675 | show table status                                                                                                   |
|       11 | 0.00016800 | alter test_db engine=MyISAM                                                                                         |
|       12 | 0.52373750 | alter table test_db engine=MyISAM                                                                                   |
|       13 | 0.00014250 | alter table engine=MyISAM                                                                                           |
|       14 | 0.00292625 | alter table . engine=MyISAM                                                                                         |
|       15 | 2.37224950 | alter table orders engine=MyISAM                                                                                    |
|       16 | 0.30059200 | alter table orders engine=InnoDB                                                                                    |
+----------+------------+---------------------------------------------------------------------------------------------------------------------+
15 rows in set, 1 warning (0.00 sec)

mysql>

```

---

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.
```bash
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

#Set IO Speed
# 0 - скорость
# 1 - сохранность
# 2 - универсальный параметр
innodb_flush_log_at_trx_commit = 0 

#Set compression
# Barracuda - формат файла с сжатием
innodb_file_format=Barracuda

#Set buffer
innodb_log_buffer_size	= 1M

#Set Cache size
key_buffer_size = 640М

#Set log size
max_binlog_size	= 100M
```