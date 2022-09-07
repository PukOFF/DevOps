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
        src: "files/{{ name_archive }}"
        dest: ./vector
      notify: second
  post_tasks:
    - name: Template it
      template: 
        src: vector.cfg.j2
        dest: ./vector/vector.cfg
```
---

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9.  Подготовьте README.md файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

### Как оформить ДЗ?

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
