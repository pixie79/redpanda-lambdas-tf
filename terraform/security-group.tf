resource "aws_security_group" "this" {
  name        = local.generic_name
  description = local.generic_name
  vpc_id      = data.aws_vpc.this.id

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "UDP"
    description = "Allow DNS TCP outgoing to networking vpc"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "TCP"
    description = "Allow DNS TCP outgoing to networking vpc"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    description = "Allow HTTPS TCP outgoing to networking vpc"
    cidr_blocks = [data.aws_vpc.this.cidr_block, var.kafka_vpc_cidr]
  }

  egress {
    from_port   = 9001
    to_port     = 9001
    protocol    = "TCP"
    description = "Allow next iteration"
    cidr_blocks = [var.kafka_vpc_cidr]
  }

  egress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "TCP"
    description = "Allow kafka outgoing"
    cidr_blocks = [var.kafka_vpc_cidr]
  }

  egress {
    from_port   = 30092
    to_port     = 30092
    protocol    = "TCP"
    description = "Allow kafka outgoing"
    cidr_blocks = [var.kafka_vpc_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    description = "Allow traffic from Kafka"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    description = "Allow traffic from Kafka"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }

  ingress {
    from_port   = 30092
    to_port     = 30092
    protocol    = "tcp"
    description = "Allow traffic from Kafka"
    cidr_blocks = [data.aws_vpc.this.cidr_block]
  }
}
