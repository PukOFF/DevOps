# Домашнее задание к занятию "3.6. Компьютерные сети, лекция 1"

1. Работа c HTTP через телнет.
- Подключитесь утилитой телнет к сайту stackoverflow.com
`telnet stackoverflow.com 80`
- отправьте HTTP запрос
```bash
GET /questions HTTP/1.0
HOST: stackoverflow.com
[press enter]
[press enter]
```
```bashHTTP/1.1 301 Moved Permanently
cache-control: no-cache, no-store, must-revalidate
location: https://stackoverflow.com/questions
x-request-guid: 3a73b602-de06-4a6e-aced-73b00f90913b
feature-policy: microphone 'none'; speaker 'none'
content-security-policy: upgrade-insecure-requests; frame-ancestors 'self' https://stackexchange.com
Accept-Ranges: bytes
Date: Mon, 21 Feb 2022 19:11:56 GMT
Via: 1.1 varnish
Connection: close
X-Served-By: cache-fra19138-FRA
X-Cache: MISS
X-Cache-Hits: 0
X-Timer: S1645470716.313744,VS0,VE85
Vary: Fastly-SSL
X-DNS-Prefetch-Control: off
Set-Cookie: prov=af88fdcc-8111-71af-245b-e51f8f9d93cd; domain=.stackoverflow.com; expires=Fri, 01-Jan-2055 00:00:00 GMT; path=/; HttpOnly
```

- В ответе укажите полученный HTTP код, что он означает?

301 Moved Permanently — код состояния HTTP, сообщающий клиенту, что страница, 
к которой клиент обращается, перемещена по новому адресу и старый адрес следует считать устаревшим

***


2. Повторите задание 1 в браузере, используя консоль разработчика F12.
- откройте вкладку `Network`
- отправьте запрос http://stackoverflow.com
- найдите первый ответ HTTP сервера, откройте вкладку `Headers`
- укажите в ответе полученный HTTP код.

```html
GET
Scheme: https
host: stackoverflow.com
filename: /
Адрес: 151.101.1.69:443
Состояние: 200 OK
Версия: HTTP/2
Передано: 51,90 КБ (размер 173,84 КБ)
```

- проверьте время загрузки страницы, какой запрос обрабатывался дольше всего?

```html
  GET: 131 мс
```

- приложите скриншот консоли браузера в ответ.

[Скриншот](/DevOps/Linux/image.png)

***

3. Какой IP адрес у вас в интернете?

```commandline
109.252.83.247
```
***

4. Какому провайдеру принадлежит ваш IP адрес? Какой автономной системе AS? Воспользуйтесь утилитой `whois`

```commandline
Moscow City Telephone Network
```
***

5. Через какие сети проходит пакет, отправленный с вашего компьютера на адрес 8.8.8.8? Через какие AS? Воспользуйтесь утилитой `traceroute`

```bashvagrant@vagrant:~$ traceroute -An 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  10.0.2.2 [*]  0.056 ms  0.034 ms  0.034 ms
 2  192.168.1.1 [*]  103.331 ms  108.147 ms  110.691 ms
 3  100.84.0.1 [*]  114.790 ms  118.538 ms  118.528 ms
 4  212.188.1.6 [AS8359]  120.165 ms  121.162 ms  124.133 ms
 5  212.188.1.5 [AS8359]  124.071 ms * *
 6  * 195.34.53.206 [AS8359]  111.020 ms  114.664 ms
 7  212.188.29.82 [AS8359]  111.697 ms  40.872 ms  40.781 ms
 8  108.170.250.99 [AS15169]  43.739 ms 108.170.250.51 [AS15169]  40.755 ms 108.170.250.66 [AS15169]  43.712 ms
 9  142.251.49.24 [AS15169]  66.239 ms  73.659 ms *
10  172.253.65.82 [AS15169]  63.440 ms  81.754 ms 172.253.66.110 [AS15169]  66.177 ms
11  172.253.79.115 [AS15169]  79.077 ms 216.239.56.113 [AS15169]  362.698 ms 172.253.64.51 [AS15169]  360.643 ms
12  * * *
13  * * *
14  * * *
15  * * *
16  * * *
17  * * *
18  * * *
19  * * *
20  * * *
21  8.8.8.8 [AS15169]  129.970 ms  133.072 ms  144.073 ms
vagrant@vagrant:~$ 
```


