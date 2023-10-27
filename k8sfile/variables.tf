variable "location" {
    default = "eu-north-1"
}

variable "os_name" {
    default = "ami-0d2ca4d7e5645e504"
}

variable "key" {
    default = "k8s_cluster"
}

variable "instance-type" {
    default = "t3.micro"
}

variable "vpc-cidr" {
    default = "10.10.0.0/16"  
}

variable "subnet1-cidr" {
    default = "10.10.1.0/24"
  
}

variable "subnet2-cidr" {
    default = "10.10.2.0/24"
  
}
variable "subent_az-1" {
    default =  "eu-north-1a"  
}

variable "subent_az-2" {
    default =  "eu-north-1b"  
}