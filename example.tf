provider "aws" {
    // Set AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY env vars
    region = "eu-west-1"
}

# VPC

resource "aws_vpc" "ross-tf-test" {
    cidr_block = "10.0.0.0/16"
    tags {
        Name = "ross-tf-test"
    }
}

resource "aws_subnet" "ross-tf-test" {
    vpc_id = "${aws_vpc.ross-tf-test.id}"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true

    tags {
        Name = "ross-tf-test"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = "${aws_vpc.ross-tf-test.id}"

    tags {
        Name = "ross-tf-test"
    }
}

resource "aws_route_table" "ross-tf-test" {
    vpc_id = "${aws_vpc.ross-tf-test.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.main.id}"
    }

    tags {
        Name = "ross-tf-test"
    }
}

resource "aws_main_route_table_association" "main" {
    vpc_id = "${aws_vpc.ross-tf-test.id}"
    route_table_id = "${aws_route_table.ross-tf-test.id}"
}

resource "aws_security_group" "ross-tf-test" {
    name = "ross-tf-test"
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    vpc_id = "${aws_vpc.ross-tf-test.id}"
}

# Key Pair
resource "aws_key_pair" "ross-tf-test" {
    key_name = "aws_tf"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDRSo6riKlmhjCVcT4284ZEDKDcz5Ij2NvN3kliSmKVXpQVuXBXvSrq/tlxRysBxoRPJHywWw8FO1WT5petrCHNdYVrGSMSkP5/+e0SqanEaMaIxT7OL4Hi7SYMHA5iQn6EnToJt/kMXRrvYKqtp59rrmqRax6Uw8eZUcY8QFGM7MCW0oh0NR2GfFDHJvUXAfJ1m00H+qdNLE9A7MRvbRJuS8RJSzjCxSt2RDNaa8tQJ30RMR6f2AEI10zZ96jcCt1Oga8sVnXcOnGb3XRzOoLZP0+XvAIyBAaC2sqD4j0lRGfv3/V+eIaVzyyfz48nu61KuMmm1fpxsDqV1Xlivj+T rkippenbrock@localhost.localdomain"
}

resource "aws_instance" "ross-tf-test" {
    ami           = "ami-2c3e7b5f"
    instance_type = "m1.small"
    key_name = "${aws_key_pair.ross-tf-test.key_name}"
    security_groups = [
        "${aws_security_group.ross-tf-test.id}"
    ]
    subnet_id = "${aws_subnet.ross-tf-test.id}"
    tags {
        Name = "ross-tf-test-server"
    }

}

resource "aws_eip" "ross-tf-test" {
    instance = "${aws_instance.ross-tf-test.id}"
}
