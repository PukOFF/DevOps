# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```
```bash
route-views>sh ip route 109.252.83.247
Routing entry for 109.252.0.0/16
  Known via "bgp 6447", distance 20, metric 0
  Tag 2497, type external
  Last update from 202.232.0.2 3w5d ago
  Routing Descriptor Blocks:
  * 202.232.0.2, from 202.232.0.2, 3w5d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 2497
      MPLS label: none
route-views>

```

***

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

```bash
    vagrant@dev:~$ sudo ip link add name dum0 type dummy
    vagrant@dev:~$ sudo ip link set dum0 up
    vagrant@dev:~$ sudo ip address add 192.0.2.10/32 dev dum0
    vagrant@dev:~$ ip route
    default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
    10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
    10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
    192.168.1.0/24 dev eth1 proto kernel scope link src 192.168.1.160 
    vagrant@dev:~$ ifconfig -a
    dum0: flags=195<UP,BROADCAST,RUNNING,NOARP>  mtu 1500
        inet 192.0.2.10  netmask 255.255.255.255  broadcast 0.0.0.0
        inet6 fe80::4065:bfff:feef:3d97  prefixlen 64  scopeid 0x20<link>
        ether 42:65:bf:ef:3d:97  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 4  bytes 280 (280.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
    vagrant@dev:~$ sudo ip route add 10.10.10.0/24 dev dum0
    vagrant@dev:~$ sudo ip route add 10.20.20.0/24 dev dum0
    vagrant@dev:~$ netstat -r
    Kernel IP routing table
    Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
    default         10.0.2.2        0.0.0.0         UG        0 0          0 eth0
    10.0.2.0        0.0.0.0         255.255.255.0   U         0 0          0 eth0
    10.0.2.2        0.0.0.0         255.255.255.255 UH        0 0          0 eth0
    10.10.10.0      0.0.0.0         255.255.255.0   U         0 0          0 dum0
    10.20.20.0      0.0.0.0         255.255.255.0   U         0 0          0 dum0
    192.168.1.0     0.0.0.0         255.255.255.0   U         0 0          0 eth1
    vagrant@dev:~$ 
```

***

3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

```bash
    vagrant@dev:~$ netstat -tapn
    (Not all processes could be identified, non-owned process info
     will not be shown, you would have to be root to see it all.)
    Active Internet connections (servers and established)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
    tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      -                   
    tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -                   
    tcp        0      0 10.0.2.15:22            10.0.2.2:57034          ESTABLISHED -                   
    tcp6       0      0 :::22                   :::*                    LISTEN      -                   
    vagrant@dev:~$ 
```
SSH(22), Web Server (80/443), DNS(53)

***

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

```bash
    vagrant@dev:~$ netstat -uapn
    (Not all processes could be identified, non-owned process info
     will not be shown, you would have to be root to see it all.)
    Active Internet connections (servers and established)
    Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
    udp        0      0 127.0.0.53:53           0.0.0.0:*                           -                   
    udp        0      0 10.0.2.15:68            0.0.0.0:*                           -                   
    udp6       0      0 fe80::a00:27ff:feef:546 :::*                                -                   
    vagrant@dev:~$ 
```

***

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали.

Файл scheme.xml
