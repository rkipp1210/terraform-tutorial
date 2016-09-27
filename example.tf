provider "aws" {
    access_key = "$AWS_ACCESS_KEY_ID"
    secret_key = "$AWS_SECRET_ACCESS_KEY"
    region     = "us-west-1"
}

resource "aws_instance" "example" {
    ami           = "ami-0d729a60"
    instance_type = "t2.micro"
}
