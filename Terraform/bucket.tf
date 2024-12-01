#? Creación del bucket para hacerlo servidor web
resource "aws_s3_bucket" "CadenaHoteleraBucket" {
  bucket = "asccadenahotelerabucket"
  force_destroy = true

  tags = {
    Name        = "Cadena Hotelera Bucket"
    Environment = "Dev"
  }
}

#? Creación de la política
data "aws_iam_policy_document" "allow_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["123456789012"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      aws_s3_bucket.CadenaHoteleraBucket.arn,
      "${aws_s3_bucket.CadenaHoteleraBucket.arn}/*",
    ]
  }
}

#? Asociación de la política al bucket
resource "aws_s3_bucket_policy" "public_bucket" {
  bucket = aws_s3_bucket.CadenaHoteleraBucket.id
  policy = data.aws_iam_policy_document.allow_access.json
}

#? Hacerlo servidor web
resource "aws_s3_bucket_website_configuration" "bucket-web-config" {
  bucket = aws_s3_bucket.CadenaHoteleraBucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

#? Soy el propietario del bucket
resource "aws_s3_bucket_ownership_controls" "bucket-owner" {
  bucket = aws_s3_bucket.CadenaHoteleraBucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#? Deshabilito la seguridad por defecto del Bucket S3 para hacer los objetos publicos
resource "aws_s3_bucket_acl" "bucket-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket-owner
  ]

  bucket = aws_s3_bucket.CadenaHoteleraBucket.id
  acl    = "public-read"
}

# Output para la URL del bucket S3
output "s3_bucket_website_url" {
  value = "http://${aws_s3_bucket.CadenaHoteleraBucket.bucket}.s3-website-us-east-1.amazonaws.com"
}