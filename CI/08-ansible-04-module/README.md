# Домашнее задание к занятию "08.05 Тестирование Roles"

## Подготовка к выполнению
1. Установите molecule: `pip3 install "molecule==3.5.2"`

---
```bash
mint@mint:~$ pip3 list | grep molecule
molecule              3.5.2
mint@mint:~$ 
```
---

2. Выполните `docker pull aragast/netology:latest` -  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри

---
```bash
mint@mint:~$ sudo docker pull aragast/netology:latest
latest: Pulling from aragast/netology
f70d60810c69: Pull complete 
545277d80005: Pull complete 
3787740a304b: Pull complete 
8099be4bd6d4: Pull complete 
78316366859b: Pull complete 
a887350ff6d8: Pull complete 
8ab90b51dc15: Pull complete 
14617a4d32c2: Pull complete 
b868affa868e: Pull complete 
1e0b58337306: Pull complete 
9167ab0cbb7e: Pull complete 
907e71e165dd: Pull complete 
6025d523ea47: Pull complete 
6084c8fa3ce3: Pull complete 
cffe842942c7: Pull complete 
Digest: sha256:aa756f858732773c37e443ee13b46b0925bab33775709417e581d99948c08efc
Status: Downloaded newer image for aragast/netology:latest
docker.io/aragast/netology:latest
mint@mint:~$
```
---


## Основная часть

Наша основная цель - настроить тестирование наших ролей. Задача: сделать сценарии тестирования для vector. Ожидаемый результат: все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos8` внутри корневой директории clickhouse-role, посмотрите на вывод команды.

---
```bash
mint@mint:~/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse$ molecule test -s centos_8
INFO     centos_8 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/7e099f/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/7e099f/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/7e099f/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/hosts.yml linked to /root/.cache/molecule/clickhouse/centos_8/inventory/hosts
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/group_vars/ linked to /root/.cache/molecule/clickhouse/centos_8/inventory/group_vars
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/host_vars/ linked to /root/.cache/molecule/clickhouse/centos_8/inventory/host_vars
INFO     Running centos_8 > dependency
INFO     Running ansible-galaxy collection install -v community.docker:>=1.9.1
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/hosts.yml linked to /root/.cache/molecule/clickhouse/centos_8/inventory/hosts
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/group_vars/ linked to /root/.cache/molecule/clickhouse/centos_8/inventory/group_vars
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/host_vars/ linked to /root/.cache/molecule/clickhouse/centos_8/inventory/host_vars
INFO     Running centos_8 > lint
COMMAND: yamllint .
ansible-lint
flake8

/bin/bash: line 1: yamllint: command not found
/bin/bash: line 2: ansible-lint: command not found
/bin/bash: line 3: flake8: command not found
CRITICAL Lint failed with error code 127
WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/hosts.yml linked to /root/.cache/molecule/clickhouse/centos_8/inventory/hosts
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/group_vars/ linked to /root/.cache/molecule/clickhouse/centos_8/inventory/group_vars
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/host_vars/ linked to /root/.cache/molecule/clickhouse/centos_8/inventory/host_vars
INFO     Running centos_8 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/hosts.yml linked to /root/.cache/molecule/clickhouse/centos_8/inventory/hosts
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/group_vars/ linked to /root/.cache/molecule/clickhouse/centos_8/inventory/group_vars
INFO     Inventory /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/clickhouse/molecule/centos_8/../resources/inventory/host_vars/ linked to /root/.cache/molecule/clickhouse/centos_8/inventory/host_vars
INFO     Running centos_8 > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_8)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
ok: [localhost] => (item=centos_8)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```
---
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.

---
```bash
mint@mint:~/DevOps/DevOps/CI/08-ansible-04-module/roles/vector$ molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/mint/DevOps/DevOps/CI/08-ansible-04-module/roles/vector/molecule/default successfully.
mint@mint:~/DevOps/DevOps/CI/08-ansible-04-module/roles/vector$
```
---


3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
   
---

```yaml
alex@alexPC:~/Github/DevOps/CI/08-ansible-04-module/roles/vector$ molecule test -s default
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/alex/.cache/ansible-compat/b0d51c/modules:/home/alex/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/alex/.cache/ansible-compat/b0d51c/collections:/home/alex/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/alex/.cache/ansible-compat/b0d51c/roles:/home/alex/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running default > syntax

playbook: /home/alex/Github/DevOps/CI/08-ansible-04-module/roles/vector/molecule/default/converge.yml
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}) 

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest) 

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '550385758123.5207', 'results_file': '/home/alex/.ansible_async/550385758123.5207', 'changed': True, 'item': {'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=5    changed=2    unreachable=0    failed=0    skipped=4    rescued=0    ignored=0

INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Include vector] **********************************************************

TASK [vector : Get Debian Vector Package] **************************************
changed: [instance]

TASK [vector : Install Vector] *************************************************
changed: [instance]

TASK [vector : Configure Vector] ***********************************************
included: /home/alex/Github/DevOps/CI/08-ansible-04-module/roles/vector/tasks/configure.yml for instance

TASK [vector : Vector | Template Config] ***************************************
changed: [instance]

TASK [vector : Vector | Create systemd unit] ***********************************
changed: [instance]

TASK [vector : Vector | Start Service] *****************************************
fatal: [instance]: FAILED! => {"changed": false, "msg": "Could not find the requested service vector: "}

PLAY RECAP *********************************************************************
instance                   : ok=6    changed=4    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/home/alex/.cache/molecule/vector/default/inventory', '--skip-tags', 'molecule-notest,notest', '/home/alex/Github/DevOps/CI/08-ansible-04-module/roles/vector/molecule/default/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item=instance)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
alex@alexPC:~/Github/DevOps/CI/08-ansible-04-module/roles/vector$
```

---

4. Добавьте несколько assert'ов в verify.yml файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска, etc). Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example)
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo - путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini` для того чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Ссылка на репозиторий являются ответами на домашнее задание. Не забудьте указать в ответе теги решений Tox и Molecule заданий.

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли lighthouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории. В ответ приведите ссылки.

---