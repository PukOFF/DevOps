Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"
1. Установите Bitwarden плагин для браузера. Зарегестрируйтесь и сохраните несколько паролей.

[Bitwarden](https://github.com/PukOFF/DevOps/blob/main/Linux/bitwarden.png)

***

2. Установите Google authenticator на мобильный телефон. Настройте вход в Bitwarden акаунт через Google authenticator OTP.

[Bitwarden_2FA](https://github.com/PukOFF/DevOps/blob/main/Linux/Bitwarden_2FA.png)

***

3. Установите apache2, сгенерируйте самоподписанный сертификат, настройте тестовый сайт для работы по HTTPS.

```bash
alex@AlexPC:~/Vagrant$ cat /etc/apache2/sites-available/security.conf 
<VirtualHost *:443>
    ServerName 127.0.0.1
    DocumentRoot /var/www/security.com
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>
```
```html
alex@AlexPC:~/Vagrant$ curl -k https://127.0.0.1
<h1>It worked</h1>
alex@AlexPC:~/Vagrant$ 
```

***

4. Проверьте на TLS уязвимости произвольный сайт в интернете (кроме сайтов МВД, ФСБ, МинОбр, НацБанк, РосКосмос, РосАтом, РосНАНО и любых госкомпаний, объектов КИИ, ВПК ... и тому подобное).

```bash
vagrant@dev:~/testssl.sh$ ./testssl.sh -U --sneaky https://www.mgts.ru

 Start 2022-03-14 19:03:21        -->> 195.178.108.240:443 (www.mgts.ru) <<--

 rDNS (195.178.108.240): --
 Service detected:       HTTP


 Testing vulnerabilities 

 Heartbleed (CVE-2014-0160)                not vulnerable (OK), no heartbeat extension
 CCS (CVE-2014-0224)                       not vulnerable (OK)
 Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK), no session ticket extension
 ROBOT                                     not vulnerable (OK)
 Secure Renegotiation (RFC 5746)           supported (OK)
 Secure Client-Initiated Renegotiation     VULNERABLE (NOT ok), DoS threat (6 attempts)
 CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
 BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
 POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
 TLS_FALLBACK_SCSV (RFC 7507)              No fallback possible (OK), no protocol below TLS 1.2 offered
 SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
 FREAK (CVE-2015-0204)                     not vulnerable (OK)
 DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                           make sure you don't use this certificate elsewhere with SSLv2 enabled services
                                           https://censys.io/ipv4?q=07C7B2E18F4720D00179805BAE36CFF442CC0E0A2F107D015FC2554A9927A554 could help you to find out
 LOGJAM (CVE-2015-4000), experimental      not vulnerable (OK): no DH EXPORT ciphers, no common prime detected
 BEAST (CVE-2011-3389)                     not vulnerable (OK), no SSL3 or TLS1
 LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
 Winshock (CVE-2014-6321), experimental    not vulnerable (OK)
 RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)


 Done 2022-03-14 19:03:54 [  34s] -->> 195.178.108.240:443 (www.mgts.ru) <<--
```

5. Установите на Ubuntu ssh сервер, сгенерируйте новый приватный ключ. Скопируйте свой публичный ключ на другой сервер. Подключитесь к серверу по SSH-ключу.

```bash
alex@AlexPC:~/Vagrant$ ssh-keygen 
Generating public/private rsa key pair.
Enter file in which to save the key (/home/alex/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/alex/.ssh/id_rsa
Your public key has been saved in /home/alex/.ssh/id_rsa.pub
The key fingerprint is:
SHA256:qVj+eJVWXqJt7mjz1UdZ3Q7VFii7MKPKBopD6+3KayM alex@AlexPC
The key's randomart image is:
+---[RSA 3072]----+
|              ..+|
|           . . .=|
|            o ..+|
|         = .o .oo|
|      . S +*.o .o|
| . . + o  =.+  o |
|o o + +  o o  . o|
|E=.  + o. o...  .|
|+*=o. .....+o    |
+----[SHA256]-----+
alex@AlexPC:~/Vagrant$ ssh-copy-id ubuntu@192.168.1.5
The authenticity of host '192.168.1.5 (192.168.1.5)' can't be established.
ECDSA key fingerprint is SHA256:DAVRStBkycyFSaOQJEH/uwbbI2uZEynsTuDr4EKNfIE.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
ubuntu@192.168.1.5's password: 

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'ubuntu@192.168.1.5'"
and check to make sure that only the key(s) you wanted were added.

alex@AlexPC:~/Vagrant$ ssh ubuntu@192.168.1.5
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-1055-raspi aarch64)
  System load:            0.06
  Usage of /:             4.8% of 58.38GB
  Memory usage:           22%
  Swap usage:             0%
  Temperature:            54.8 C
  Processes:              139
  Users logged in:        0
ubuntu@ubuntu:~$ 
```

***

6. Переименуйте файлы ключей из задания 5. Настройте файл конфигурации SSH клиента, так чтобы вход на удаленный сервер осуществлялся по имени сервера.

```bash
alex@AlexPC:~/Vagrant$ cat ~/.ssh/config 
Host raspberry
	Hostname 192.168.1.5
	User ubuntu
	IdentityFile ~/.ssh/id_rsa
	Protocol 2
alex@AlexPC:~/Vagrant$ ssh raspberry
Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-1055-raspi aarch64)
  System load:            0.15
  Usage of /:             4.8% of 58.38GB
  Memory usage:           22%
  Swap usage:             0%
  Temperature:            55.3 C
  Processes:              138
  Users logged in:        0
ubuntu@ubuntu:~$ 
```

***

7. Соберите дамп трафика утилитой tcpdump в формате pcap, 100 пакетов. Откройте файл pcap в Wireshark.

```bash
alex@AlexPC:~/Vagrant$ sudo tcpdump -i wlp3s0 -c 100 -w dump.pcap
tcpdump: listening on wlp3s0, link-type EN10MB (Ethernet), capture size 262144 bytes
100 packets captured
113 packets received by filter
0 packets dropped by kernel
alex@AlexPC:~/Vagrant$
```

[Dump](https://github.com/PukOFF/DevOps/blob/main/Linux/dump.png)

***


Задание для самостоятельной отработки (необязательно к выполнению)
8*. Просканируйте хост scanme.nmap.org. Какие сервисы запущены?

9*. Установите и настройте фаервол ufw на web-сервер из задания 3. Откройте доступ снаружи только к портам 22,80,443
