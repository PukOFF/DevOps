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
9.  Переработайте playbook на использование roles. Не забудьте про зависимости lighthouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответ приведите ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---
