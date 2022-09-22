# Домашнее задание к занятию "8.4 Работа с Roles"

## Подготовка к выполнению
1. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
2. Добавьте публичную часть своего ключа к своему профилю в github.

## Основная часть

Наша основная цель - разбить наш playbook на отдельные roles. Задача: сделать roles для clickhouse, vector и lighthouse и написать playbook для использования этих ролей. Ожидаемый результат: существуют три ваших репозитория: два с roles и один с playbook.

1. Создать в старой версии playbook файл `requirements.yml` и заполнить его следующим содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачать себе эту роль.
3. Создать новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
---
```bash
alex@alexPC/DevOps/CI/08-ansible-03-role/roles/:~$ ansible-galaxy role init vector
- Role lighthouse was created successfully

alex@alexPC:~/DevOps/CI/08-ansible-03-role/roles$ ls -l
total 12
drwxrwxr-x 10 alex alex 4096 сен 22 22:53 clickhouse
drwxrwxr-x 10 alex alex 4096 сен 22 22:53 lighthouse
drwxrwxr-x 10 alex alex 4096 сен 22 22:53 vector
alex@alexPC:~/DevOps/CI/08-ansible-03-role/roles$ 
```
---
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`.

---
```yaml
alex@alexPC:~/DevOps/CI/08-ansible-03-role$ cat roles/vector/vars/main.yml 
---
vector_url: https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm
vector_version: 0.21.1

