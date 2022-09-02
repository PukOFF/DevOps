# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-inventory -i inventory/test.yml --host localhost
{
    "ansible_connection": "local",
    "some_fact": 12
}
```
---

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-inventory -i inventory/test.yml --host localhost
{
    "ansible_connection": "local",
    "some_fact": "all default fact"
}
```

---

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ docker ps -a
CONTAINER ID   IMAGE      COMMAND          CREATED         STATUS         PORTS     NAMES
5183cdc6e143   centos:7   "sleep 666666"   6 minutes ago   Up 6 minutes             centos7
4ab186966769   ubuntu     "sleep 666666"   7 minutes ago   Up 7 minutes             ubuntu
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ 
```
---

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-inventory -i inventory/prod.yml --host ubuntu
{
    "ansible_connection": "docker",
    "some_fact": "deb"
}
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-inventory -i inventory/prod.yml --host centos7
{
    "ansible_connection": "docker",
    "some_fact": "el"
}
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$
```
---

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-inventory -i inventory/prod.yml --host ubuntu
{
    "ansible_connection": "docker",
    "some_fact": "deb"
}
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-inventory -i inventory/prod.yml --host centos7
{
    "ansible_connection": "docker",
    "some_fact": "el"
}
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$
```
---

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-inventory -i inventory/prod.yml --list
{
    "_meta": {
        "hostvars": {
            "centos7": {
                "ansible_connection": "docker",
                "some_fact": "el default fact"
            },
            "ubuntu": {
                "ansible_connection": "docker",
                "some_fact": "deb default fact"
            }
        }
    },
    "all": {
        "children": [
            "deb",
            "el",
            "ungrouped"
        ]
    },
    "deb": {
        "hosts": [
            "ubuntu"
        ]
    },
    "el": {
        "hosts": [
            "centos7"
        ]
    }
}
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ 
```
---

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ cat group_vars/deb/examp.yml 
$ANSIBLE_VAULT;1.1;AES256
31653738623531313035306464383532643833333734396164636436306637303835353563633262
3861386339303861376230633339356635343638653664650a616363666131663136383637343137
63323833306565363566333839303138313334343734313033643233323830376136663739363935
6263303937663966640a323363383761316530373331306466383830333665616162623837636466
38326566663364346539636432616234353234663939623433636237633637656434306265626665
3262333263663139336332396635333265326663623235616462
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ cat group_vars/el/examp.yml 
$ANSIBLE_VAULT;1.1;AES256
34633965396537376432336363613866663836353762396631383937663462633437316463633964
3763373463623936313133613634366230323339663464650a333736623737633365303563353561
66623561363933656238303736396432333433386638656630646566313737663461366364323832
3233396666323238370a316465383934663465373761316136636130323038316632373535646436
63396264613461356638643136643634653637613832343966326265666336386133356331346339
3161373864366362376238376239373563393637326465643835
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ 

```
---

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-inventory -i inventory/prod.yml --list --ask-vault-password
Vault password: 
{
    "_meta": {
        "hostvars": {
            "centos7": {
                "ansible_connection": "docker",
                "some_fact": "el default fact"
            },
            "ubuntu": {
                "ansible_connection": "docker",
                "some_fact": "deb default fact"
            }
        }
    },
    "all": {
        "children": [
            "deb",
            "el",
            "ungrouped"
        ]
    },
    "deb": {
        "hosts": [
            "ubuntu"
        ]
    },
    "el": {
        "hosts": [
            "centos7"
        ]
    }
}
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ 
```
---

