Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?
    
    Linux:    

    ```bash
    vagrant@test:~$ ip addr
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:b1:28:5d brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
       valid_lft 85987sec preferred_lft 85987sec
    inet6 fe80::a00:27ff:feb1:285d/64 scope link 
       valid_lft forever preferred_lft forever
    vagrant@test:~$ ifconfig 
    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
        inet6 fe80::a00:27ff:feb1:285d  prefixlen 64  scopeid 0x20<link>
        ether 08:00:27:b1:28:5d  txqueuelen 1000  (Ethernet)
        RX packets 138007  bytes 204689816 (204.6 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 8876  bytes 694658 (694.6 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 100  bytes 9284 (9.2 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 100  bytes 9284 (9.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    vagrant@test:~$ cat /proc/net/dev
    Inter-|   Receive                                                |  Transmit
    face |bytes    packets errs drop fifo frame compressed multicast|bytes    packets errs drop fifo colls carrier compressed
    eth0: 204694316  138074    0    0    0     0          0         0   699280    8927    0    0    0     0       0          0
    lo:    9284     100    0    0    0     0          0         0     9284     100    0    0    0     0       0          0 
    ```
    
    Windows:
   
    ```commandline
    ipconfig
    netsh
    ```

***

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

    ```text
    Протокол: Link Layer Discovery Protoco(LLDP)
    Пакет: lldpd
    ```   
***

4. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

    Virtual Local Area Network (VLAN):
    ```bash
    auto eth0
    iface eth0 inet static
    mtu 1440
    auto eth0.411
    iface eth0.411 inet static
    mtu 1440
    address 10.132.13.17
    netmask 255.255.255.252
    broadcast 10.132.13.19
    ```
***

1. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.
    
    ```text
    Агрегация на канальном и сетевом уровнях модели OSI.
    ```
    ```text
    mode=0 (balance-rr) - режим используется по-умолчанию, если в настройках не указано другое. balance-rr обеспечивает балансировку нагрузки и отказоустойчивость. В данном режиме пакеты отправляются "по кругу" от первого интерфейса к последнему и сначала. Если выходит из строя один из интерфейсов, пакеты отправляются на остальные оставшиеся.При подключении портов к разным коммутаторам, требует их настройки.
    mode=1 (active-backup) - один интерфейс работает в активном режиме, остальные в ожидающем. Если активный падает, управление передается одному из ожидающих. Не требует поддержки данной функциональности от коммутатора.
    mode=2 (balance-xor) - Передача пакетов распределяется между объединенными интерфейсами по формуле ((MAC-адрес источника) XOR (MAC-адрес получателя)) % число интерфейсов. Один и тот же интерфейс работает с определённым получателем. Режим даёт балансировку нагрузки и отказоустойчивость.
    mode=3 (broadcast) - Происходит передача во все объединенные интерфейсы, обеспечивая отказоустойчивость.
    mode=4 (802.3ad) - Это динамическое объединение портов. В данном режиме можно получить значительное увеличение пропускной способности как входящего так и исходящего трафика, используя все объединенные интерфейсы. Требует поддержки режима от коммутатора, а так же (иногда) дополнительную настройку коммутатора.
    mode=5 (balance-tlb) - Адаптивная балансировка нагрузки. При balance-tlb входящий трафик получается только активным интерфейсом, исходящий - распределяется в зависимости от текущей загрузки каждого интерфейса. Обеспечивается отказоустойчивость и распределение нагрузки исходящего трафика. Не требует специальной поддержки коммутатора.
    mode=6 (balance-alb) - Адаптивная балансировка нагрузки (более совершенная). Обеспечивает балансировку нагрузки как исходящего (TLB, transmit load balancing), так и входящего трафика (для IPv4 через ARP). Не требует специальной поддержки коммутатором, но требует возможности изменять MAC-адрес устройства.
    ```
    ```bash
    auto bond0
    iface bond0 inet static
    address 10.120.147.30
    netmask 255.255.255.252
    mtu 1500
    slaves eth4 eth5
    bond_mode 802.3ad
    bond_miimon 100
    bond_xmit_hash_policy layer2+3
    ```
***

7. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

    ```text
    /29 - 6 хостов, 1 адрес сети и 1 broadcast; 29 - 24 = 5 2^5=32 ; 10.10.10.0/29, 10.10.10.8/29, 10.10.10.16/29    
    ```
***

8. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.
    
    ```text    
    100.64.0.0/26, 100.64.0.64/26
    198.18.0.0/26, 198.18.0.64/26
    ```
***

9. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?
   
    Linux:  
   
    ```bash
    vagrant@test:~$ arp -n
    Address                  HWtype  HWaddress           Flags Mask            Iface
    10.0.2.3                 ether   52:54:00:12:35:03   C                     eth0
    10.0.2.2                 ether   52:54:00:12:35:02   C                     eth0
    vagrant@test:~$ arp -d 10.0.2.3
    SIOCDARP(dontpub): Operation not permitted
    vagrant@test:~$ sudo arp -d 10.0.2.3
    vagrant@test:~$ arp -n
    Address                  HWtype  HWaddress           Flags Mask            Iface
    10.0.2.2                 ether   52:54:00:12:35:02   C                     eth0
    vagrant@test:~$ sudo ip -s -s neigh flush all
    ```
   
    Windows:
    ```commandline
    C:\Windows\system32\arp -a
    C:\Windows\system32\arp -d <ip_address>
    C:\Windows\system32\netsh interface ip delete arpcache
    ```


