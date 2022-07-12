# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.
```bash
lex@userver:~$ docker run --name postgres13 -p 5432:5432 -v postgreSQL:/data/postgreSQL -e POSTGRES_USER=test-admin -e POSTGRES_PASSWORD=security -e POSTGRES_DB=test_database -d postgres:13
92a41b54d997ccdbec9ffb060022521b576518b4f94dabc8527e978ae700bd6a
lex@userver:~$ docker ps -a
CONTAINER ID   IMAGE               COMMAND                  CREATED          STATUS                       PORTS                                       NAMES
92a41b54d997   postgres:13         "docker-entrypoint.s…"   11 seconds ago   Up 4 seconds                 0.0.0.0:5432->5432/tcp, :::5432->5432/tcp   postgres13
5d7758a2399f   mysql:8.0.21        "docker-entrypoint.s…"   4 days ago       Exited (137) 8 minutes ago                                               mysql
2e5c23f1cdfb   postgres:12         "docker-entrypoint.s…"   3 weeks ago      Exited (0) 4 days ago                                                    postgres
0a81efbe8eda   pukoff/ansible:v1   "ansible-playbook --…"   5 weeks ago      Exited (0) 5 weeks ago                                                   serene_herschel
a800b719c367   debian:latest       "bash"                   5 weeks ago      Exited (137) 3 weeks ago                                                 debian
e44575b56f92   centos:latest       "/bin/bash"              5 weeks ago      Exited (0) 3 weeks ago                                                   centos
lex@userver:~$
```
---
Подключитесь к БД PostgreSQL используя `psql`.

```bash
lex@userver:~$ docker exec -it postgres13 /bin/bash
root@92a41b54d997:/# psql test_database test-admin
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

test_database=#
```

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```bash
test_database=# \l
                                        List of databases
     Name      |   Owner    | Encoding |  Collate   |   Ctype    |       Access privileges
---------------+------------+----------+------------+------------+-------------------------------
 postgres      | test-admin | UTF8     | en_US.utf8 | en_US.utf8 |
 template0     | test-admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin"              +
               |            |          |            |            | "test-admin"=CTc/"test-admin"
 template1     | test-admin | UTF8     | en_US.utf8 | en_US.utf8 | =c/"test-admin"              +
               |            |          |            |            | "test-admin"=CTc/"test-admin"
 test_database | test-admin | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)

test_database=#
```
---
- подключения к БД
```bash
test_database=# \c test_database
You are now connected to database "test_database" as user "test-admin".
test_database=#
```
---
- вывода списка таблиц
```bash
postgres=# \dt information_schema.*
                         List of relations
       Schema       |          Name           | Type  |   Owner
--------------------+-------------------------+-------+------------
 information_schema | sql_features            | table | test-admin
 information_schema | sql_implementation_info | table | test-admin
 information_schema | sql_parts               | table | test-admin
 information_schema | sql_sizing              | table | test-admin
(4 rows)

postgres=#
```
---
- вывода описания содержимого таблиц
```bash
postgres=# \dS information_schema.views
                                 View "information_schema.views"
           Column           |               Type                | Collation | Nullable | Default
----------------------------+-----------------------------------+-----------+----------+---------
 table_catalog              | information_schema.sql_identifier |           |          |
 table_schema               | information_schema.sql_identifier |           |          |
 table_name                 | information_schema.sql_identifier |           |          |
 view_definition            | information_schema.character_data |           |          |
 check_option               | information_schema.character_data |           |          |
 is_updatable               | information_schema.yes_or_no      |           |          |
 is_insertable_into         | information_schema.yes_or_no      |           |          |
 is_trigger_updatable       | information_schema.yes_or_no      |           |          |
 is_trigger_deletable       | information_schema.yes_or_no      |           |          |
 is_trigger_insertable_into | information_schema.yes_or_no      |           |          |

postgres=#
```
- выхода из psql
```bash
postgres=# \q
root@92a41b54d997:/#
```
---

## Задача 2

Используя `psql` создайте БД `test_database`.
```bash
root@92a41b54d997:/# psql postgres test-admin
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

postgres=# 
```
---
Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```bash
postgres=# create database test_database;
CREATE DATABASE
postgres=# \q
root@92a41b54d997:/# psql -U test-admin -d test_database -f /data/postgreSQL/test_dump.sql
```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```bash
root@92a41b54d997:/# psql test_database test-admin;
psql (13.7 (Debian 13.7-1.pgdg110+1))
Type "help" for help.

test_database=# analyze VERBOSE public.orders ;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=# 
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.
```bash
test_database=# select avg_width from pg_stats where tablename='orders';
 avg_width
-----------
         4
        16
         4
(3 rows)

test_database=#
```

---
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```bash
test_database=# alter table orders rename to orders_simple;
ALTER TABLE
test_database=# create table orders (id integer, title varchar(80), price integer) partition by range(price);
CREATE TABLE
test_database=# create table orders_less499 partition of orders for values from (0) to (499);
CREATE TABLE
test_database=# create table orders_more499 partition of orders for values from (499) to (999999999);
CREATE TABLE
test_database=# insert into orders (id, title, price) select * from orders_simple;
INSERT 0 8
test_database=# 
```
---

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

```text
При изначальном проектировании таблиц можно было сделать ее секционированной, тогда не пришлось бы переименовывать исходную таблицу и переносить данные в новую
```

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```bash
root@92a41b54d997:/# pg_dump -U test-admin -d test_database > /data/postgreSQL/backup_30062022.sql
root@92a41b54d997:/# ls -l /data/postgreSQL/
total 8
-rw-r--r-- 1 root root 2104 Jun 30 09:45 backup_30062022.sql
-rw-r--r-- 1 root root 2081 Jun 30 09:00 test_dump.sql
root@92a41b54d997:/#
```
---
Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

Для уникальности можно добавить ограничение. Уникальное ограничение - это отдельное поле или комбинация полей, которые однозначно определяют запись. Некоторые поля могут содержать нулевые значения, если комбинация значений уникальна..
```bash
alter table orders
add constraint order_unique unique (title, price);
```
