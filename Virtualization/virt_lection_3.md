# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.


**Public link** - https://hub.docker.com/r/pukoff/nginx

***


## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;
Лучше использовать виртуальный сервер, так как требуется работа с высоконагруженным приложением.
- Nodejs веб-приложение;
Для данной задачи Docker контейнер подходит, так как необходимо постоянно тестировать и деплоить нофые функции приложения.
- Мобильное приложение c версиями для Android и iOS;
Для данной задачи Docker контейнер подходит, так как требуется несколько сред для разных версий ОС.
- Шина данных на базе Apache Kafka;
Виртуальный или физический сервер
- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;
Для данной задачи Docker контейнер подходит идеально, так как позволяет изолировать данное приложение.
- Мониторинг-стек на базе Prometheus и Grafana;
Лучше использовать виртуальный сервер, так как требуется отказоустойчивое решение.
- MongoDB, как основное хранилище данных для java-приложения;
Для данной задачи Docker контейнер подходит идеально, так как позволяет изолировать приложение (в данном случае БД) от других приложений.
- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
Виртуальный сервер


## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```bash
lex@userver:~$ docker run -dit --name centos -v ~/data:/data centos:latest
e44575b56f92f266033aa6a6e9a75070d452d4053c040b02a875fde8339dfa67
lex@userver:~$ docker ps -a
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS                            PORTS                                   NAMES
e44575b56f92   centos:latest      "/bin/bash"              6 seconds ago    Up 5 seconds                                                              centos
731555b822a5   debian:latest      "bash"                   20 minutes ago   Exited (137) About a minute ago                                           debian
3588b0d156c4   pukoff/nginx:0.1   "/docker-entrypoint.…"   3 days ago       Up 3 days                         0.0.0.0:8080->80/tcp, :::8080->80/tcp   web
lex@userver:~$ docker rm debian
debian
lex@userver:~$ docker run -dit --name debian -v ~/data:/data debian:latest
a800b719c367a04d8ceaddd23c5a522cf3fd1e02fa768e2ab801cb44938068ce
lex@userver:~$ docker ps -a
CONTAINER ID   IMAGE              COMMAND                  CREATED          STATUS          PORTS                                   NAMES
a800b719c367   debian:latest      "bash"                   2 seconds ago    Up 1 second                                             debian
e44575b56f92   centos:latest      "/bin/bash"              37 seconds ago   Up 36 seconds                                           centos
3588b0d156c4   pukoff/nginx:0.1   "/docker-entrypoint.…"   3 days ago       Up 3 days       0.0.0.0:8080->80/tcp, :::8080->80/tcp   web
lex@userver:~$ docker exec centos /bin/bash
lex@userver:~$ docker exec -it centos bash
[root@e44575b56f92 /]# ls
bin  data  dev  etc  home  lib  lib64  lost+found  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
[root@e44575b56f92 /]# exit
exit
lex@userver:~$ docker exec -it debian bash
root@a800b719c367:/# ls
bin  boot  data  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@a800b719c367:/# exit
exit
lex@userver:~$ docker exec -it centos bash
[root@e44575b56f92 /]# touch test.txt
[root@e44575b56f92 /]# ls /data
host.txt
[root@e44575b56f92 /]# exit
exit
lex@userver:~$ docker exec -it debian bash
root@a800b719c367:/# ls /data
root@a800b719c367:/# exit
exit
lex@userver:~$ touch data/host.txt
lex@userver:~$ docker exec -it debian bash
root@a800b719c367:/# ls /data/
host.txt
root@a800b719c367:/#

```



## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

**Public link** - https://hub.docker.com/r/pukoff/ansible