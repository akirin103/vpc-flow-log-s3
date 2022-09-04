resource "aws_s3_bucket" "this" {
  bucket_prefix = "${var.system_name}-${var.env}-bucket"
}
