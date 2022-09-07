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

**В данном задании не получается разорхивировать архив на managed ноды. Пробовал через копирование и модуль command**

```yaml
TASK [Unarchive vector on managed hosts] ***************************************************************************************************************************************
fatal: [ub]: FAILED! => {"changed": false, "cmd": "'tar -zxvf ./vector/vector-0.24.0-x86_64-unknown-linux-gnu.tar.gz'", "msg": "[Errno 2] No such file or directory: b'tar -zxvf ./vector/vector-0.24.0-x86_64-unknown-linux-gnu.tar.gz'", "rc": 2, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
fatal: [el]: FAILED! => {"changed": false, "cmd": "'tar -zxvf ./vector/vector-0.24.0-x86_64-unknown-linux-gnu.tar.gz'", "msg": "[Errno 2] Нет такого файла или каталога", "rc": 2, "stderr": "", "stderr_lines": [], "stdout": "", "stdout_lines": []}
```


---
```yaml
  - name: Download Archive
      get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/{{ name_archive }}"
        dest: "files/{{ name_archive }}"
      # выполнение задачи на первом хосте и дальнейшее применение результатов на последующих
      run_once: true
      # делегировать выполнение task на localhost
      delegate_to: localhost
      notify: handlers
#    - name: Install untar
#      become: true
#      package:
#        name: tar
#        state: present
  tasks:
    - name: Create Directory
      file:
        path: ./vector/
        state: directory
    - name: Copy Archive
      copy:
        src: "files/{{ name_archive }}"
        dest: ./vector/
    - name: Unarchive vector on managed hosts
      unarchive:
        src: "./vector/{{ name_archive }}"
        dest: ./vector/
      notify: second
  post_tasks:
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

**При выполнении возникает ошибка, что не удалось подключиться к базе данных. Хотя судя по логу handler отрабатывает**

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

**Playbook оотрабатывает корректно, но архив не распаковывает на managed нодах**

---
```yaml
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ ansible-playbook -i inventory/prod.yml examp.yml --diff

PLAY [Get archive] *************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Download Archive] ********************************************************************************************************************************************************
ok: [el -> localhost]

TASK [Create Directory] ********************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Copy Archive] ************************************************************************************************************************************************************
ok: [ub]
ok: [el]

TASK [Unarchive vector on managed hosts] ***************************************************************************************************************************************
fatal: [ub]: FAILED! => {"changed": false, "msg": "Failed to find handler for \"/home/lex/.ansible/tmp/ansible-tmp-1662587393.6665561-318553-143074424667274/source\". Make sure the required command to extract the file is installed. Command \"/usr/bin/tar\" could not handle archive. Unable to find required 'unzip' or 'zipinfo' binary in the path."}
fatal: [el]: FAILED! => {"changed": false, "msg": "Failed to find handler for \"/home/lex/.ansible/tmp/ansible-tmp-1662587393.666445-318552-219652579303334/source\". Make sure the required command to extract the file is installed. Command \"/usr/bin/unzip\" could not handle archive. Command \"/usr/bin/gtar\" could not handle archive."}

PLAY RECAP *********************************************************************************************************************************************************************
el                         : ok=4    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   
ub                         : ok=3    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0   

alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ ansible-playbook -i inventory/prod.yml examp.yml --diff

PLAY [Get archive] *************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Download Archive] ********************************************************************************************************************************************************
ok: [el -> localhost]

TASK [Create Directory] ********************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Copy Archive] ************************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Unarchive vector on managed hosts] ***************************************************************************************************************************************
ok: [ub]
ok: [el]

TASK [Template it] *************************************************************************************************************************************************************
--- before: ./vector/vector.cfg
+++ after: /home/alex/.ansible/tmp/ansible-local-319027yz6thx6o/tmpwky8bf6u/vector.cfg.j2
@@ -1,4 +1,3 @@
 Абсолютно любой текст
 У меня вектор версии 0.24.0
 Test message
-PukOFF
\ No newline at end of file

changed: [el]
--- before: ./vector/vector.cfg
+++ after: /home/alex/.ansible/tmp/ansible-local-319027yz6thx6o/tmp4ecbtb9_/vector.cfg.j2
@@ -1,4 +1,3 @@
 Абсолютно любой текст
 У меня вектор версии 0.24.0
 Test message
-PukOFF
\ No newline at end of file

changed: [ub]

PLAY RECAP *********************************************************************************************************************************************************************
el                         : ok=6    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ub                         : ok=5    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$
```
---



8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

---
```yaml
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$ ansible-playbook -i inventory/prod.yml examp.yml --diff

PLAY [Get archive] *************************************************************************************************************************************************************

TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Download Archive] ********************************************************************************************************************************************************
ok: [el -> localhost]

TASK [Create Directory] ********************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Copy Archive] ************************************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Unarchive vector on managed hosts] ***************************************************************************************************************************************
ok: [el]
ok: [ub]

TASK [Template it] *************************************************************************************************************************************************************
ok: [el]
ok: [ub]

PLAY RECAP *********************************************************************************************************************************************************************
el                         : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ub                         : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-02-playbook/playbook$
```
---

9.  Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.


