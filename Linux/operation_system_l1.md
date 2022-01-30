# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`,
поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`.
В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который
относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.
    ```bash
    vagrant@test:~$ strace /bin/bash -c 'cd /tmp' 2>&1 | grep /tmp
    execve("/bin/bash", ["/bin/bash", "-c", "cd /tmp"], 0x7ffc12653730 /* 23 vars */) = 0
    stat("/tmp", {st_mode=S_IFDIR|S_ISVTX|0777, st_size=4096, ...}) = 0
    chdir("/tmp")                           = 0
    vagrant@test:~$
    ```
***

2. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. 
Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.
    ```bash
    vagrant@test:~$ file /etc/passwd
    /etc/passwd: ASCII text
    vagrant@test:~$ file /bin/sh
    /bin/sh: symbolic link to dash
    vagrant@test:~$ file /bin/cp
    /bin/cp: ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=421e1abd8faf1cb290df755a558377c5d7def3b1, for GNU/Linux 3.2.0, stripped
    vagrant@test:~$ 
     ```
     ***
     ```bash
     vagrant@test:~$ strace file 2>&1 | grep openat
    openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libmagic.so.1", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/liblzma.so.5", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libbz2.so.1.0", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libz.so.1", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
    openat(AT_FDCWD, "/etc/magic.mgc", O_RDONLY) = -1 ENOENT (No such file or directory)
    openat(AT_FDCWD, "/etc/magic", O_RDONLY) = 3
    openat(AT_FDCWD, "/usr/share/misc/magic.mgc", O_RDONLY) = 3
    vagrant@test:~$ cat /etc/magic
    # Magic local data for file(1) command.
    # Insert here your local magic data. Format is described in magic(5).
    
    vagrant@test:~$ cat /usr/share/misc/magic.mgc | wc -l
    2805
    vagrant@test:~$ 
    #База данных находится в файле /usr/share/misc/magic.mgc
     ```
***
    
3. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).
    ```bash
    vagrant@test:~$ ping 127.0.0.1 > test.log &
    [1] 1261
    vagrant@test:~$ lsof -p 1261
    COMMAND  PID    USER   FD      TYPE DEVICE SIZE/OFF NODE NAME
    ping    1261 vagrant  cwd   unknown                      /proc/1261/cwd (readlink: Permission denied)
    ping    1261 vagrant  rtd   unknown                      /proc/1261/root (readlink: Permission denied)
    ping    1261 vagrant  txt   unknown                      /proc/1261/exe (readlink: Permission denied)
    ping    1261 vagrant NOFD                                /proc/1261/fd (opendir: Permission denied)
    vagrant@test:~$ sudo lsof -p 1261 | grep test.log
    ping    1261 vagrant    1w   REG  253,0     2882 1048606 /home/vagrant/test.log
    vagrant@test:~$ sudo ls -l /proc/1261/fd/
    total 0
    lrwx------ 1 root root 64 Jan 30 19:58 0 -> /dev/pts/0
    l-wx------ 1 root root 64 Jan 30 19:58 1 -> /home/vagrant/test.log
    lrwx------ 1 root root 64 Jan 30 19:58 2 -> /dev/pts/0
    lrwx------ 1 root root 64 Jan 30 19:58 3 -> 'socket:[27982]'
    lrwx------ 1 root root 64 Jan 30 19:58 4 -> 'socket:[27983]'
    vagrant@test:~$ 
    ```
***

4 Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?
    Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом

***

5 В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```

    ***
    
    ```bash
    vagrant@test:~$ sudo -s
    root@test:/home/vagrant# timeout 5 opensnoop-bpfcc
    PID    COMM               FD ERR PATH
    889    vminfo              4   0 /var/run/utmp
    621    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
    621    dbus-daemon        19   0 /usr/share/dbus-1/system-services
    621    dbus-daemon        -1   2 /lib/dbus-1/system-services
    621    dbus-daemon        19   0 /var/lib/snapd/dbus-1/system-services/
    root@test:/home/vagrant# 
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

***

6. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.
    ```bash
    vagrant@test:~$ strace -e trace=write uname -a
    write(1, "Linux test 5.4.0-91-generic #102"..., 103Linux test 5.4.0-91-generic #102-Ubuntu SMP Fri Nov 5 16:31:28 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
    ) = 103
    +++ exited with 0 +++
    vagrant@test:~$ 
    ```
    Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}

***

7 Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    
    root@netology1:~# test -d /tmp/some_dir; echo Hi - комнады выполняются независимо.
    root@netology1:~# test -d /tmp/some_dir && echo Hi - вторая команда выполнится только в случае успешного результат первой команды
    
    vagrant@test:~$ ls /root ; ls /home
    ls: cannot open directory '/root': Permission denied
    vagrant
    vagrant@test:~$ ls /root && ls /home
    ls: cannot open directory '/root': Permission denied
    vagrant@test:~$
    
    Есть ли смысл использовать в bash `&&`, если применить `set -e`?
    Нет.
    
    set -e - Выйти немедленно, если команда завершается с ненулевым статусом
    ```

***

8. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?
    
    ```bash
    set -euxo pipefail
        -e Выйти немедленно, если команда завершается с ненулевым статусом
        -u Рассматривать неустановленные переменные как ошибку при замене
        -o Статусом выхода из конвейера, в том случае, если не включена опция pipefail, служит статус завершения последней команды конвейера. Если опция pipefail включена — статус выхода из конвейера является значением последней (самой правой) команды, завершённой с ненулевым статусом, или ноль — если работа всех команд завершена успешно
        -x Печатать команды и их аргументы по мере их выполнения.
    ```
    Для лучшего контроля выполнения сценариев при множественном использовании конверееров
    
***

9. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).
    
    * < - высокоприоритетный
    * N - с низким приоритетом
    * L - имеет страницы, заблокированные в памяти
    * s - является лидером сеанса
    * l - является многопоточным
    * '+' - находится в группе процессов переднего плана

    ```bash
    root@test:/home/vagrant# ps aux | grep S | wc -l
    63
    root@test:/home/vagrant# ps aux | grep R | wc -l
    3
    root@test:/home/vagrant# ps aux | grep D | wc -l
    3
    root@test:/home/vagrant# 
    ```
    
