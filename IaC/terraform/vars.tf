variable "yc_token" {
  type = string
}
variable "yc_cloud_id" {
  type = string
}
variable "yc_folder_id" {
  type = string
}
variable "yc_zone" {
  type = string
}
locals {
  platform = {
    default = "standard-v1"
    stage = "standard-v2"
    prod = "standard-v3"
  }
  cores = {
    default = 2
    stage = 2
    prod = 4
  }
  memory = {
    default = 1
    stage = 2
    prod = 2
  }
  disk_size = {
    default = 10
    stage = 20
    prod = 40
  }
  instance_count = {
    default = 1
    stage = 1
    prod = 2
  }
  each_instances = {
    "each1" = "standard-v1"
    "each2" = "standard-v2"
  }
}

