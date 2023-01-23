locals {
  public_endpoints = true
}

data "aws_partition" "current" {}

resource "aws_instance" "bastion" {
  ami = var.ami

  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = local.public_endpoints

  key_name = var.cluster_id
  
  user_data = data.template_cloudinit_config.bastion.rendered

  lifecycle {
    ignore_changes = [ami]
  }

  tags = merge(
    {
      "Name" = "${var.cluster_id}-bastion"
    },
    var.tags,
  )

  root_block_device {
    volume_type = var.volume_type
    volume_size = var.volume_size
    iops        = var.volume_type == "io1" ? var.volume_iops : 0
  }

  volume_tags = merge(
    {
      "Name" = "${var.cluster_id}-bastion-vol"
    },
    var.tags,
  )
}

data "template_cloudinit_config" "bastion" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = <<EOF
    preserve_hostname: false
    fqdn: bastion
    hostname: bastion
EOF
  }
}
