resource "aws_s3_bucket" "example" {
  bucket = "jennifer-${local.project}-deploy"
}