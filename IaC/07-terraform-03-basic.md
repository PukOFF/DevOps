# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 


## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  

---
```bash
alex@AlexPC:~/GitHub/DevOps/IaC/terraform$ ./terraform workspace list
  default
* prod
  stage

alex@AlexPC:~/GitHub/DevOps/IaC/terraform$ 
---
```bash
alex@AlexPC:~/GitHub/DevOps/IaC/terraform$ ./terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # yandex_compute_instance.instance[0] will be created
  + resource "yandex_compute_instance" "instance" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:-----BEGIN OPENSSH PRIVATE KEY-----
                       -----END OPENSSH PRIVATE KEY-----
            EOT
        }
      + name                      = "vpc-prod-1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v3"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd80viupr3qjr5g6g9du"
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.instance[1] will be created
  + resource "yandex_compute_instance" "instance" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:-----BEGIN OPENSSH PRIVATE KEY-----
                b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
                NhAAAAAwEAAQAAAYEAw5f3wWJrR8TS7uQAPEboMaja7K+zTyi1q0pKg2GqrVJ7LM+geIHW
                3GDCBO5zLQSZVVmaRkRjiEIwvHh4C/KAVZ7Tf2cmuisJNY36MPNB9+u8TFGJg/TsVpL33R
                7fwF2qNZeG+TgR4T8kVY9ha34zARAxcqSQgDet5V/8/ioqcVXjb9pvihFmDSa1zDXfaRUR
                h8Q+k60VAGS1lKKTurXJd9YAyoi64sts8PPgDspzlibTiVZ812Uoa40HmqoI/Tjt9E/SVJ
                3vAiYWWR0pzQ7C4fj/EUINhZeeG0cs5VYHr2P2AD5AGwP6eEEBLs+yG/W3JTErLZAQIfuu
                R1xQrKDEZ73rdKY8KnozinRf+PrvO2fCo+sjt9HNvchwoQr3i+UpM9i4kW8iqiN1mG58v3
                WkW1rjxfBDXajv2qprrZTaH82zPsd4XzzTCZMvj/P4NejCM8xjHvDl721JLpsZ7+aWNXXM
                thiKtbhUSqjPfp2nYH+2gqnzkc3mhQ+5tsqasFHRAAAFiEgjErxIIxK8AAAAB3NzaC1yc2
                EAAAGBAMOX98Fia0fE0u7kADxG6DGo2uyvs08otatKSoNhqq1SeyzPoHiB1txgwgTucy0E
                mVVZmkZEY4hCMLx4eAvygFWe039nJrorCTWN+jDzQffrvExRiYP07FaS990e38BdqjWXhv
                k4EeE/JFWPYWt+MwEQMXKkkIA3reVf/P4qKnFV42/ab4oRZg0mtcw132kVEYfEPpOtFQBk
                tZSik7q1yXfWAMqIuuLLbPDz4A7Kc5Ym04lWfNdlKGuNB5qqCP047fRP0lSd7wImFlkdKc
                0OwuH4/xFCDYWXnhtHLOVWB69j9gA+QBsD+nhBAS7Pshv1tyUxKy2QECH7rkdcUKygxGe9
                63SmPCp6M4p0X/j67ztnwqPrI7fRzb3IcKEK94vlKTPYuJFvIqojdZhufL91pFta48XwQ1
                2o79qqa62U2h/Nsz7HeF880wmTL4/z+DXowjPMYx7w5e9tSS6bGe/mljV1zLYYirW4VEqo
                z36dp2B/toKp85HN5oUPubbKmrBR0QAAAAMBAAEAAAGAOMI+yUWQMDFzrJNJZjSFaPPBI/
                IQrKX5og1a9ik/aDCJQgW2YYH8IdOKOfggQC4XeOcZl858u6vJjMfAvmbOywneAhii6l9W
                us3Kjq3otNMZv2Ph7gMDGlRnzSkKcT49CHRCXMvilGTIXHPRJ2plzqcuUkBjFnIR6oAiYH
                dH/b+Y0nqm54AJB0P2eZ4giNPuVGGkbyJI9+ZBszJCgGoEXtwhOqTW5r11ja6XlHM3e5kk
                xbPtYmwegKdaT42MMj90ey2+noNDFzgbH5flJKIB4EJNEI48KfcGqikAUiM4gNDYwUTY6h
                cqqKR6JdRvfXlhSUPgErtnvjGWElUfxbOJaqprLQVLYhEJa5x/ZvKiFAfzngsDqo1dODqI
                QYBqELWu4cTqKJzBJifWOnO44tsb/H0ADKLtq+qle6DAkrPEYMFuxTKtRuvfCE7pErnfCX
                OtG0h9aRd8XxC1A7YM6kWIKsWM/RzATGxp1FSKqvxrf+H+XnXUqRZCRb5xTLXiYLABAAAA
                wQCjeROy8nKgbdwe/5ws5yUcBl7wh4s1bTGVSVHQmn5vtwQ9sR+neJFDlIwj9GQx9UbNvj
                TpKr80lksiAdPQCN7rG3UH9GbWzO5sfoDCSf0L3ri3uGy7ddmf7lNjNjXTXlt+/pFuZDZF
                2Z2v5XbRTHLVSjuWlIzo5YOyX+bINBejGVxc0yWtXu1vR7SgffBTeWVxk+CDSsoqdNzwBs
                ohEf2azpgANVS/IXiBrMMT5jhaMcwTa4WIFdb/uNrKdDY+HG4AAADBAPu2opGzYmh5LRV5
                CvzVj+dBaVdtfB6pSP1ruY0xlQVQLytS0Ky4+z1ojlEXBqgU/B0gaffmfR6vohqw60/dWH
                755MOiz9QkS6QoHex+ZeA95EiPFdf0paWm6muZNJ7VZgq3b+Ar12IOR+naK876vTbfZpVM
                yK2ax5fqAQlSORmYKy8upvNK+vR0BUHwIqbpfz19mAMX39tva78OJAnfBsOcYK0UxoYHXP
                +SkoCdUgmBwfC7s1PcZa+OziE/hG05gQAAAMEAxuysim+MbqpEqwHhGfJqKmSzmP6+rpS6
                YXZoBZRFz+JhfwtV0MWkliYwOviJnPLrZsLMRC4odieeY2K0m/VR0bkLTXoW3nJlZo4DtI
                hCuyqgi1pO5YfRP/Okk4AW9gDFucHLBwzxKW6wP8UG17ZH/GHn8Ki5kNk8qfChhAe8gSMK
                5IeHH2rU4FsMPOgpZwIwQ/S0GKHJjOIbgw39FRU7EUjNDXy79ZWVQsNVF/dcoa4aCgbC/T
                X5Y9tWNMUrcSBRAAAAC2FsZXhAQWxleFBDAQIDBAUGBw==
                -----END OPENSSH PRIVATE KEY-----
            EOT
        }
      + name                      = "vpc-prod-2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v3"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd80viupr3qjr5g6g9du"
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.test-instance["each1"] will be created
  + resource "yandex_compute_instance" "test-instance" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:-----BEGIN OPENSSH PRIVATE KEY-----
                b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
                NhAAAAAwEAAQAAAYEAw5f3wWJrR8TS7uQAPEboMaja7K+zTyi1q0pKg2GqrVJ7LM+geIHW
                3GDCBO5zLQSZVVmaRkRjiEIwvHh4C/KAVZ7Tf2cmuisJNY36MPNB9+u8TFGJg/TsVpL33R
                7fwF2qNZeG+TgR4T8kVY9ha34zARAxcqSQgDet5V/8/ioqcVXjb9pvihFmDSa1zDXfaRUR
                h8Q+k60VAGS1lKKTurXJd9YAyoi64sts8PPgDspzlibTiVZ812Uoa40HmqoI/Tjt9E/SVJ
                3vAiYWWR0pzQ7C4fj/EUINhZeeG0cs5VYHr2P2AD5AGwP6eEEBLs+yG/W3JTErLZAQIfuu
                R1xQrKDEZ73rdKY8KnozinRf+PrvO2fCo+sjt9HNvchwoQr3i+UpM9i4kW8iqiN1mG58v3
                WkW1rjxfBDXajv2qprrZTaH82zPsd4XzzTCZMvj/P4NejCM8xjHvDl721JLpsZ7+aWNXXM
                thiKtbhUSqjPfp2nYH+2gqnzkc3mhQ+5tsqasFHRAAAFiEgjErxIIxK8AAAAB3NzaC1yc2
                EAAAGBAMOX98Fia0fE0u7kADxG6DGo2uyvs08otatKSoNhqq1SeyzPoHiB1txgwgTucy0E
                mVVZmkZEY4hCMLx4eAvygFWe039nJrorCTWN+jDzQffrvExRiYP07FaS990e38BdqjWXhv
                k4EeE/JFWPYWt+MwEQMXKkkIA3reVf/P4qKnFV42/ab4oRZg0mtcw132kVEYfEPpOtFQBk
                tZSik7q1yXfWAMqIuuLLbPDz4A7Kc5Ym04lWfNdlKGuNB5qqCP047fRP0lSd7wImFlkdKc
                0OwuH4/xFCDYWXnhtHLOVWB69j9gA+QBsD+nhBAS7Pshv1tyUxKy2QECH7rkdcUKygxGe9
                63SmPCp6M4p0X/j67ztnwqPrI7fRzb3IcKEK94vlKTPYuJFvIqojdZhufL91pFta48XwQ1
                2o79qqa62U2h/Nsz7HeF880wmTL4/z+DXowjPMYx7w5e9tSS6bGe/mljV1zLYYirW4VEqo
                z36dp2B/toKp85HN5oUPubbKmrBR0QAAAAMBAAEAAAGAOMI+yUWQMDFzrJNJZjSFaPPBI/
                IQrKX5og1a9ik/aDCJQgW2YYH8IdOKOfggQC4XeOcZl858u6vJjMfAvmbOywneAhii6l9W
                us3Kjq3otNMZv2Ph7gMDGlRnzSkKcT49CHRCXMvilGTIXHPRJ2plzqcuUkBjFnIR6oAiYH
                dH/b+Y0nqm54AJB0P2eZ4giNPuVGGkbyJI9+ZBszJCgGoEXtwhOqTW5r11ja6XlHM3e5kk
                xbPtYmwegKdaT42MMj90ey2+noNDFzgbH5flJKIB4EJNEI48KfcGqikAUiM4gNDYwUTY6h
                cqqKR6JdRvfXlhSUPgErtnvjGWElUfxbOJaqprLQVLYhEJa5x/ZvKiFAfzngsDqo1dODqI
                QYBqELWu4cTqKJzBJifWOnO44tsb/H0ADKLtq+qle6DAkrPEYMFuxTKtRuvfCE7pErnfCX
                OtG0h9aRd8XxC1A7YM6kWIKsWM/RzATGxp1FSKqvxrf+H+XnXUqRZCRb5xTLXiYLABAAAA
                wQCjeROy8nKgbdwe/5ws5yUcBl7wh4s1bTGVSVHQmn5vtwQ9sR+neJFDlIwj9GQx9UbNvj
                TpKr80lksiAdPQCN7rG3UH9GbWzO5sfoDCSf0L3ri3uGy7ddmf7lNjNjXTXlt+/pFuZDZF
                2Z2v5XbRTHLVSjuWlIzo5YOyX+bINBejGVxc0yWtXu1vR7SgffBTeWVxk+CDSsoqdNzwBs
                ohEf2azpgANVS/IXiBrMMT5jhaMcwTa4WIFdb/uNrKdDY+HG4AAADBAPu2opGzYmh5LRV5
                CvzVj+dBaVdtfB6pSP1ruY0xlQVQLytS0Ky4+z1ojlEXBqgU/B0gaffmfR6vohqw60/dWH
                755MOiz9QkS6QoHex+ZeA95EiPFdf0paWm6muZNJ7VZgq3b+Ar12IOR+naK876vTbfZpVM
                yK2ax5fqAQlSORmYKy8upvNK+vR0BUHwIqbpfz19mAMX39tva78OJAnfBsOcYK0UxoYHXP
                +SkoCdUgmBwfC7s1PcZa+OziE/hG05gQAAAMEAxuysim+MbqpEqwHhGfJqKmSzmP6+rpS6
                YXZoBZRFz+JhfwtV0MWkliYwOviJnPLrZsLMRC4odieeY2K0m/VR0bkLTXoW3nJlZo4DtI
                hCuyqgi1pO5YfRP/Okk4AW9gDFucHLBwzxKW6wP8UG17ZH/GHn8Ki5kNk8qfChhAe8gSMK
                5IeHH2rU4FsMPOgpZwIwQ/S0GKHJjOIbgw39FRU7EUjNDXy79ZWVQsNVF/dcoa4aCgbC/T
                X5Y9tWNMUrcSBRAAAAC2FsZXhAQWxleFBDAQIDBAUGBw==
                -----END OPENSSH PRIVATE KEY-----
            EOT
        }
      + name                      = "vpc-each1"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v1"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd80viupr3qjr5g6g9du"
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_compute_instance.test-instance["each2"] will be created
  + resource "yandex_compute_instance" "test-instance" {
      + created_at                = (known after apply)
      + folder_id                 = (known after apply)
      + fqdn                      = (known after apply)
      + hostname                  = (known after apply)
      + id                        = (known after apply)
      + metadata                  = {
          + "ssh-keys" = <<-EOT
                ubuntu:-----BEGIN OPENSSH PRIVATE KEY-----
                b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
                NhAAAAAwEAAQAAAYEAw5f3wWJrR8TS7uQAPEboMaja7K+zTyi1q0pKg2GqrVJ7LM+geIHW
                3GDCBO5zLQSZVVmaRkRjiEIwvHh4C/KAVZ7Tf2cmuisJNY36MPNB9+u8TFGJg/TsVpL33R
                7fwF2qNZeG+TgR4T8kVY9ha34zARAxcqSQgDet5V/8/ioqcVXjb9pvihFmDSa1zDXfaRUR
                h8Q+k60VAGS1lKKTurXJd9YAyoi64sts8PPgDspzlibTiVZ812Uoa40HmqoI/Tjt9E/SVJ
                3vAiYWWR0pzQ7C4fj/EUINhZeeG0cs5VYHr2P2AD5AGwP6eEEBLs+yG/W3JTErLZAQIfuu
                R1xQrKDEZ73rdKY8KnozinRf+PrvO2fCo+sjt9HNvchwoQr3i+UpM9i4kW8iqiN1mG58v3
                WkW1rjxfBDXajv2qprrZTaH82zPsd4XzzTCZMvj/P4NejCM8xjHvDl721JLpsZ7+aWNXXM
                thiKtbhUSqjPfp2nYH+2gqnzkc3mhQ+5tsqasFHRAAAFiEgjErxIIxK8AAAAB3NzaC1yc2
                EAAAGBAMOX98Fia0fE0u7kADxG6DGo2uyvs08otatKSoNhqq1SeyzPoHiB1txgwgTucy0E
                mVVZmkZEY4hCMLx4eAvygFWe039nJrorCTWN+jDzQffrvExRiYP07FaS990e38BdqjWXhv
                k4EeE/JFWPYWt+MwEQMXKkkIA3reVf/P4qKnFV42/ab4oRZg0mtcw132kVEYfEPpOtFQBk
                tZSik7q1yXfWAMqIuuLLbPDz4A7Kc5Ym04lWfNdlKGuNB5qqCP047fRP0lSd7wImFlkdKc
                0OwuH4/xFCDYWXnhtHLOVWB69j9gA+QBsD+nhBAS7Pshv1tyUxKy2QECH7rkdcUKygxGe9
                63SmPCp6M4p0X/j67ztnwqPrI7fRzb3IcKEK94vlKTPYuJFvIqojdZhufL91pFta48XwQ1
                2o79qqa62U2h/Nsz7HeF880wmTL4/z+DXowjPMYx7w5e9tSS6bGe/mljV1zLYYirW4VEqo
                z36dp2B/toKp85HN5oUPubbKmrBR0QAAAAMBAAEAAAGAOMI+yUWQMDFzrJNJZjSFaPPBI/
                IQrKX5og1a9ik/aDCJQgW2YYH8IdOKOfggQC4XeOcZl858u6vJjMfAvmbOywneAhii6l9W
                us3Kjq3otNMZv2Ph7gMDGlRnzSkKcT49CHRCXMvilGTIXHPRJ2plzqcuUkBjFnIR6oAiYH
                dH/b+Y0nqm54AJB0P2eZ4giNPuVGGkbyJI9+ZBszJCgGoEXtwhOqTW5r11ja6XlHM3e5kk
                xbPtYmwegKdaT42MMj90ey2+noNDFzgbH5flJKIB4EJNEI48KfcGqikAUiM4gNDYwUTY6h
                cqqKR6JdRvfXlhSUPgErtnvjGWElUfxbOJaqprLQVLYhEJa5x/ZvKiFAfzngsDqo1dODqI
                QYBqELWu4cTqKJzBJifWOnO44tsb/H0ADKLtq+qle6DAkrPEYMFuxTKtRuvfCE7pErnfCX
                OtG0h9aRd8XxC1A7YM6kWIKsWM/RzATGxp1FSKqvxrf+H+XnXUqRZCRb5xTLXiYLABAAAA
                wQCjeROy8nKgbdwe/5ws5yUcBl7wh4s1bTGVSVHQmn5vtwQ9sR+neJFDlIwj9GQx9UbNvj
                TpKr80lksiAdPQCN7rG3UH9GbWzO5sfoDCSf0L3ri3uGy7ddmf7lNjNjXTXlt+/pFuZDZF
                2Z2v5XbRTHLVSjuWlIzo5YOyX+bINBejGVxc0yWtXu1vR7SgffBTeWVxk+CDSsoqdNzwBs
                ohEf2azpgANVS/IXiBrMMT5jhaMcwTa4WIFdb/uNrKdDY+HG4AAADBAPu2opGzYmh5LRV5
                CvzVj+dBaVdtfB6pSP1ruY0xlQVQLytS0Ky4+z1ojlEXBqgU/B0gaffmfR6vohqw60/dWH
                755MOiz9QkS6QoHex+ZeA95EiPFdf0paWm6muZNJ7VZgq3b+Ar12IOR+naK876vTbfZpVM
                yK2ax5fqAQlSORmYKy8upvNK+vR0BUHwIqbpfz19mAMX39tva78OJAnfBsOcYK0UxoYHXP
                +SkoCdUgmBwfC7s1PcZa+OziE/hG05gQAAAMEAxuysim+MbqpEqwHhGfJqKmSzmP6+rpS6
                YXZoBZRFz+JhfwtV0MWkliYwOviJnPLrZsLMRC4odieeY2K0m/VR0bkLTXoW3nJlZo4DtI
                hCuyqgi1pO5YfRP/Okk4AW9gDFucHLBwzxKW6wP8UG17ZH/GHn8Ki5kNk8qfChhAe8gSMK
                5IeHH2rU4FsMPOgpZwIwQ/S0GKHJjOIbgw39FRU7EUjNDXy79ZWVQsNVF/dcoa4aCgbC/T
                X5Y9tWNMUrcSBRAAAAC2FsZXhAQWxleFBDAQIDBAUGBw==
                -----END OPENSSH PRIVATE KEY-----
            EOT
        }
      + name                      = "vpc-each2"
      + network_acceleration_type = "standard"
      + platform_id               = "standard-v2"
      + service_account_id        = (known after apply)
      + status                    = (known after apply)
      + zone                      = "ru-central1-a"

      + boot_disk {
          + auto_delete = true
          + device_name = (known after apply)
          + disk_id     = (known after apply)
          + mode        = (known after apply)

          + initialize_params {
              + block_size  = (known after apply)
              + description = (known after apply)
              + image_id    = "fd80viupr3qjr5g6g9du"
              + name        = (known after apply)
              + size        = 40
              + snapshot_id = (known after apply)
              + type        = "network-hdd"
            }
        }

      + network_interface {
          + index              = (known after apply)
          + ip_address         = (known after apply)
          + ipv4               = true
          + ipv6               = (known after apply)
          + ipv6_address       = (known after apply)
          + mac_address        = (known after apply)
          + nat                = true
          + nat_ip_address     = (known after apply)
          + nat_ip_version     = (known after apply)
          + security_group_ids = (known after apply)
          + subnet_id          = (known after apply)
        }

      + placement_policy {
          + host_affinity_rules = (known after apply)
          + placement_group_id  = (known after apply)
        }

      + resources {
          + core_fraction = 20
          + cores         = 4
          + memory        = 2
        }

      + scheduling_policy {
          + preemptible = (known after apply)
        }
    }

  # yandex_iam_service_account.sa will be created
  + resource "yandex_iam_service_account" "sa" {
      + created_at = (known after apply)
      + folder_id  = "b1g4inuvv0jlp45umhpf"
      + id         = (known after apply)
      + name       = "service-account"
    }

  # yandex_iam_service_account_static_access_key.sa-static-key will be created
  + resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
      + access_key           = (known after apply)
      + created_at           = (known after apply)
      + description          = "static access key for object storage"
      + encrypted_secret_key = (known after apply)
      + id                   = (known after apply)
      + key_fingerprint      = (known after apply)
      + secret_key           = (sensitive value)
      + service_account_id   = (known after apply)
    }

  # yandex_resourcemanager_folder_iam_member.sa-editor will be created
  + resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
      + folder_id = "b1g4inuvv0jlp45umhpf"
      + id        = (known after apply)
      + member    = (known after apply)
      + role      = "storage.editor"
    }

  # yandex_storage_bucket.test will be created
  + resource "yandex_storage_bucket" "test" {
      + access_key            = (known after apply)
      + acl                   = "private"
      + bucket                = "pukoff-bucket"
      + bucket_domain_name    = (known after apply)
      + default_storage_class = (known after apply)
      + folder_id             = (known after apply)
      + force_destroy         = false
      + id                    = (known after apply)
      + secret_key            = (sensitive value)
      + website_domain        = (known after apply)
      + website_endpoint      = (known after apply)

      + anonymous_access_flags {
          + list = (known after apply)
          + read = (known after apply)
        }

      + versioning {
          + enabled = (known after apply)
        }
    }

  # yandex_vpc_network.my_network will be created
  + resource "yandex_vpc_network" "my_network" {
      + created_at                = (known after apply)
      + default_security_group_id = (known after apply)
      + folder_id                 = (known after apply)
      + id                        = (known after apply)
      + labels                    = (known after apply)
      + name                      = "my_network"
      + subnet_ids                = (known after apply)
    }

  # yandex_vpc_subnet.my_subnet will be created
  + resource "yandex_vpc_subnet" "my_subnet" {
      + created_at     = (known after apply)
      + folder_id      = (known after apply)
      + id             = (known after apply)
      + labels         = (known after apply)
      + name           = "my_subnet"
      + network_id     = (known after apply)
      + v4_cidr_blocks = [
          + "10.130.0.0/16",
        ]
      + v6_cidr_blocks = (known after apply)
      + zone           = "ru-central1-a"
    }

Plan: 10 to add, 0 to change, 0 to destroy.

─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run "terraform apply" now.
alex@AlexPC:~/GitHub/DevOps/IaC/terraform$ ^C
```

```
