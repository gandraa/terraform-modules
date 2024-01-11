data "aws_ssm_parameter" "bastion_ami_version" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

data "aws_security_group" "postgres_sgs" {
  for_each = toset(var.postgres_sg_names)
    name = each.key
}

locals {
  sg_ids = [for sg in data.aws_security_group.postgres_sgs : sg.id]
  source =  concat(var.cidr_blocks, local.sg_ids) 
}

resource "aws_iam_role" "bastion_instance_role" {
  name = "${join("-", ["bastion", "host", var.account_name])}"
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

resource "aws_iam_policy" "s3_automation_blobstore_policy" {
  name     = "s3BucketAutomationBlobstoreAccess"
  policy   = templatefile("${path.module}/../assets/policies/eks-binary-automation-blobstore-access.json", { resources = var.blobstore_s3_bucket })
}

resource "aws_iam_role_policy_attachment" "s3_automation_blobstore_policy_attachments" {
  policy_arn = aws_iam_policy.s3_automation_blobstore_policy.arn
  role       = aws_iam_role.bastion_instance_role.name
}

resource "aws_iam_instance_profile" "bastion_instance_profile" {
  name = "bastion_instance_profile"
  path = "/"
  role = aws_iam_role.bastion_instance_role.name
}

resource "aws_instance" "bastion_ec2_instance" {
  instance_type           = var.instance_type
  ami                     = data.aws_ssm_parameter.bastion_ami_version.value
  iam_instance_profile    = aws_iam_instance_profile.bastion_instance_profile.name
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = [aws_security_group.bastion_host_sg.id]
  associate_public_ip_address = false
  root_block_device {
    volume_size = var.volume_size_sda
    encrypted   = true
  }
  tags = {
    Name = "${var.instance_name}-${var.account_name}"
  }
}

resource "aws_security_group" "bastion_host_sg" {
  description = "Bastion hosts Security Group"
  name = "bastion-host"
  vpc_id      = var.vpc_id
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  for_each = toset(local.source)
    description = "outbound rule for the destination ${each.key}" 
    security_group_id = aws_security_group.bastion_host_sg.id
    from_port = substr(each.key,0,2) == "sg" ? 5432 : 443
    to_port = substr(each.key,0,2) == "sg" ? 5432 : 443
    ip_protocol = "tcp"
    cidr_ipv4 = substr(each.key,0,2) != "sg" ? each.key : null
    referenced_security_group_id = substr(each.key,0,2) == "sg" ? each.key : null
}