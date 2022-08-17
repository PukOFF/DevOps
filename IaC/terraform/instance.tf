variable count_offset { default = 0 } #start numbering from X+1 (e.g. name-1 if '0', name-3 if '2', etc.)
variable count_format { default = "%01d" } #server number format (-1, -2, etc.)

resource "yandex_compute_instance" "instance" {
  name = "vpc-${terraform.workspace}-${format(var.count_format, var.count_offset+count.index+1)}"
  count = local.instance_count[terraform.workspace]
  zone = "ru-central1-a"
  platform_id = local.platform[terraform.workspace]

  lifecycle {
    create_before_destroy = true
    prevent_destroy = true
    #ignore_changes = ["tags"]
  }

  resources {
    cores  = local.cores[terraform.workspace]
    memory = local.memory[terraform.workspace]
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd80viupr3qjr5g6g9du"
      size = local.disk_size[terraform.workspace]
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

resource "yandex_compute_instance" "test-instance" {
  name = "vpc-${each.key}"
  for_each = local.each_instances
  zone = "ru-central1-a"
  platform_id = each.value

  lifecycle {
    create_before_destroy = true
    #prevent_destroy = true
    #ignore_changes = ["tags"]
  }

  resources {
    cores  = local.cores[terraform.workspace]
    memory = local.memory[terraform.workspace]
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd80viupr3qjr5g6g9du"
      size = local.disk_size[terraform.workspace]
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
