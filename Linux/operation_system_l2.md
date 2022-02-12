# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

        ```bash
        vagrant@test:~$ sudo systemctl status node_exporter
        ● node_exporter.service - Node Exporter
        Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
        Active: active (running) since Sat 2022-02-12 18:47:05 UTC; 5min ago
        Main PID: 623 (node_exporter)
        Tasks: 3 (limit: 1071)
        Memory: 13.7M
        CGroup: /system.slice/node_exporter.service
             └─623 /usr/sbin/node_exporter --web.listen-address=:9100

        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.163Z caller=node_exporter.go:115 level=info collector=thermal_zone
        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.163Z caller=node_exporter.go:115 level=info collector=time
        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.163Z caller=node_exporter.go:115 level=info collector=timex
        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.163Z caller=node_exporter.go:115 level=info collector=udp_queues
        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.163Z caller=node_exporter.go:115 level=info collector=uname
        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.163Z caller=node_exporter.go:115 level=info collector=vmstat
        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.163Z caller=node_exporter.go:115 level=info collector=xfs
        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.163Z caller=node_exporter.go:115 level=info collector=zfs
        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.163Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
        Feb 12 18:47:06 test node_exporter[623]: ts=2022-02-12T18:47:06.185Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
        vagrant@test:~$ 

        vagrant@test:~$ cat /etc/systemd/system/node_exporter.env 
            WEB=--web.listen-address=":9100"
        vagrant@test:~$ cat /etc/systemd/system/node_exporter.service 
            [Unit]
            Description=Node Exporter
            After=network.target

            [Service]
            EnvironmentFile=-/etc/systemd/system/node_exporter.env
            ExecStart=/usr/sbin/node_exporter $WEB
            Restart=Always

            [Install]
            WantedBy=multi-user.target
        vagrant@test:~$ 
        
        vagrant@test:~$ cat /etc/systemd/system/node_exporter.env 
            WEB=--web.listen-address=":9900"
        vagrant@test:~$ sudo systemctl status node_exporter.service
            ● node_exporter.service - Node Exporter
            Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
            Active: active (running) since Sat 2022-02-12 18:55:07 UTC; 26s ago
            Main PID: 1382 (node_exporter)
            Tasks: 4 (limit: 1071)
            Memory: 2.4M
            CGroup: /system.slice/node_exporter.service
                └─1382 /usr/sbin/node_exporter --web.listen-address=:9900

            ...
            Feb 12 18:55:07 test node_exporter[1382]: ts=2022-02-12T18:55:07.852Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9900
            Feb 12 18:55:07 test node_exporter[1382]: ts=2022-02-12T18:55:07.856Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
            vagrant@test:~$ 
        ``` 





2. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

   
   Процессор:
        node_cpu_seconds_total

   Память:
        node_memory_MemTotal_bytes.
        node_memory_MemFree_bytes.
        node_memory_Cached_bytes.
        node_memory_Buffers_bytes.

   Диск:
        node_filesystem_size_bytes.
        node_filesystem_avail_bytes.
        node_filesystem_free_bytes.
        node_disk_read_bytes_total.
        node_disk_written_bytes_total.

    Сеть:
        node_network_receive_bytes_total
        node_network_transmit_bytes_total



3. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

    ```bash
        alex@Alexlap:~/Vagrant$ vagrant reload
    ==> devops: Checking if box 'bento/ubuntu-20.04' version '202112.19.0' is up to date...
    ==> devops: Clearing any previously set forwarded ports...
    ==> devops: Clearing any previously set network interfaces...
    ==> devops: Preparing network interfaces based on configuration...
        devops: Adapter 1: nat
    ==> devops: Forwarding ports...
        devops: 19999 (guest) => 19999 (host) (adapter 1)
        devops: 22 (guest) => 2222 (host) (adapter 1)
    ==> devops: Running 'pre-boot' VM customizations...
    ==> devops: Booting VM...
    ==> devops: Waiting for machine to boot. This may take a few minutes...
        devops: SSH address: 127.0.0.1:2222
        devops: SSH username: vagrant
        devops: SSH auth method: private key
    ==> devops: Machine booted and ready!
    ==> devops: Checking for guest additions in VM...
    ==> devops: Setting hostname...
    ==> devops: Mounting shared folders...
        devops: /vagrant => /home/alex/Vagrant
    ==> devops: Machine already provisioned. Run `vagrant provision` or use the `--provision`
    ==> devops: flag to force provisioning. Provisioners marked to run always will still run.
    ```

4. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?
    ```bash
    vagrant@test:~$ dmesg | grep -i kvm
    [0.000000] Hypervisor detected: KVM
    [0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
    [0.000000] kvm-clock: cpu 0, msr 21e01001, primary cpu clock
    [0.000000] kvm-clock: using sched offset of 4383077257 cycles
    [0.000002] clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
    [0.081728] Booting paravirtualized kernel on KVM
    [0.349104] clocksource: Switched to clocksource kvm-clock
    vagrant@test:~$ 
    ```


5. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

    ```bash
    vagrant@test:~$ sysctl fs.nr_open
    fs.nr_open = 1048576
    ```
    nr_open - Максимальное количество дескрипторов открытых файлов (жесткий предел)
    ulimit -n - максимальное количество дескрипторов открытых файлов (мягкий предел)
    

6. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

    ```
    root@test:~# unshare -f --pid --mount-proc /bin/bash
    root@test:~# ps aux
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  0.3   8960  3992 pts/0    S    20:03   0:00 /bin/bash
    root           8  0.0  0.3  10616  3308 pts/0    R+   20:03   0:00 ps aux
    root@test:~# sleep 1h
    root        1955  0.0  0.4  11020  4572 pts/0    S    20:00   0:00 sudo -i
    root        1956  0.0  0.4   8960  4100 pts/0    S    20:00   0:00 -bash
    root        2024  0.0  0.0   7232   596 pts/0    S    20:03   0:00 unshare -f --pid --mount-proc /bin/bash
    root        2025  0.0  0.4   8960  4036 pts/0    S    20:03   0:00 /bin/bash
    root        2033  0.0  0.0   7228   596 pts/0    S+   20:03   0:00 sleep 1h
    vagrant     2034  0.0  0.3  10616  3368 pts/1    R+   20:03   0:00 ps aux
    vagrant@test:~$ sudo nsenter --target 2033 --pid --mount
    root@test:/# ps aux
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  0.4   8960  4036 pts/0    S    20:03   0:00 /bin/bash
    root           9  0.0  0.0   7228   596 pts/0    S+   20:03   0:00 sleep 1h
    root          10  0.5  0.4   8960  4076 pts/1    S    20:03   0:00 -bash
    root          21  0.0  0.3  10616  3456 pts/1    R+   20:03   0:00 ps aux
    root@test:/# 


7. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

        A classic example of a fork bomb is the Unix shell one :(){ :|:& };:, which can be more easily understood as:
        fork() {
            fork | fork &
                }
        fork
        In it, a function is defined (fork()) as calling itself (fork), then piping (|) its result to a background job of itself (&). 
        Ограничить количество пользователеьских процессов ulimit -u <number_of_process>

        [Feb12 20:05] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-3.scope
        Контрольная группа (cgroup) — набор процессов, объединённых по некоторым признакам, группировка может быть иерархической с наследованием ограничений и параметров родительской группы