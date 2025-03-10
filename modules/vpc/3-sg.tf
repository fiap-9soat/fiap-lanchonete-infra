resource "aws_security_group" "eks" {
  name_prefix = "${local.name}-eks"
  description = "Allow MySQL inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "TLS from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  tags = merge(local.tags, {
    Name = "eks-sg"
  })
}
