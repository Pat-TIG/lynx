variable "aws_region" {
  type        = string
  description = "The target AWS region for the cluster."
  default     = "ca-central-1"
}

variable "key_pair_path" {
  type = map
  default = {
    public_key_path = "~/.ssh/id_rsa.pub",
    private_key_path = "~/.ssh/id_rsa",
  }
  description = "The ssh keys to be used for all nodes."
}

variable "cluster_name" {
  type = string
}

variable "dns_domain" {
  type = string
}

variable "pg_password" {
  type = string
}

variable "aws_bastion_instance_type" {
  type        = string
  description = "Instance type for the bastion node. Example: `m4.large`."
  default     = "t3.micro"
}

variable "source_subnet" {
  type        = string
  description = "Subnet from which to allow ssh etc"
  default     = "50.64.0.0/13"
}
