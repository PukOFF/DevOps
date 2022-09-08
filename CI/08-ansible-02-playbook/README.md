# Домашнее задание к занятию "08.02 Работа с Playbook"

## Подготовка к выполнению

1. (Необязательно) Изучите, что такое [clickhouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [vector](https://www.youtube.com/watch?v=CgEhyffisLY)
2. Создайте свой собственный (или используйте старый) публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Приготовьте свой собственный inventory файл `prod.yml`.

---
```yaml
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ cat inventory/prod.yml 
---
clickhouse:
  hosts:
    centos7:
      ansible_connection: docker
example:
  hosts:
    el:
      ansible_host: 51.250.68.41
      ansible_user: lex
    ub:
      ansible_host: 62.84.117.229
      ansible_user: lex
```
---


2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).
3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать нужной версии дистрибутив, выполнить распаковку в выбранную директорию, установить vector.

---
```yaml
  ---
- name: Get archive
  hosts: example
  pre_tasks:
    - name: Create Directory
      file:
        path: ./vector/
        state: directory
  tasks:
    - name: Download Archive
      get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/{{ name_archive }}"
        dest: "/home/lex/vector/{{ name_archive }}"
    # распаковка архива "vector" на managed нодах
    - name: Unarchive vector on managed hosts
      unarchive:
        src: "{{ src_directory }}{{ name_archive }}"
        dest: "{{ dst_directory }}"
  post_tasks:
    # формирование шаблона конфига "vector" на managed нодах
    - name: Template it
      template: 
        src: vector.cfg.j2
        dest: ./vector/vector.cfg
```
---

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

---
```t
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ ansible-lint site.yml -v
Examining site.yml of type playbook
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ 
```
---

```yaml
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ ansible-playbook -i inventory/prod.yml site.yml


PLAY [Install Clickhouse] ******************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [centos7]

TASK [Get clickhouse distrib] **************************************************************************************************************************************************
changed: [centos7] => (item=clickhouse-client)
changed: [centos7] => (item=clickhouse-server)
changed: [centos7] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] *********************************************************************************************************************************************
changed: [centos7]

TASK [Create database] *********************************************************************************************************************************************************
fatal: [centos7]: FAILED! => {"changed": false, "cmd": ["clickhouse-client", "-q", "create database logs;"], "delta": "0:00:00.100805", "end": "2022-09-07 21:45:09.933612", "failed_when_result": true, "msg": "non-zero return code", "rc": 210, "start": "2022-09-07 21:45:09.832807", "stderr": "Code: 210. DB::NetException: Connection refused (localhost:9000). (NETWORK_ERROR)", "stderr_lines": ["Code: 210. DB::NetException: Connection refused (localhost:9000). (NETWORK_ERROR)"], "stdout": "", "stdout_lines": []}

RUNNING HANDLER [Start] ********************************************************************************************************************************************************

PLAY RECAP *********************************************************************************************************************************************************************
centos7                    : ok=3    changed=2    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

---
```yaml
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] ******************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [centos7]

TASK [Get clickhouse distrib] **************************************************************************************************************************************************
ok: [centos7] => (item=clickhouse-client)
ok: [centos7] => (item=clickhouse-server)
ok: [centos7] => (item=clickhouse-common-static)

TASK [Install clickhouse packages] *********************************************************************************************************************************************
ok: [centos7]

TASK [Create database] *********************************************************************************************************************************************************
skipping: [centos7]

PLAY RECAP *********************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0   

alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$
```
---

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

---
```yaml
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ ansible-playbook -i inventory/prod.yml examp.yml

PLAY [Get archive] **********************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Create Directory] *****************************************************************************************************************************************************************************
ok: [el]
changed: [ub]

TASK [Download Archive] *****************************************************************************************************************************************************************************
ok: [el]
changed: [ub]

TASK [Unarchive vector on managed hosts] ************************************************************************************************************************************************************
ok: [el]
changed: [ub]

TASK [Template it] **********************************************************************************************************************************************************************************
ok: [el]
changed: [ub]

PLAY RECAP ******************************************************************************************************************************************************************************************
el                         : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ub                         : ok=5    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$   
```
```yaml
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ ansible-playbook -i inventory/prod.yml examp.yml --diff

PLAY [Get archive] **********************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [ub]
ok: [el]

TASK [Create Directory] *****************************************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Download Archive] *****************************************************************************************************************************************************************************
ok: [ub]
ok: [el]

TASK [Unarchive vector on managed hosts] ************************************************************************************************************************************************************
ok: [ub]
ok: [el]

TASK [Template it] **********************************************************************************************************************************************************************************
--- before: ./vector/vector.cfg
+++ after: /home/alex/.ansible/tmp/ansible-local-68659eiru5cxa/tmp3a9mcizf/vector.cfg.j2
@@ -1,3 +1,4 @@
 Абсолютно любой текст
 У меня вектор версии 0.24.0
 Test message
+PukOFF
\ No newline at end of file

changed: [ub]
--- before: ./vector/vector.cfg
+++ after: /home/alex/.ansible/tmp/ansible-local-68659eiru5cxa/tmp6b0l26h4/vector.cfg.j2
@@ -1,3 +1,4 @@
 Абсолютно любой текст
 У меня вектор версии 0.24.0
 Test message
+PukOFF
\ No newline at end of file

changed: [el]

PLAY RECAP ******************************************************************************************************************************************************************************************
el                         : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ub                         : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ 
```
---



8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

---
```yaml
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ ansible-playbook -i inventory/prod.yml examp.yml --diff

PLAY [Get archive] **********************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Create Directory] *****************************************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Download Archive] *****************************************************************************************************************************************************************************
ok: [ub]
ok: [el]

TASK [Unarchive vector on managed hosts] ************************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Template it] **********************************************************************************************************************************************************************************
ok: [el]
ok: [ub]

PLAY RECAP ******************************************************************************************************************************************************************************************
el                         : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ub                         : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$
```
---

9.  Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.


