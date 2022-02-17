# Домашнее задание к занятию "3.5. Файловые системы"

1. Узнайте о [sparse](https://ru.wikipedia.org/wiki/%D0%A0%D0%B0%D0%B7%D1%80%D0%B5%D0%B6%D1%91%D0%BD%D0%BD%D1%8B%D0%B9_%D1%84%D0%B0%D0%B9%D0%BB) (разряженных) файлах.

   
   Разрежённые файлы используются для хранения контейнеров, например:
   образов дисков виртуальных машин;
   резервных копий дисков и/или разделов, созданных спец. ПО.

***

2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?
   
   
Нельзя. Жесткая ссылка имеет те же права доступа, владельца и время последней модификации, что и целевой файл.   

***

3. Сделайте `vagrant destroy` на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    ```bash
    Vagrant.configure("2") do |config|
      config.vm.box = "bento/ubuntu-20.04"
      config.vm.provider :virtualbox do |vb|
        lvm_experiments_disk0_path = "/tmp/lvm_experiments_disk0.vmdk"
        lvm_experiments_disk1_path = "/tmp/lvm_experiments_disk1.vmdk"
        vb.customize ['createmedium', '--filename', lvm_experiments_disk0_path, '--size', 2560]
        vb.customize ['createmedium', '--filename', lvm_experiments_disk1_path, '--size', 2560]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk0_path]
        vb.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', lvm_experiments_disk1_path]
      end
    end
    ```

    Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.

   ```bash   
   vagrant@vagrant:~$ lsblk | grep sd
   sda                         8:0    0   64G  0 disk 
   ├─sda1                      8:1    0    1M  0 part 
   ├─sda2                      8:2    0    1G  0 part /boot
   └─sda3                      8:3    0   63G  0 part 
   sdb                         8:16   0  2.5G  0 disk 
   sdc                         8:32   0  2.5G  0 disk 
   vagrant@vagrant:~$
   ``` 
***

4. Используя `fdisk`, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

   ```bash
   vagrant@vagrant:~$ lsblk | grep sd
   sda                         8:0    0   64G  0 disk 
   ├─sda1                      8:1    0    1M  0 part 
   ├─sda2                      8:2    0    1G  0 part /boot
   └─sda3                      8:3    0   63G  0 part 
   sdb                         8:16   0  2.5G  0 disk 
   ├─sdb1                      8:17   0    2G  0 part 
   └─sdb2                      8:18   0  511M  0 part 
   sdc                         8:32   0  2.5G  0 disk 
   vagrant@vagrant:~$ 
   ```

***

7. Используя `sfdisk`, перенесите данную таблицу разделов на второй диск.

   ```bash
   vagrant@vagrant:~$ lsblk | grep sd
   sda                         8:0    0   64G  0 disk 
   ├─sda1                      8:1    0    1M  0 part 
   ├─sda2                      8:2    0    1G  0 part /boot
   └─sda3                      8:3    0   63G  0 part 
   sdb                         8:16   0  2.5G  0 disk 
   ├─sdb1                      8:17   0    2G  0 part 
   └─sdb2                      8:18   0  511M  0 part 
   sdc                         8:32   0  2.5G  0 disk 
   vagrant@vagrant:~$ sudo sfdisk -d /dev/sdb
   label: dos
   label-id: 0xc95f71b2
   device: /dev/sdb
   unit: sectors
   
   /dev/sdb1 : start=        2048, size=     4194304, type=83
   /dev/sdb2 : start=     4196352, size=     1046528, type=83
   vagrant@vagrant:~$ sudo -s
   root@vagrant:/home/vagrant# sfdisk -d /dev/sdb | sfdisk /dev/sdc
   Checking that no-one is using this disk right now ... OK
   
   Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
   Disk model: VBOX HARDDISK   
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   
   >>> Script header accepted.
   >>> Script header accepted.
   >>> Script header accepted.
   >>> Script header accepted.
   >>> Created a new DOS disklabel with disk identifier 0xc95f71b2.
   /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
   /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
   /dev/sdc3: Done.
   
   New situation:
   Disklabel type: dos
   Disk identifier: 0xc95f71b2
   
   Device     Boot   Start     End Sectors  Size Id Type
   /dev/sdc1          2048 4196351 4194304    2G 83 Linux
   /dev/sdc2       4196352 5242879 1046528  511M 83 Linux
   
   The partition table has been altered.
   Calling ioctl() to re-read partition table.
   Syncing disks.
   root@vagrant:/home/vagrant# lsblk | grep sd
   sda                         8:0    0   64G  0 disk 
   ├─sda1                      8:1    0    1M  0 part 
   ├─sda2                      8:2    0    1G  0 part /boot
   └─sda3                      8:3    0   63G  0 part 
   sdb                         8:16   0  2.5G  0 disk 
   ├─sdb1                      8:17   0    2G  0 part 
   └─sdb2                      8:18   0  511M  0 part 
   sdc                         8:32   0  2.5G  0 disk 
   ├─sdc1                      8:33   0    2G  0 part 
   └─sdc2                      8:34   0  511M  0 part 
   root@vagrant:/home/vagrant# 
   ```
***

8. Соберите `mdadm` RAID1 на паре разделов 2 Гб.

   ```bash
   vagrant@vagrant:~$ mdadm --create --verbose /dev/md0 --level=1 --raid-device=2 /dev/sdb1 /dev/sdc1
   mdadm: must be super-user to perform this action
   vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md0 --level=1 --raid-device=2 /dev/sdb1 /dev/sdc1
   mdadm: Note: this array has metadata at the start and
       may not be suitable as a boot device.  If you plan to
       store '/boot' on this device please ensure that
       your boot-loader understands md/v1.x metadata, or use
       --metadata=0.90
   mdadm: size set to 2094080K
   Continue creating array? (y/n) y
   mdadm: Defaulting to version 1.2 metadata
   mdadm: array /dev/md0 started.
   vagrant@vagrant:~$ cat /proc/mdstat 
   Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
   md1 : active raid10 sdc2[1] sdb2[0]
      521216 blocks super 1.2 2 near-copies [2/2] [UU]
     
   unused devices: <none>
   ```

***

9. Соберите `mdadm` RAID0 на второй паре маленьких разделов.

   ```bash
   vagrant@vagrant:~$ sudo mdadm --create --verbose /dev/md1 --level=10 --raid-device=2 /dev/sdb2 /dev/sdc2
   mdadm: layout defaults to n2
   mdadm: layout defaults to n2
   mdadm: chunk size defaults to 512K
   mdadm: size set to 521216K
   mdadm: Defaulting to version 1.2 metadata
   mdadm: array /dev/md1 started.
   vagrant@vagrant:~$ cat /proc/mdstat 
   Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
   md1 : active raid10 sdc2[1] sdb2[0]
      521216 blocks super 1.2 2 near-copies [2/2] [UU]
      
   md0 : active raid1 sdc1[1] sdb1[0]
      2094080 blocks super 1.2 [2/2] [UU]
      
   unused devices: <none>
    ```

***

10. Создайте 2 независимых PV на получившихся md-устройствах.

      ```bash
      vagrant@vagrant:~$ sudo pvcreate /dev/md0 
        Physical volume "/dev/md0" successfully created.
      vagrant@vagrant:~$ sudo pvcreate /dev/md1
        Physical volume "/dev/md1" successfully created.
      vagrant@vagrant:~$ sudo pvs
        PV         VG        Fmt  Attr PSize   PFree  
        /dev/md0             lvm2 ---   <2.00g  <2.00g
        /dev/md1             lvm2 ---  509.00m 509.00m
        /dev/sda3  ubuntu-vg lvm2 a--  <63.00g <31.50g
      vagrant@vagrant:~$
      ```
***

11. Создайте общую volume-group на этих двух PV.

      ```bash
      vagrant@vagrant:~$ sudo vgcreate vg0 /dev/md0 /dev/md1
        Volume group "vg0" successfully created
      vagrant@vagrant:~$ sudo vgdisplay vg0
        --- Volume group ---
        VG Name               vg0
        System ID             
        Format                lvm2
        Metadata Areas        2
        Metadata Sequence No  1
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                0
        Open LV               0
        Max PV                0
        Cur PV                2
        Act PV                2
        VG Size               2.49 GiB
        PE Size               4.00 MiB
        Total PE              638
        Alloc PE / Size       0 / 0   
        Free  PE / Size       638 / 2.49 GiB
        VG UUID               H2CjTd-Tftl-l8d7-Rya2-2Fs3-qGYa-YLknJ9
         
      vagrant@vagrant:~$ 
      ```

***

12. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

      ```bash
      vagrant@vagrant:~$ sudo lvcreate -L 100 -n log_volume vg0 /dev/md0
        Logical volume "log_volume" created.
      vagrant@vagrant:~$ sudo lvs
        LV         VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
        ubuntu-lv  ubuntu-vg -wi-ao----  31.50g                                                    
        log_volume vg0       -wi-a----- 100.00m                                                    
      vagrant@vagrant:~$ 
      ```
***

13. Создайте `mkfs.ext4` ФС на получившемся LV.

      ```bash
      vagrant@vagrant:~$ sudo mkfs.ext4 /dev/mapper/vg0-log_volume 
      mke2fs 1.45.5 (07-Jan-2020)
      Creating filesystem with 25600 4k blocks and 25600 inodes
      
      Allocating group tables: done                            
      Writing inode tables: done                            
      Creating journal (1024 blocks): done
      Writing superblocks and filesystem accounting information: done
   
      Disk /dev/mapper/vg0-log_volume: 100 MiB, 104857600 bytes, 204800 sectors
      Units: sectors of 1 * 512 = 512 bytes
      Sector size (logical/physical): 512 bytes / 512 bytes
      I/O size (minimum/optimal): 512 bytes / 512 bytes
      Disklabel type: dos
      Disk identifier: 0xf2f4f497
   
      ```

***

14. Смонтируйте этот раздел в любую директорию, например, `/tmp/new`.

      ```bash
      vagrant@vagrant:~$ mount | grep -E "^/dev"
      /dev/mapper/ubuntu--vg-ubuntu--lv on / type ext4 (rw,relatime)
      /dev/sda2 on /boot type ext4 (rw,relatime)
      vagrant@vagrant:~$ mkdir /tmp/new
      vagrant@vagrant:~$ sudo mount /dev/mapper/vg0-log_volume /tmp/new
      vagrant@vagrant:~$ mount | grep -E "^/dev"
      /dev/mapper/ubuntu--vg-ubuntu--lv on / type ext4 (rw,relatime)
      /dev/sda2 on /boot type ext4 (rw,relatime)
      /dev/mapper/vg0-log_volume on /tmp/new type ext4 (rw,relatime)
      vagrant@vagrant:~$ 
      ```
***

15. Поместите туда тестовый файл, например `wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz`.

      ```bash
      vagrant@vagrant:~$ sudo wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
      --2022-02-17 19:45:10--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
      Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
      Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
      HTTP request sent, awaiting response... 200 OK
      Length: 22367262 (21M) [application/octet-stream]
      Saving to: ‘/tmp/new/test.gz’
      
      /tmp/new/test.gz                                 100%[=========================================================================================================>]  21.33M  35.9MB/s    in 0.6s    
      
      2022-02-17 19:45:11 (35.9 MB/s) - ‘/tmp/new/test.gz’ saved [22367262/22367262]
      
      vagrant@vagrant:~$ ls /tmp/new
      lost+found  test.gz
      vagrant@vagrant:~$
      ```

***

16. Прикрепите вывод `lsblk`.

      ```bash
      vagrant@vagrant:~$ lsblk
      NAME                      MAJ:MIN RM  SIZE RO TYPE   MOUNTPOINT
      loop0                       7:0    0 70.3M  1 loop   /snap/lxd/21029
      loop2                       7:2    0 55.4M  1 loop   /snap/core18/2128
      loop3                       7:3    0 55.5M  1 loop   /snap/core18/2284
      loop4                       7:4    0 43.6M  1 loop   /snap/snapd/14978
      loop5                       7:5    0 61.9M  1 loop   /snap/core20/1328
      loop6                       7:6    0 67.2M  1 loop   /snap/lxd/21835
      sda                         8:0    0   64G  0 disk   
      ├─sda1                      8:1    0    1M  0 part   
      ├─sda2                      8:2    0    1G  0 part   /boot
      └─sda3                      8:3    0   63G  0 part   
        └─ubuntu--vg-ubuntu--lv 253:0    0 31.5G  0 lvm    /
      sdb                         8:16   0  2.5G  0 disk   
      ├─sdb1                      8:17   0    2G  0 part   
      │ └─md0                     9:0    0    2G  0 raid1  
      │   └─vg0-log_volume      253:1    0  100M  0 lvm    /tmp/new
      └─sdb2                      8:18   0  511M  0 part   
        └─md1                     9:1    0  509M  0 raid10 
      sdc                         8:32   0  2.5G  0 disk   
      ├─sdc1                      8:33   0    2G  0 part   
      │ └─md0                     9:0    0    2G  0 raid1  
      │   └─vg0-log_volume      253:1    0  100M  0 lvm    /tmp/new
      └─sdc2                      8:34   0  511M  0 part   
        └─md1                     9:1    0  509M  0 raid10 
      vagrant@vagrant:~$ 
      ```

***

17. Протестируйте целостность файла:

     ```bash
     root@vagrant:~# gzip -t /tmp/new/test.gz
     root@vagrant:~# echo $?
     0
     ```
    
      ```bash
      vagrant@vagrant:~$ gzip -t /tmp/new/test.gz 
      vagrant@vagrant:~$ echo $?
      0
      vagrant@vagrant:~$ 
      ```

18. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

      ```bash
      vagrant@vagrant:~$ sudo pvmove /dev/md0 /dev/md1
        /dev/md0: Moved: 12.00%
        /dev/md0: Moved: 100.00%
      vagrant@vagrant:~$ 
      ```
***

19. Сделайте `--fail` на устройство в вашем RAID1 md.


      ```bash
      vagrant@vagrant:~$ sudo mdadm /dev/md0 --fail
      ```
***

20. Подтвердите выводом `dmesg`, что RAID1 работает в деградированном состоянии.

      ```bash
      vagrant@vagrant:~$ dmesg | tail -n 2
      [ 5531.282313] md/raid1:md0: Disk failure on sdb1, disabling device.
                     md/raid1:md0: Operation continuing on 1 dev
      ```

***

22. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

      ```bash
      vagrant@vagrant:~$ dmesg | tail -n 2
      [ 5531.282313] md/raid1:md0: Disk failure on sdb1, disabling device.
               md/raid1:md0: Operation continuing on 1 devices.
      vagrant@vagrant:~$ sudo mdadm /dev/md0 --fail^C
      vagrant@vagrant:~$ gzip -t /tmp/new/test.gz 
      vagrant@vagrant:~$ echo $?
      0
     ```

***

23. Погасите тестовый хост, `vagrant destroy`.

      ```bash
      [23:09:32] alex@AlexPC:~/Vagrant$ vagrant destroy
      default: Are you sure you want to destroy the 'default' VM? [y/N] y
      ==> default: Forcing shutdown of VM...
      ==> default: Destroying VM and associated drives..
      ```