alex@alexPC:~/DevOps/CI/08-ansible-03-role$
```

```yaml
alex@alexPC:~/DevOps/CI/08-ansible-03-role$ cat roles/vector/defaults/main.yml 
---
vector_config:
  sources:
    our_log:
      type: file
      ignore_older_secs: 600
      include:
        - /home/alex/logs/*.log
      read_from: beginning
  sinks:
    to_clickhouse:
      type: clickhouse
      inputs:
        - our_log
      database: custom
      endpoint: http://62.84.121.235:8123
      table: my_table
      compression: gzip
      healthcheck: false
      skip_unknown_fields: true
alex@alexPC:~/DevOps/CI/08-ansible-03-role$
```
---

5. Перенести нужные шаблоны конфигов в `templates`.

---
```yaml
alex@alexPC:~/DevOps/CI/08-ansible-03-role$ cat roles/vector/templates/vector.yml.j2 
{{ vector_config | to_nice_yaml }}
alex@alexPC:~/DevOps/CI/08-ansible-03-role$ cat roles/vector/templates/vector.service.j2 
[Unit]
Description=Vector service
After=network.target
Requires=network-online.target
[Service]
User=root
Group=root
ExecStart=/usr/bin/vector --config-yaml vector.yml --watch-config
Restart=always
[Install]
WantedBy=multi-user.target
alex@alexPC:~/DevOps/CI/08-ansible-03-role$
```
---

6. Описать в `README.md` обе роли и их параметры.
7. Повторите шаги 3-6 для lighthouse. Помните, что одна роль должна настраивать один продукт.

---
```yaml
alex@alexPC:~/DevOps/CI/08-ansible-03-role$ cat roles/lighthouse/tasks/main.yml 
---
- name: Add nginx task
  import_tasks: install/nginx.yml

- name: Add lighthouse task
  import_tasks: install/lighthouse.yml

alex@alexPC:~/DevOps/CI/08-ansible-03-role$
```
---

8. Выложите все roles в репозитории. Проставьте тэги, используя семантическую нумерацию Добавьте roles в `requirements.yml` в playbook.
   
---
```bash
alex@alexPC:~/DevOps/CI/08-ansible-03-role$ ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- extracting clickhouse to /home/alex/DevOps/CI/08-ansible-03-role/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
- extracting cighthouse to /home/alex/DevOps/CI/08-ansible-03-role/roles/cighthouse
- cighthouse (1.0.0) was installed successfully
- extracting vector to /home/alex/DevOps/CI/08-ansible-03-role/roles/vector
- vector (1.0.0) was installed successfully
alex@alexPC:~/DevOps/CI/08-ansible-03-role$
```
---

9.  Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.

---
```yaml
alex@alexPC:~/DevOps/CI/08-ansible-03-role$ cat site_roles.yml 
---
- name: Install Clickhouse
  hosts: clickhouse
  roles:
    - clickhouse

- name: Install Lighthouse
  hosts: lighthouse
  roles:
    - lighthouse
- name: Install Vector
  hosts: vector
  roles:
    - vector
alex@alexPC:~/DevOps/CI/08-ansible-03-role$ D
```
---

10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---
```yaml
alex@alexPC:~/DevOps/CI/08-ansible-03-role$ ansible-playbook -i inventory/prod.yml site_roles.yml 

PLAY [Install Clickhouse] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Include OS Family Specific Variables] ********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************************************************
included: /home/alex/DevOps/CI/08-ansible-03-role/roles/clickhouse/tasks/precheck.yml for clickhouse-01

TASK [clickhouse : Requirements check | Checking sse4_2 support] ************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Requirements check | Not supported distribution && release] **********************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************************************************
included: /home/alex/DevOps/CI/08-ansible-03-role/roles/clickhouse/tasks/params.yml for clickhouse-01

TASK [clickhouse : Set clickhouse_service_enable] ***************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Set clickhouse_service_ensure] ***************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************************************************
included: /home/alex/DevOps/CI/08-ansible-03-role/roles/clickhouse/tasks/install/yum.yml for clickhouse-01

TASK [clickhouse : Install by YUM | Ensure clickhouse repo GPG key imported] ************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse repo installed] *******************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (latest)] *******************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Install by YUM | Ensure clickhouse package installed (version 22.3.3.44)] ********************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************************************************
included: /home/alex/DevOps/CI/08-ansible-03-role/roles/clickhouse/tasks/configure/sys.yml for clickhouse-01

TASK [clickhouse : Check clickhouse config, data and logs] ******************************************************************************************************************************************
ok: [clickhouse-01] => (item=/var/log/clickhouse-server)
changed: [clickhouse-01] => (item=/etc/clickhouse-server)
changed: [clickhouse-01] => (item=/var/lib/clickhouse/tmp/)
changed: [clickhouse-01] => (item=/var/lib/clickhouse/)

TASK [clickhouse : Config | Create config.d folder] *************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Create users.d folder] **************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Generate system config] *************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Generate users config] **************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Config | Generate remote_servers config] *****************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate macros config] *************************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Generate zookeeper servers config] **************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Config | Fix interserver_http_port and intersever_https_port collision] **********************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : Notify Handlers Now] *************************************************************************************************************************************************************

RUNNING HANDLER [clickhouse : Restart Clickhouse Service] *******************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************************************************
included: /home/alex/DevOps/CI/08-ansible-03-role/roles/clickhouse/tasks/service.yml for clickhouse-01

TASK [clickhouse : Ensure clickhouse-server.service is enabled: True and state: restarted] **********************************************************************************************************
changed: [clickhouse-01]

TASK [clickhouse : Wait for Clickhouse Server to Become Ready] **************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************************************************
included: /home/alex/DevOps/CI/08-ansible-03-role/roles/clickhouse/tasks/configure/db.yml for clickhouse-01

TASK [clickhouse : Set ClickHose Connection String] *************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Gather list of existing databases] ***********************************************************************************************************************************************
ok: [clickhouse-01]

TASK [clickhouse : Config | Delete database config] *************************************************************************************************************************************************

TASK [clickhouse : Config | Create database config] *************************************************************************************************************************************************

TASK [clickhouse : include_tasks] *******************************************************************************************************************************************************************
included: /home/alex/DevOps/CI/08-ansible-03-role/roles/clickhouse/tasks/configure/dict.yml for clickhouse-01

TASK [clickhouse : Config | Generate dictionary config] *********************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [clickhouse : include_tasks] *******************************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Lighthouse] ***************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [lighthouse : NGINX | Install epel-release] ****************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse : NGINX | Install NGINX] ***********************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse : NGINX | Create Config] ***********************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse : Lighthouse | Install Git] ********************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse : Lighthouse | Copy from github] ***************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [lighthouse : Lighthouse | Create lighthouse vector_config] ************************************************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [lighthouse : start-nginx] **********************************************************************************************************************************************************
changed: [lighthouse-01]

RUNNING HANDLER [lighthouse : reload-nginx] *********************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY [Install Vector] *******************************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************************
ok: [vector-01]

TASK [vector : Install Vector] **********************************************************************************************************************************************************************
changed: [vector-01]

TASK [vector : Configure Vector] ********************************************************************************************************************************************************************
included: /home/alex/DevOps/CI/08-ansible-03-role/roles/vector/tasks/configure.yml for vector-01

TASK [vector : Vector | Template Config] ************************************************************************************************************************************************************
changed: [vector-01]

TASK [vector : Vector | Create systemd unit] ********************************************************************************************************************************************************
changed: [vector-01]

TASK [vector : Vector | Start Service] **************************************************************************************************************************************************************
changed: [vector-01]

PLAY RECAP ******************************************************************************************************************************************************************************************
clickhouse-01              : ok=25   changed=9    unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
lighthouse-01              : ok=9    changed=8    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=6    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

alex@alexPC:~/DevOps/CI/08-ansible-03-role$ 
```
---

---
