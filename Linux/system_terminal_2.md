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
        vagrant@test:~$ ls /root 2> /dev/pts/1
        vagrant@test:~$ 
        =====================================
        vagrant@test:~$ tty
        /dev/pts/1
        vagrant@test:~$ ls: cannot open directory '/root': Permission denied

***

5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример
    
        vagrant@test:~$ ls
        stdin.txt  test.sh
        vagrant@test:~$ cat stdin.txt 
        Test Message
        vagrant@test:~$ cat < stdin.txt > stdout.txt
        vagrant@test:~$ ls
        stdin.txt  stdout.txt  test.sh
        vagrant@test:~$ cat stdout.txt 
        Test Message
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

        vagrant@test:~$ ls -l /proc/$$/fd/
        total 0
        lrwx------ 1 vagrant vagrant 64 Jan 19 20:28 0 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 19 20:28 1 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 19 20:28 2 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 19 20:28 255 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Jan 19 20:28 5 -> /dev/pts/0
        vagrant@test:~$ ls -l && test1 5>&1 1>&2 2>&5
        total 12
        -rw-rw-r-- 1 vagrant vagrant  13 Jan 19 20:11 stdin.txt
        -rw-rw-r-- 1 vagrant vagrant  13 Jan 19 20:23 stdout.txt
        -rwxrw-r-- 1 vagrant vagrant 112 Jan 16 17:35 test.sh
        bash: test1: command not found
        vagrant@test:~$ ls -l && test1 5>&1 1>&2 2>&5 | wc -l
        total 12
        -rw-rw-r-- 1 vagrant vagrant  13 Jan 19 20:11 stdin.txt
        -rw-rw-r-- 1 vagrant vagrant  13 Jan 19 20:23 stdout.txt
        -rwxrw-r-- 1 vagrant vagrant 112 Jan 16 17:35 test.sh
        1
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

      
