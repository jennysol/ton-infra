resource "aws_cloudfront_distribution" "cdn" {
  enabled = true

  aliases = [local.domain_name]

  origin {
    domain_name = aws_elastic_beanstalk_environment.environment.cname
    origin_id = "elastic-beanstalk-origin"
    
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id = "elastic-beanstalk-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["*"]
    }

    min_ttl = 0
    default_ttl = 0
    max_ttl = 0
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  http_version = "http2"
}

resource "aws_route53_record" "app" {
  zone_id = local.route53_zone_id
  name = local.domain_name
  type = "A"

  alias {
    name = aws_cloudfront_distribution.cdn.domain_name
    zone_id = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
