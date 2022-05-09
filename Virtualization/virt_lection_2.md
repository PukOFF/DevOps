# Домашнее задание к занятию "5.2. Применение принципов IaaC в работе с виртуальными машинами"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате учебной группы.

---

## Задача 1

- Опишите своими словами основные преимущества применения на практике IaaC паттернов.

    * Скорость создания среды для разработчиков;
    * Минимизация риска возникновения чловеческой ошибки;
    * Эффективное использование ресурсов.


- Какой из принципов IaaC является основополагающим?

    Идемпотентность - это свойство, которое позволяет избежать повторного выполнения операции если она была выполнена ранее.

***

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
    
    * Нет необходимости устанавливать агентское ПО на конечные устройства для их управления. Управление осуществляется на посредством протокола SSH;

- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный push или pull?

    * Выбор метода зависит от инфраструктуры:
      * Если инфраструктура обеспечена стабильными каналами связи и конечные устройства поддерживают ssh - push;
      * Если, например, есть нестабильные каналы связи, то лучше использовать метод pull, чтобы при появлении связи удаленные устройства сами стучались на сервер.

***

## Задача 3

Установить на личный компьютер:

- VirtualBox
- Vagrant
- Ansible

*Приложить вывод команд установленных версий каждой из программ, оформленный в markdown.*

```bash
alex@AlexPC:~/Vagrant$ vboxmanage -v
6.1.32_Ubuntur149290

alex@AlexPC:~/Vagrant$ vagrant -v
Vagrant 2.2.6

alex@AlexPC:~/Vagrant$ ansible --version
ansible [core 2.12.4]
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/alex/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  ansible collection location = /home/alex/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Mar 15 2022, 12:22:08) [GCC 9.4.0]
  jinja version = 2.10.1
  libyaml = True

alex@AlexPC:~/Vagrant$ 
```

***

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

- Создать виртуальную машину.
- Зайти внутрь ВМ, убедиться, что Docker установлен с помощью команды

```
docker ps
```

```bash
alex@AlexPC:~/Vagrant$ vagrant up
Bringing machine 'server1.netology' up with 'virtualbox' provider...
==> server1.netology: Clearing any previously set forwarded ports...
==> server1.netology: Clearing any previously set network interfaces...
==> server1.netology: Preparing network interfaces based on configuration...
    server1.netology: Adapter 1: nat
==> server1.netology: Forwarding ports...
    server1.netology: 22 (guest) => 20011 (host) (adapter 1)
    server1.netology: 22 (guest) => 2222 (host) (adapter 1)
==> server1.netology: Running 'pre-boot' VM customizations...
==> server1.netology: Booting VM...
==> server1.netology: Waiting for machine to boot. This may take a few minutes...
    server1.netology: SSH address: 127.0.0.1:2222
    server1.netology: SSH username: vagrant
    server1.netology: SSH auth method: private key
==> server1.netology: Machine booted and ready!
==> server1.netology: Checking for guest additions in VM...
==> server1.netology: Setting hostname...
==> server1.netology: Mounting shared folders...
    server1.netology: /vagrant => /home/alex/Vagrant
==> server1.netology: Running provisioner: ansible...
    server1.netology: Running ansible-playbook...

PLAY [nodes] *******************************************************************

TASK [Gathering Facts] *********************************************************
ok: [server1.netology]

TASK [Create directory for ssh-keys] *******************************************
ok: [server1.netology]

TASK [Adding rsa-key in /root/.ssh/authorized_keys] ****************************
ok: [server1.netology]

TASK [Checking DNS] ************************************************************
changed: [server1.netology]

TASK [Installing tools] ********************************************************
ok: [server1.netology] => (item=git)
ok: [server1.netology] => (item=curl)

TASK [Installing docker] *******************************************************
changed: [server1.netology]

TASK [Add the current user to docker group] ************************************
ok: [server1.netology]

PLAY RECAP *********************************************************************
server1.netology           : ok=7    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0  


alex@AlexPC:~/Vagrant$ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon 09 May 2022 12:52:53 PM UTC

  System load:  0.0                Processes:                111
  Usage of /:   13.9% of 30.88GB   Users logged in:          0
  Memory usage: 22%                IPv4 address for docker0: 172.17.0.1
  Swap usage:   0%                 IPv4 address for eth0:    10.0.2.15


This system is built by the Bento project by Chef Software
More information can be found at https://github.com/chef/bento
Last login: Mon May  9 12:48:42 2022 from 10.0.2.2
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ docker --version
Docker version 20.10.15, build fd82621
vagrant@server1:~$ 
```