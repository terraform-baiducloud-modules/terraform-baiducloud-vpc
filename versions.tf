terraform {
  required_version = ">= 1.12"
  required_providers {
    baiducloud = {
      source  = "baiducloud/baiducloud"
      version = "~> 1.22"
    }
  }
}
