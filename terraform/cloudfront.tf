resource "aws_cloudfront_origin_access_identity" "cloudfront_oai" {
  comment = aws_s3_bucket.s3_bucket.id
}

resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.s3_bucket.id
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_oai.cloudfront_access_identity_path
    }
  }

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true

    forwarded_values {
      cookies {
        forward = "all"
      }
      query_string = true
    }

    target_origin_id       = aws_s3_bucket.s3_bucket.id
    viewer_protocol_policy = "redirect-to-https"

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = aws_lambda_function.origin_request_lambda.qualified_arn
      include_body = false
    }

    lambda_function_association {
      event_type   = "origin-response"
      lambda_arn   = aws_lambda_function.origin_response_lambda.qualified_arn
      include_body = false
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  custom_error_response {
    error_code         = 404
    response_page_path = "/404.html"
    response_code      = 404
  }

  custom_error_response {
    error_code         = 403
    response_page_path = "/404.html"
    response_code      = 404
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
