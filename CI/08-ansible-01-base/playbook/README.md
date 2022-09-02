# Самоконтроль выполненения задания

1. Где расположен файл с `some_fact` из второго пункта задания?
---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ cat group_vars/all/examp.yml
---
  some_fact: 'all default fact'
```
---
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?

---
```bash
ansible-inventory -i inventory/test.yml --host localhost
```
---

3. Какой командой можно зашифровать файл?

---
```bash
ansible-vault encrypt group_vars/el/examp.yml
ansible-vault encrypt group_vars/deb/examp.ym
```
---

4. Какой командой можно расшифровать файл?

---
```bash
ansible-vault decrypt group_vars/el/examp.yml
ansible-vault decrypt group_vars/deb/examp.ym
```
---

1. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?

---
```bash
ansible-vault view group_vars/el/examp.yml
ansible-vault view group_vars/deb/examp.ym
```
---

2. Как выглядит команда запуска `playbook`, если переменные зашифрованы?\

---
```bash
ansible-inventory -i inventory/prod.yml --list --ask-vault-password
```
---

3. Как называется модуль подключения к host на windows?

---
```bash
winrm                          Run tasks over Microsoft's WinRM
```
---

4. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh

---
```bash
ansible-doc -t connection ssh
```
---

5.  Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?

---
```bash
- remote_user
        User name with which to login to the remote server, normally set by the remote_user keyword.
        If no user is supplied, Ansible will let the SSH client binary choose the user as it normally.
        [Default: (null)]
        set_via:
          cli:
          - name: user
            option: --user
          env:
          - name: ANSIBLE_REMOTE_USER
          ini:
          - key: remote_user
            section: defaults
          vars:
          - name: ansible_user
          - name: ansible_ssh_user

```
---
