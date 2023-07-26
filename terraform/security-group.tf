locals {
  inbound_ports  = []
  outbound_ports = [53, 443, 9092, 30081, 30092]
}

resource "aws_security_group" "this" {
  name        = local.generic_name
  description = local.generic_name
  vpc_id      = data.aws_vpc.this.id

  dynamic "egress" {
    for_each = local.outbound_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      description = "Allow ${egress.value} TCP outgoing to local and kafka vpc"
      cidr_blocks = [data.aws_vpc.this.cidr_block, var.kafka_vpc_cidr]
    }
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "UDP"
    description = "Allow DNS TCP outgoing to networking vpc"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  dynamic "ingress" {
    for_each = local.inbound_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      description = "Allow ${ingress.value} TCP incomming from local vpc"
      cidr_blocks = [data.aws_vpc.this.cidr_block]
    }
  }
}
