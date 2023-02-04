resource "aws_route53_zone" "domain" {
  name = var.domain_names.domain_name
}

resource "aws_route53_record" "subdomain_a_record" {
  zone_id = aws_route53_zone.domain.zone_id
  name = var.domain_names.subdomain_name
  type = "A"

  alias {
    name = aws_alb.alb.dns_name
    zone_id = aws_alb.alb.zone_id
    evaluate_target_health = true
  }
}
 
 