variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-west-2"
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "web-sg" {
    name = "web-sg"
    ingress {
    from_port = 8 // ICMP Type "Echo Request"
    to_port = 0 // ICMP Type "Echo Reply"
    protocol = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "web" {
    ami           = "ami-db710fa3"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.web-sg.name}"]
}
