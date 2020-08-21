resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.s3_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "policy_document" {
  statement {
    sid = "AllowCF"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.cloudfront_oai.iam_arn]
    }
  }

  statement {
    sid     = "AllowAWSUser"
    actions = ["s3:*"]
    effect  = "Allow"
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    condition {
      test     = "StringLike"
      variable = "aws:userId"
      values   = [var.aws_account_id]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket     = aws_s3_bucket.s3_bucket.id
  policy     = data.aws_iam_policy_document.policy_document.json
  depends_on = [aws_s3_bucket_public_access_block.s3_public_access_block]
}

resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
