resource "aws_route53_zone" "certificate_route53_zone" {
  name         = "lakshmipriyanka.xyz"
}

resource "aws_acm_certificate" "certificate" {
  domain_name               = "lakshmipriyanka.xyz"
  subject_alternative_names = ["*.lakshmipriyanka.xyz"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_dns" {
  for_each = {
    for robo in aws_acm_certificate.certificate.domain_validation_options : robo.domain_name => {
      name   = robo.resource_record_name
      record = robo.resource_record_value
      type   = robo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.certificate_route53_zone.zone_id
}

resource "aws_acm_certificate_validation" "certificate" {
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_dns : record.fqdn]
}


resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.certificate_route53_zone.zone_id
  name    = "www.lakshmipriyanka.xyz"
  type    = "A"
  alias {
    name = aws_lb.applicationloadbalancer.dns_name
    zone_id = aws_lb.applicationloadbalancer.zone_id
    evaluate_target_health = true
  }
}