9.  Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-doc -t connection -l
[WARNING]: Collection splunk.es does not support Ansible version 2.12.8
[WARNING]: Collection ibm.qradar does not support Ansible version 2.12.8
[DEPRECATION WARNING]: ansible.netcommon.napalm has been deprecated. See the plugin documentation for more details. This feature will be removed from ansible.netcommon in a release after 2022-06-01. Deprecation warnings can 
be disabled by setting deprecation_warnings=False in ansible.cfg.
ansible.netcommon.httpapi      Use httpapi to run command on network appliances                                                                                                                                              
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection                                                                                                                                      
ansible.netcommon.napalm       Provides persistent connection using NAPALM                                                                                                                                                   
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol                                                                                                                                   
ansible.netcommon.network_cli  Use network_cli to run command on network appliances                                                                                                                                          
ansible.netcommon.persistent   Use a persistent unix socket for connection                                                                                                                                                   
community.aws.aws_ssm          execute via AWS Systems Manager                                                                                                                                                               
community.docker.docker        Run tasks in docker containers                                                                                                                                                                
community.docker.docker_api    Run tasks in docker containers                                                                                                                                                                
community.docker.nsenter       execute on host running controller container                                                                                                                                                  
community.general.chroot       Interact with local chroot                                                                                                                                                                    
community.general.funcd        Use funcd to connect to target                                                                                                                                                                
community.general.iocage       Run tasks in iocage jails                                                                                                                                                                     
community.general.jail         Run tasks in jails                                                                                                                                                                            
community.general.lxc          Run tasks in lxc containers via lxc python library                                                                                                                                            
community.general.lxd          Run tasks in lxc containers via lxc CLI                                                                                                                                                       
community.general.qubes        Interact with an existing QubesOS AppVM                                                                                                                                                       
community.general.saltstack    Allow ansible to piggyback on salt minions                                                                                                                                                    
community.general.zone         Run tasks in a zone instance                                                                                                                                                                  
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt                                                                                                                                                       
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines                                                                                                                                                    
community.okd.oc               Execute tasks in pods running on OpenShift                                                                                                                                                    
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools                                                                                                                                                    
community.zabbix.httpapi       Use httpapi to run command on network appliances                                                                                                                                              
containers.podman.buildah      Interact with an existing buildah container                                                                                                                                                   
containers.podman.podman       Interact with an existing podman container                                                                                                                                                    
kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes                                                                                                                                                   
local                          execute on controller                                                                                                                                                                         
paramiko_ssh                   Run tasks via python ssh (paramiko)                                                                                                                                                           
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol                                                                                                                                         
ssh                            connect via SSH client binary                                                                                                                                                                 
winrm                          Run tasks over Microsoft's WinRM                                                                                                                                                              
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ 

```
---

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ cat inventory/prod.yml 
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  loc:
    hosts:
      localhost:
        ansible_connection: local
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$
```
---

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-inventory -i inventory/prod.yml --list --ask-vault-password
Vault password: 
{
    "_meta": {
        "hostvars": {
            "centos7": {
                "ansible_connection": "docker",
                "some_fact": "el default fact"
            },
            "localhost": {
                "ansible_connection": "local",
                "some_fact": "all default fact"
            },
            "ubuntu": {
                "ansible_connection": "docker",
                "some_fact": "deb default fact"
            }
        }
    },
    "all": {
        "children": [
            "deb",
            "el",
            "loc",
            "ungrouped"
        ]
    },
    "deb": {
        "hosts": [
            "ubuntu"
        ]
    },
    "el": {
        "hosts": [
            "centos7"
        ]
    },
    "loc": {
        "hosts": [
            "localhost"
        ]
    }
}
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ 
```
---

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-vault decrypt group_vars/el/examp.yml 
Vault password: 
Decryption successful
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-vault decrypt group_vars/deb/examp.yml 
Vault password: 
Decryption successful
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$
```
---

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-vault encrypt_string PaSSw0rd
New Vault password: 
Confirm New Vault password: 
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          61383837326662636538653764343066313665353638306663623233313631326139663565643337
          6234346264333138633866363936363539653765343532320a326263656434333431633432643566
          66653137333237633031646562616166373530396238313063643632333838643961346631346464
          6632313464623039650a316664333834306238366634316361613464323334313633303738666338
          6435
Encryption successful
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$
```
---

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.
4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).
5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.
6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

