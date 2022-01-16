Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"

1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.
        
        vagrant@test:~$ type cd
        cd is a shell builtin
        Команда является втроенной в оболочку и являются более эффективной чем внешние команды.
        Так же, скорее всего, есть связь с обратной совместимостью. 

***

2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l? man grep поможет в ответе на этот вопрос. Ознакомьтесь с документом о других подобных некорректных вариантах использования pipe

        vagrant@test:~$ grep systemd /var/log/syslog | wc -l
        139
        vagrant@test:~$ grep -c systemd /var/log/syslog
        139

***

3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

        vagrant@test:~$ ps -p 1
        PID TTY          TIME CMD
          1 ?        00:00:01 systemd

***

4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?

        vagrant@test:~$ tty
        /dev/pts/0
        vagrant@test:~$ ls -l / > /dev/pts/1
        vagrant@test:~$
        =====================================
        vagrant@test:~$ tty
        /dev/pts/1
        vagrant@test:~$ total 2009700
        lrwxrwxrwx   1 root    root             7 Aug 24 08:41 bin -> usr/bin
        drwxr-xr-x   4 root    root          4096 Dec 19 19:46 boot
        drwxr-xr-x   2 root    root          4096 Dec 19 19:38 cdrom
        drwxr-xr-x  19 root    root          3980 Jan 16 12:32 dev
        drwxr-xr-x  98 root    root          4096 Jan 10 20:38 etc
        drwxr-xr-x   3 root    root          4096 Dec 19 19:42 home
        lrwxrwxrwx   1 root    root             7 Aug 24 08:41 lib -> usr/lib
        lrwxrwxrwx   1 root    root             9 Aug 24 08:41 lib32 -> usr/lib32
        lrwxrwxrwx   1 root    root             9 Aug 24 08:41 lib64 -> usr/lib64
        lrwxrwxrwx   1 root    root            10 Aug 24 08:41 libx32 -> usr/libx32
        drwx------   2 root    root         16384 Dec 19 19:37 lost+found
        drwxr-xr-x   2 root    root          4096 Aug 24 08:42 media
        drwxr-xr-x   2 root    root          4096 Aug 24 08:42 mnt
        drwxr-xr-x   3 root    root          4096 Dec 19 19:45 opt
        dr-xr-xr-x 158 root    root             0 Jan 16 12:32 proc
        drwx------   4 root    root          4096 Dec 19 19:42 root
        drwxr-xr-x  27 root    root           840 Jan 16 15:07 run
        lrwxrwxrwx   1 root    root             8 Aug 24 08:41 sbin -> usr/sbin
        drwxr-xr-x   7 root    root          4096 Jan 10 20:38 snap
        drwxr-xr-x   2 root    root          4096 Aug 24 08:42 srv
        -rw-------   1 root    root    2057306112 Dec 19 19:38 swap.img
        dr-xr-xr-x  13 root    root             0 Jan 16 12:32 sys
        drwxrwxrwt  10 root    root          4096 Jan 16 12:42 tmp
        drwxr-xr-x  15 root    root          4096 Aug 24 08:46 usr
        drwxr-xr-x   1 vagrant vagrant     552960 Jan 10 20:37 vagrant
        drwxr-xr-x  13 root    root          4096 Aug 24 08:47 var

***

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример
    
        vagrant@test:~$ cat /var/log/syslog | head -n 10 > test.log
        vagrant@test:~$ cat test.log 
        Jan 16 12:32:38 test rsyslogd: [origin software="rsyslogd" swVersion="8.2001.0" x-pid="625" x-info="https://www.rsyslog.com"] rsyslogd was HUPed
        Jan 16 12:32:38 test systemd[1]: logrotate.service: Succeeded.
        Jan 16 12:32:38 test systemd[1]: Finished Rotate log files.
        Jan 16 12:32:38 test systemd[1]: Started OpenBSD Secure Shell server.
        Jan 16 12:32:38 test polkitd[688]: started daemon version 0.105 using authority implementation `local' version `0.105'
        Jan 16 12:32:38 test dbus-daemon[618]: [system] Successfully activated service 'org.freedesktop.PolicyKit1'
        Jan 16 12:32:38 test systemd[1]: Started Authorization Manager.
        Jan 16 12:32:38 test accounts-daemon[614]: started daemon version 0.6.55
        Jan 16 12:32:38 test systemd[1]: Started Accounts Service.
        Jan 16 12:32:38 test snapd[628]: AppArmor status: apparmor is enabled and all features are available
        vagrant@test:~$ 

***

6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

        root@AlexPC:/home/alex# ls -l > /dev/tty1
        root@AlexPC:/home/alex#
        Данный можно увидеть переключившись в соотвествующий терминал (TTY). В данном случае CTRL+ALT+F1

***

