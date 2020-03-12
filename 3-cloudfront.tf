resource "aws_cloudfront_distribution" "this" {
  count = "${var.environmentNumber}"
  origin {
    domain_name = "${aws_s3_bucket.this[count.index].website_endpoint}"
    origin_id   = "S3-Website-${aws_s3_bucket.this[count.index].website_endpoint}"
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "http-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2", ]

    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Some comment"
  default_root_object = "index.html"
  aliases             = ["${aws_s3_bucket.this[count.index].bucket}"]
  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-Website-${aws_s3_bucket.this[count.index].website_endpoint}"
    compress         = true
    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https" ## Redirect Http requests to Https 
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }


  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "${var.project}-${var.environment[count.index]}"
  }

  viewer_certificate {
    minimum_protocol_version = "TLSv1.1_2016"
    ssl_support_method       = "sni-only"
    acm_certificate_arn      = "${aws_acm_certificate.this[count.index].arn}"
  }

}
