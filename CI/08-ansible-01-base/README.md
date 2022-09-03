# Домашнее задание к занятию "08.01 Введение в Ansible"

## Подготовка к выполнению
1. Установите ansible версии 2.10 или выше.
2. Создайте свой собственный публичный репозиторий на github с произвольным именем.
3. Скачайте [playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть
1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте какое значение имеет факт `some_fact` для указанного хоста при выполнении playbook'a.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-playbook -i inventory/test.yml site.yml
TASK [Print fact] ****************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}
```
---

2. Найдите файл с переменными (group_vars) в котором задаётся найденное в первом пункте значение и поменяйте его на 'all default fact'.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-playbook -i inventory/test.yml site.yml
TASK [Print fact] ****************************************************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
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
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml
TASK [Print fact] ****************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}
```
---

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились следующие значения: для `deb` - 'deb default fact', для `el` - 'el default fact'.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml
TASK [Print fact] ****************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```
---

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml
TASK [Print fact] ****************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```
---

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ cat group_vars/el/examp.yml
$ANSIBLE_VAULT;1.1;AES256
31303461306139663730623936363661313662623335383838336237643834343361323864396234
3463363763656464393737633563613734633036613464320a643037653632353630663334356536
31336233376530323434623163346666653664616336303638353439303061313031383039613134
6530663937303831660a343034316538363566326439616338366233656232323162323339356236
64383935636335346264343263356338616461343431636262303862356632303330386438376636
3365386561323361323437643062323533363761376435613431
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ cat group_vars/deb/examp.yml
$ANSIBLE_VAULT;1.1;AES256
31633635393739666638353733306565333136373435623134656666336163666632303336343163
3964343036383939323166613163623837643032633635650a666238633462323839626662386632
37616436653937666665663436356232646163303464613935326433623566356537616661646339
3639353362303166380a316530316231643965326438346632643531363766396464383536643663
33303765626365623665323339373436646238616562633664386634633334333039366339643831
3736323163323165323631663639363664653335306465303163
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playboo
```
---

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-password
Vault password: 
TASK [Print fact] ****************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
```
---

9.  Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-doc -t connection -l
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
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-password
Vault password: 
TASK [Print fact] ****************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}
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
          61646162396261666564386661623630386666663331323334656138333337636664303039386334
          6564373539306335633930393766383666646536663939630a363732383830383463326632656230
          36633262666637383861613431393663343031383333356664353836393634646463616163336463
          3134306334613837620a653135613764336665393738633233353836656263356139346430323537
          3738
Encryption successful
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$
```
---

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-password
Vault password: 

TASK [Print fact] ****************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
```
---

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот](https://hub.docker.com/r/pycontribs/fedora).

---
```bash
alex@AlexPC:~/GitHub/DevOps/CI/08-ansible-01-base/playbook$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-password
Vault password: 
TASK [Print fact] ****************************************************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fedora variable"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
```
---

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

---
```bash
#!/bin/bash
echo "========= Starting Docker Containers ========="

echo "Docker container $(docker start ubuntu) started"
echo "Docker container $(docker start centos7) started"
echo "Docker container $(docker start fedora) started"

echo "========= Starting Ansible Playbook ========="

ansible-playbook -i inventory/prod.yml site.yml --vault-password-file pass.txt

echo "========= Finish Ansible Playbook =========\n"

echo "========= Stopping Docker Containers ========="

echo "Docker container $(docker stop ubuntu) stopped"
echo "Docker container $(docker stop centos7) stopped"
echo "Docker container $(docker stop fedora) stopped"
```
---

6. Все изменения должны быть зафиксированы и отправлены в вашей личный репозиторий.

---

