1. Установите средство виртуализации Oracle VirtualBox.
    	[21:00:15] alex@AlexPC:~/Vagrant$ vboxmanage -v
	6.1.28r14762

2. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить
	[21:00:20] alex@AlexPC:~/Vagrant$ apt list guake
	Вывод списка… Готово
	guake/focal,focal,now 3.6.3-2 all [установлен]

3. Установите средство автоматизации Hashicorp Vagrant.
	[20:38:36] alex@AlexPC:~/Vagrant$ vagrant -v
	Vagrant 2.2.6

4. В вашем основном окружении подготовьте удобный для дальнейшей работы терминал. Можно предложить:

	Vagrant.configure("2") do |config|
	   config.vm.box = "bento/ubuntu-20.04"
	end

5. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?
	[21:24:34] alex@AlexPC:~/Vagrant$ vboxmanage showvminfo Vagrant_default_1641752341434_66968 | head -n 30
	Name:                        Vagrant_default_1641752341434_66968
	Groups:                      /
	Guest OS:                    Ubuntu (64-bit)
	UUID:                        07c23af7-b4fd-41e8-85ab-e57df4630ea9
	Config file:                 /home/alex/VirtualBox VMs/Vagrant_default_1641752341434_66968/Vagrant_default_1641752341434_66968.vbox
	Snapshot folder:             /home/alex/VirtualBox VMs/Vagrant_default_1641752341434_66968/Snapshots
	Log folder:                  /home/alex/VirtualBox VMs/Vagrant_default_1641752341434_66968/Logs
	Hardware UUID:               07c23af7-b4fd-41e8-85ab-e57df4630ea9
	Memory size:                 1024MB
	Page Fusion:                 disabled
	VRAM size:                   4MB
	CPU exec cap:                100%
	HPET:                        disabled
	CPUProfile:                  host
	Chipset:                     piix3
	Firmware:                    BIOS
	Number of CPUs:              2
	PAE:                         enabled
	Long Mode:                   enabled
	Triple Fault Reset:          disabled
	APIC:                        enabled
	X2APIC:                      enabled
	Nested VT-x/AMD-V:           disabled
	CPUID Portability Level:     0
	CPUID overrides:             None
	Boot menu mode:              message and menu
	Boot Device 1:               HardDisk
	Boot Device 2:               DVD
	Boot Device 3:               Not Assigned
	Boot Device 4:               Not Assigned

6. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

	Vagrant.configure("2") do |config|
	   config.vm.synced_folder ".", "/vagrant", disabled: false
	   config.vm.box = "bento/ubuntu-20.04"
	   config.vm.define "devops"
	   config.vm.hostname = "test"
	   config.vm.box_check_update = "false"
	
	   config.vm.provider "virtualbox" do |vb|
	     vb.cpus = "1"
	     vb.memory = "1024"
	   end
	   config.vm.provision "shell", inline: <<-SHELL
	     apt-get update
	     apt-get install -y mc
	   SHELL
	end

7. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu

	vagrant@vagrant:~$ cat /etc/hostname 
	vagrant
	vagrant@vagrant:~$ ls -lah /etc | head -n 5
	total 800K
	drwxr-xr-x 97 root root      4.0K Dec 19 19:46 .
	drwxr-xr-x 21 root root      4.0K Jan  9 18:19 ..
	-rw-r--r--  1 root root      3.0K Aug 24 08:42 adduser.conf
	drwxr-xr-x  2 root root      4.0K Dec 19 19:46 alternatives
	vagrant@vagrant:~$ ls -lah /etc | tail -n 3
	drwxr-xr-x  4 root root      4.0K Aug 24 08:46 X11
	-rw-r--r--  1 root root       642 Sep 24  2019 xattr.conf
	drwxr-xr-x  4 root root      4.0K Aug 24 08:43 xdg
	vagrant@vagrant:~$ 

8. Ознакомиться с разделами man bash, почитать о настройках самого bash:

	* Variable: HISTFILESIZE, Строка 641
	* ignoreboth - не сохранять строки начинающиеся с символа <пробел> и строки, совпадающие с последней выполненной командой

9. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?
	Определние последовательности (списка), например touch {1,2}.txt создаст 2 файла 1.txt и 2.txt. Строка 210

10. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?
	Получится.
	vagrant@vagrant:~$ {1..30000}
	vagrant@vagrant:~$ ls | wc -l
	30000
	vagrant@vagrant:~$ 

11. В man bash поищите по /\[\[. Что делает конструкция [[ -d /tmp ]]
	* Возвращает статус команды заключенной внутри 0 или 1
	* [[ -d /tmp ]] Проверяет наличие папки, [[]] позволяет использовать регулярные выражения

	vagrant@vagrant:~$ bash test.sh /tmp
	Directory exist
	vagrant@vagrant:~$ bash test.sh /tmr
	Directory not created
	vagrant@vagrant:~$ cat test.sh 
	
	#!/bin/bash
		
	if [[ -d $1 ]]
	then
	        echo 'Directory exist'
	else
	        echo 'Directory not created'
	fi
	
	vagrant@vagrant:~$ 

12. Основываясь на знаниях о просмотре текущих (например, PATH) и установке новых переменных; командах, которые мы рассматривали, добейтесь в выводе type -a bash в виртуальной машине наличия первым пунктом в списке:

	vagrant@vagrant:~$ mkdir /tmp/new_path_directory/
	vagrant@vagrant:~$ cp /bin/bash /tmp/new_path_directory/bash
	vagrant@vagrant:~$ chmod +x /tmp/new_path_directory/bash
	vagrant@vagrant:~$ type -a bash
	bash is /usr/bin/bash
	bash is /bin/bash
	vagrant@vagrant:~$ export PATH=$PATH:/tmp/new_path_directory/
	vagrant@vagrant:~$ type -a bash
	bash is /usr/bin/bash
	bash is /bin/bash
	bash is /tmp/new_path_directory/bash
	vagrant@vagrant:~$ 

13. Команда at используется для назначения одноразового задания на заданное время, а команда batch — для назначения одноразовых задач, которые должны выполняться, когда загрузка системы становится меньше 0,8
