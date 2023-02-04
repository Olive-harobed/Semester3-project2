resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = var.ssh_key
  public_key = tls_private_key.main.public_key_openssh
}

resource "local_file" "ssh_key" {
  content = tls_private_key.main.private_key_pem
  #content = "${tls_private_key.main.private_key_pem}\n${tls_private_key.main.public_key_openssh}"

  filename = "${var.ssh_key}.pem"
  file_permission = "0400"
}

resource "aws_instance" "ec2_instances" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = "t2.micro"

  subnet_id = element(data.aws_subnets.public_subnets.ids, count.index)
  vpc_security_group_ids = [var.security_group_id]
  associate_public_ip_address   = true
  key_name                      = var.ssh_key
  provisioner "local-exec" {
    command = "echo '${self.public_ip}' >> ./host-inventory"
  }

  tags = {
    Name = "ec2_instance_${count.index + 1}"
  }


 
}

resource "null_resource" "ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook --private-key ${var.ssh_key}.pem main.yml"
  }

  depends_on = [aws_instance.ec2_instances]
} 
 
 
resource "aws_security_group_rule" "alb_to_instances" {
  depends_on = [aws_alb.alb]

  security_group_id = var.security_group_id
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = var.security_group_rule_cidr_blocks
}

output "host_inventory" {
  value = aws_instance.ec2_instances.*.public_ip
}