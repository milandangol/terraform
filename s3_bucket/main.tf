resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  tags = {
    Name = "My-Bucket"
  }

}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_own" {

  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_public_access_block" "s3_pb" {
  bucket = aws_s3_bucket.s3_bucket.id
}

resource "aws_s3_bucket_acl" "s3_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.s3_bucket_own,
    aws_s3_bucket_public_access_block.s3_pb,
  ]

  bucket = aws_s3_bucket.s3_bucket.id
  acl    = "public-read"
}

resource "aws_s3_bucket_website_configuration" "s3_website" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = var.resume
  }

  error_document {
    key = var.resume
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = var.resume
  source       = var.resume
  acl          = aws_s3_bucket_acl.s3_acl.acl
  content_type = "text/html"
}


resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.s3_bucket.id
  key          = var.resume
  source       = var.resume
  acl          = aws_s3_bucket_acl.s3_acl.acl
  content_type = "text/html"
}



resource "aws_s3_object" "pic" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = var.images
  source = var.images
  acl    = aws_s3_bucket_acl.s3_acl.acl

}

resource "aws_s3_object" "js" {
  bucket = aws_s3_bucket.s3_bucket.id
  key    = var.js
  source = var.js
  acl    = aws_s3_bucket_acl.s3_acl.acl

}

