output "cf_distro_url" {
  value = aws_cloudfront_distribution.cloudfront.domain_name
}
