resource "yandex_compute_instance" "vpc" {
  name = "vpc"
  zone = "ru-central1-a"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = "fd80viupr3qjr5g6g9du"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.my_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/yc.pub")}"
  }
}


