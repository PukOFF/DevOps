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