6. Повторите задание 5 в утилите `mtr`. На каком участке наибольшая задержка - delay?

```bash
vagrant@vagrant:~$ mtr -znr 8.8.8.8
Start: 2022-02-21T19:52:24+0000
HOST: vagrant                     Loss%   Snt   Last   Avg  Best  Wrst StDev
  1. AS???    10.0.2.2             0.0%    10    0.1   0.1   0.1   0.1   0.0
  2. AS???    192.168.1.1          0.0%    10    3.9   3.7   2.0   9.3   2.1
  3. AS???    100.84.0.1           0.0%    10    6.9   5.6   4.4   6.9   1.0
  4. AS8359   212.188.1.6          0.0%    10    5.4   9.7   5.4  15.6   4.3
  5. AS8359   212.188.1.5         50.0%    10    7.2   8.3   5.5  10.5   2.0
  6. AS8359   195.34.53.206       30.0%    10    8.1   7.1   5.6   8.9   1.1
  7. AS8359   212.188.29.82        0.0%    10   21.8  10.5   5.4  21.8   6.6
  8. AS15169  108.170.250.83       0.0%    10    7.4  11.6   6.1  31.0   8.6
  9. AS15169  142.250.239.64      40.0%    10   38.4  24.8  21.3  38.4   6.7
 10. AS15169  172.253.66.110       0.0%    10   21.4  21.7  20.1  24.5   1.4
 11. AS15169  216.239.47.203       0.0%    10   21.6  23.4  21.6  29.4   2.3
 12. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 13. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 14. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 15. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 16. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 17. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 18. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 19. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 20. AS???    ???                 100.0    10    0.0   0.0   0.0   0.0   0.0
 21. AS15169  8.8.8.8              0.0%    10   22.2  24.7  18.1  39.3   7.7
vagrant@vagrant:~$ 

```
***

7. Какие DNS сервера отвечают за доменное имя dns.google? Какие A записи? воспользуйтесь утилитой `dig`

```bash
vagrant@vagrant:~$ dig dns.google

; <<>> DiG 9.16.1-Ubuntu <<>> dns.google
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 20836
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;dns.google.			IN	A

;; ANSWER SECTION:
dns.google.		900	IN	A	8.8.8.8
dns.google.		900	IN	A	8.8.4.4

;; Query time: 100 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Feb 21 19:48:12 UTC 2022
;; MSG SIZE  rcvd: 71

vagrant@vagrant:~$ 
```


***

8. Проверьте PTR записи для IP адресов из задания 7. Какое доменное имя привязано к IP? воспользуйтесь утилитой `dig`

```bash
vagrant@vagrant:~$ dig -x 8.8.8.8

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.8.8
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 16503
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;8.8.8.8.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
8.8.8.8.in-addr.arpa.	29	IN	PTR	dns.google.

;; Query time: 28 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Feb 21 19:50:47 UTC 2022
;; MSG SIZE  rcvd: 73

vagrant@vagrant:~$ dig -x 8.8.4.4

; <<>> DiG 9.16.1-Ubuntu <<>> -x 8.8.4.4
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 54006
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 65494
;; QUESTION SECTION:
;4.4.8.8.in-addr.arpa.		IN	PTR

;; ANSWER SECTION:
4.4.8.8.in-addr.arpa.	29	IN	PTR	dns.google.

;; Query time: 32 msec
;; SERVER: 127.0.0.53#53(127.0.0.53)
;; WHEN: Mon Feb 21 19:51:00 UTC 2022
;; MSG SIZE  rcvd: 73

vagrant@vagrant:~$ 
```
В качестве ответов на вопросы можно приложите лог выполнения команд в консоли или скриншот полученных результатов.

---