7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?
         
        vagrant@test:~$ ps -a
        PID TTY          TIME CMD
        1130 pts/0    00:00:00 ps
        vagrant@test:~$ echo $$
        1093
        vagrant@test:~$ ls -lah /proc/$$/fd/
        total 0
        dr-x------ 2 vagrant vagrant  0 Jan 16 19:44 .
        dr-xr-xr-x 9 vagrant vagrant  0 Jan 16 19:44 ..
        lrwx------ 1 vagrant vagrant 64 Jan 16 19:44 0 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 19:44 1 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 19:44 2 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 19:55 255 -> /dev/pts/0
        vagrant@test:~$ bash 5>&1
        vagrant@test:~$ echo $$
        1134
        vagrant@test:~$ ls -lah /proc/$$/fd/
        total 0
        dr-x------ 2 vagrant vagrant  0 Jan 16 19:56 .
        dr-xr-xr-x 9 vagrant vagrant  0 Jan 16 19:56 ..
        lrwx------ 1 vagrant vagrant 64 Jan 16 19:56 0 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 19:56 1 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 19:56 2 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 19:56 255 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 19:56 5 -> /dev/pts/0
        vagrant@test:~$ 
        Добавляет новый файл дескриптор "5"
          
        vagrant@test:/proc/23290/fd$ cd 
        vagrant@test:~$ echo netology > /proc/$$/fd/5
        netology
        vagrant@test:~$ $$
        bash: 23290: command not found
        vagrant@test:~$ ls -l /proc/$$/fd/
        total 0
        lrwx------ 1 vagrant vagrant 64 Jan 16 16:29 0 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 16:29 1 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 16:29 2 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 16:29 255 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 16 16:28 5 -> /dev/pts/0
        vagrant@test:~$ 

***

8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе

        vagrant@test:~$ cat test.sh 
        #!/bin/sh
        rm error.log
        for dir in `ls /`
        do
        echo Directory[$dir] files: `ls /$dir 2>>error.log | wc -l`
        done
        vagrant@test:~$ ./test.sh 
        Directory[bin] objects: 992
        Directory[boot] objects: 10
        Directory[cdrom] objects: 0
        Directory[dev] objects: 197
        Directory[etc] objects: 179
        Directory[home] objects: 1
        Directory[lib] objects: 96
        Directory[lib32] objects: 0
        Directory[lib64] objects: 1
        Directory[libx32] objects: 0
        Directory[lost+found] objects: 0
        Directory[media] objects: 0
        Directory[mnt] objects: 0
        Directory[opt] objects: 1
        Directory[proc] objects: 168
        Directory[root] objects: 0
        Directory[run] objects: 42
        Directory[sbin] objects: 405
        Directory[snap] objects: 6
        Directory[srv] objects: 0
        Directory[swap.img] objects: 1
        Directory[sys] objects: 11
        Directory[tmp] objects: 6
        Directory[usr] objects: 13
        Directory[vagrant] objects: 2
        Directory[var] objects: 13
        vagrant@test:~$ cat error.log 
        ls: cannot open directory '/lost+found': Permission denied
        ls: cannot open directory '/root': Permission denied
        vagrant@test:~$ 

***

9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?

        vagrant@test:~$ env

***

10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe

        /proc/PID/cmdline этот файл содержит команду, которая первоначально запустила процесс
        /proc/PID/exe ссылка на оригинальный исполняемый файл, если он ещё существует

***

11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo

        vagrant@test:~$ cat /proc/cpuinfo | grep flags
        flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid tsc_known_freq pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm cr8_legacy abm sse4a misalignsse 3dnowprefetch vmmcall fsgsbase avx2 invpcid rdseed clflushopt arat
        vagrant@test:~$ 

***

12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно подтвердить командой tty, которая упоминалась в лекции 3.2. Однако:

        vagrant@test:~$ tty
        /dev/pts/0
        vagrant@test:~$ ssh localhost -t 'tty'
        vagrant@localhost's password: 
        /dev/pts/1
        Connection to localhost closed.
        vagrant@test:~$
        По умолчанию, когда вы запускаете команду на удаленном компьютере с помощью ssh, для удаленного сеанса не выделяется TTY

***

13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.

        vagrant@test:~$ ps -a
        PID TTY          TIME CMD
        987 pts/0    00:00:00 ps
        vagrant@test:~$ tty
        /dev/pts/0
        vagrant@test:~$ ping localhost
        PING localhost (127.0.0.1) 56(84) bytes of data.
        64 bytes from localhost (127.0.0.1): icmp_seq=1 ttl=64 time=0.028 ms
        ^Z
        [1]+  Stopped                 ping localhost
        vagrant@test:~$ jobs -l
        [1]+   989 Stopped                 ping localhost
        vagrant@test:~$ disown 989
        -bash: warning: deleting stopped job 1 with process group 989
        vagrant@test:~$ screen
        [screen is terminating]
        vagrant@test:~$ 
        vagrant@test:~$ 64 bytes from localhost (127.0.0.1): icmp_seq=5 ttl=64 time=0.019 ms
        vagrant@test:~$ 64 bytes from localhost (127.0.0.1): icmp_seq=6 ttl=64 time=0.016 ms
        vagrant@test:~$ 64 bytes from localhost (127.0.0.1): icmp_seq=7 ttl=64 time=0.021 ms
        vagrant@test:~$ 64 bytes from localhost (127.0.0.1): icmp_seq=10 ttl=64 time=0.025 ms
        vagrant@test:~$ PS -a
        PID TTY          TIME CMD
        989 pts/0    00:00:00 ping
        991 pts/0    00:00:00 screen
        1001 pts/1    00:00:00 ps
        vagrant@test:~$ tty
        /dev/pts/1
        vagrant@test:~$ 

***

14. sudo echo string > /root/new_file не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.

        vagrant@test:~$ tee --help
        Usage: tee [OPTION]... [FILE]...
        Copy standard input to each FILE, and also to standard output.
        В данном случае копирование будет осуществляться от имени супер пользователя в отличии от первого варианта

      