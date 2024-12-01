#? Creación del bucket para hacerlo servidor web
resource "aws_s3_bucket" "CadenaHoteleraBucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = "Cadena Hotelera Bucket"
    Environment = "Dev"
  }
}

#? Creación de la política
resource "aws_s3_bucket_policy" "allow_access" {
  bucket = aws_s3_bucket.CadenaHoteleraBucket.id

  policy = jsonencode(
    {
      "Id" : "Policy1733051191073",
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Stmt1733051188897",
          "Action" : [
            "s3:GetObject"
          ],
          "Effect" : "Allow",
          "Resource" : "arn:aws:s3:::${aws_s3_bucket.CadenaHoteleraBucket.bucket}/*",
          "Principal" : "*"
        }
      ]
    }
  )
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

#? Para hacer el bucket público
resource "aws_s3_bucket_public_access_block" "bucket-public-access" {
  bucket = aws_s3_bucket.CadenaHoteleraBucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#? Deshabilito la seguridad por defecto del Bucket S3 para hacer los objetos publicos
resource "aws_s3_bucket_acl" "bucket-acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket-owner,
    aws_s3_bucket_public_access_block.bucket-public-access,
  ]

  bucket = aws_s3_bucket.CadenaHoteleraBucket.id
  acl    = "public-read"
}

# Output para la URL del bucket S3
output "s3_bucket_website_url" {
  value = "http://${aws_s3_bucket.CadenaHoteleraBucket.bucket}.s3-website-us-east-1.amazonaws.com"
}
