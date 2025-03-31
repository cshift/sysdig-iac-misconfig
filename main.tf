provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "public_bucket" {
  bucket = "example-public-bucket"
  acl    = "public-read"
}

resource "aws_security_group" "insecure_sg" {
  name        = "insecure_sg"
  description = "Overly permissive security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_policy" "overly_permissive" {
  name        = "overly_permissive_policy"
  description = "IAM policy granting full access"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*" 
    }
  ]
}
EOF
}
resource "aws_s3_bucket_public_access_block" "public_bucket" {
  block_public_acls       = true
  block_public_policy     = true
  bucket                  = aws_s3_bucket.public_bucket.id
  ignore_public_acls      = true
  restrict_public_buckets = true
}
