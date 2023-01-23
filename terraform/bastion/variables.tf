variable "ami" {
  type        = string
  description = "The AMI ID for the bootstrap node."
  default     = "ami-03060448f5c8f2199"
}

variable "source_subnet" {
  type        = string
  description = "Subnet to allow things like ssh from"
}

variable "cluster_id" {
  type        = string
  description = "The identifier for the cluster."
}

variable "instance_type" {
  type        = string
  description = "The instance type of the bastion node."
}

variable "subnet_id" {
  type        = string
  description = "The subnet ID for the bastion node."
}

variable "ssh_key" {
  type = string
  description = "Public ssh key to provsion on instance"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "AWS tags to be applied to created resources."
}

variable "volume_iops" {
  type        = string
  default     = "100"
  description = "The amount of IOPS to provision for the disk."
}

variable "volume_size" {
  type        = string
  default     = "30"
  description = "The volume size (in gibibytes) for the bastion node's root volume."
}

variable "volume_type" {
  type        = string
  default     = "gp2"
  description = "The volume type for the bastion node's root volume."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID is used to create resources like security group rules for bastion machine."
}

variable "vpc_cidrs" {
  type        = list(string)
  default     = []
  description = "VPC CIDR blocks."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  default     = []
  description = "VPC security group IDs for the bastion node."
}
