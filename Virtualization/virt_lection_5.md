## Задача 1

Дайте письменые ответы на следующие вопросы:

- В чём отличие режимов работы сервисов в Docker Swarm кластере: replication и global?
- Какой алгоритм выбора лидера используется в Docker Swarm кластере?
- Что такое Overlay Network?

***
Replication - указывает количество сервисов, которое будет запущено.
Global - запускает сервис на каждой ноде.

Manager-Leader избираются на роль лидера посредством консенсуса узлов

Overlay- сеть для общения контейнеров между собой в рамках swarm-кластера . Контейнеры на разных физических хостах могут обмениваться данными по overlay-сети (если все они прикреплены к одной сети)

## Задача 2

Создать ваш первый Docker Swarm кластер в Яндекс.Облаке

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker node ls
```
***

```bash
Apply complete! Resources: 13 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_node01 = "51.250.91.93"
external_ip_address_node02 = "51.250.95.14"
external_ip_address_node03 = "51.250.84.179"
external_ip_address_node04 = "51.250.71.117"
external_ip_address_node05 = "51.250.87.139"
external_ip_address_node06 = "51.250.76.174"
internal_ip_address_node01 = "192.168.101.11"
internal_ip_address_node02 = "192.168.101.12"
internal_ip_address_node03 = "192.168.101.13"
internal_ip_address_node04 = "192.168.101.14"
internal_ip_address_node05 = "192.168.101.15"
internal_ip_address_node06 = "192.168.101.16"
alex@AlexPC:~/src/terraform$ ^C
alex@AlexPC:~/src/terraform$ ssh centos@51.250.91.93
[centos@node01 ~]$ docker node ls
Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/nodes": dial unix /var/run/docker.sock: connect: permission denied
[centos@node01 ~]$ sudo docker node ls
ID                            HOSTNAME             STATUS    AVAILABILITY   MANAGER STATUS   ENGINE VERSION
2d4xc0n891psir4ftdzu7cdxt *   node01.netology.yc   Ready     Active         Leader           20.10.17
9knb3b4p04pbcugjunjnfsdop     node02.netology.yc   Ready     Active         Reachable        20.10.17
ej2pvli3c14g2pp0oxe7qgiwu     node03.netology.yc   Ready     Active         Reachable        20.10.17
1tgrhqqbjn08ba61rakw9smqz     node04.netology.yc   Ready     Active                          20.10.17
w8zn8neulqej3a6yy1a3mfq5u     node05.netology.yc   Ready     Active                          20.10.17
x5c8b46kypgvy7kez0p9n3juq     node06.netology.yc   Ready     Active                          20.10.17
[centos@node01 ~]$
```

## Задача 3

Создать ваш первый, готовый к боевой эксплуатации кластер мониторинга, состоящий из стека микросервисов.

Для получения зачета, вам необходимо предоставить скриншот из терминала (консоли), с выводом команды:
```
docker service ls
```

***

```bash
[centos@node01 ~]$ sudo docker service ls
ID             NAME                                MODE         REPLICAS   IMAGE                                          PORTS
83i18qpge3ef   swarm_monitoring_alertmanager       replicated   1/1        stefanprodan/swarmprom-alertmanager:v0.14.0    
tvgzkl5jj79c   swarm_monitoring_caddy              replicated   1/1        stefanprodan/caddy:latest                      *:3000->3000/tcp, *:9090->9090/tcp, *:9093-9094->9093-9094/tcp
a2wb2n5rzp4u   swarm_monitoring_cadvisor           global       6/6        google/cadvisor:latest                         
t5la33pmq6d1   swarm_monitoring_dockerd-exporter   global       6/6        stefanprodan/caddy:latest                      
nibm65x6gw95   swarm_monitoring_grafana            replicated   1/1        stefanprodan/swarmprom-grafana:5.3.4           
zgg6l88qb2sa   swarm_monitoring_node-exporter      global       6/6        stefanprodan/swarmprom-node-exporter:v0.16.0   
c9cmrob4dw7z   swarm_monitoring_prometheus         replicated   1/1        stefanprodan/swarmprom-prometheus:v2.5.0       
g431oy5iqfpw   swarm_monitoring_unsee              replicated   1/1        cloudflare/unsee:v0.8.0                        
[centos@node01 ~]$ exit
logout
Connection to 51.250.91.93 closed.
alex@AlexPC:~/src/terraform$ 
```


## Задача 4 (*)

Выполнить на лидере Docker Swarm кластера команду (указанную ниже) и дать письменное описание её функционала, что она делает и зачем она нужна:
```
# см.документацию: https://docs.docker.com/engine/swarm/swarm_manager_locking/
docker swarm update --autolock=true
```
