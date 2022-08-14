resource "yandex_vpc_network" "my_network" {
  name = "my_network"
}

resource "yandex_vpc_subnet" "my_subnet" {
  name = "my_subnet"
  v4_cidr_blocks = ["10.130.0.0/16"]
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.my_network.id
}
