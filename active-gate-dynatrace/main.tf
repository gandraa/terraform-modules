data "aws_ssm_parameter" "active_gate_ami_version" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_ssm_parameter" "active_gate_api_key" {
  name = var.downoad_token_path
}

resource "aws_iam_role" "active_gate_role" {
  name = "${join("-", ["active", "gate", "role"])}"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": [
            "ec2.amazonaws.com"
          ]
        },
        "Action": [
          "sts:AssumeRole"
        ]
      }
    ]
  })
  managed_policy_arns  = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
}

resource "aws_iam_instance_profile" "active_gate_instance_profile" {
  name = "${join("-", ["active", "gate", "profile"])}"
  path = "/"
  role = aws_iam_role.active_gate_role.name
}

resource "aws_security_group" "active_gate_sg" {
  description = "Active Gate Security Group"
  name = "${join("-", ["active", "gate", "security", "group"])}"
  vpc_id = var.vpc_id

  egress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    cidr_blocks     = var.cidr_blocks
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "active_gate_ec2_instance" {
  instance_type           = var.instance_type
  ami                     = data.aws_ssm_parameter.active_gate_ami_version.value
  iam_instance_profile    = aws_iam_instance_profile.active_gate_instance_profile.name
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [aws_security_group.active_gate_sg.id]
  user_data               = base64encode(templatefile("${path.module}/../assets/scripts/active_gate.sh", {
    api_token             = data.aws_ssm_parameter.active_gate_api_key.value,
    dynatrace_url         = var.dynatrace_url,
    dynatrace_network_zone = var.dynatrace_network_zone,
    dynatrace_active_gate_group = var.dynatrace_active_gate_group
  }))

  associate_public_ip_address = false
  root_block_device {
    volume_size = var.volume_size_sda
    encrypted   = true
  }
  tags = {
    Name = "${var.instance_name}-${var.account_name}"
  }

  depends_on = [ aws_security_group.active_gate_sg ]
}