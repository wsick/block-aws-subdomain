// Environmental subdomain zone
resource "aws_route53_zone" "env" {
  name = "${var.subdomain}.${var.env}.${data.terraform_remote_state.domain.outputs.name}"

  tags = {
    Stack       = var.stack_name
    Environment = var.env
    Block       = var.block_name
  }
}

// {subdomain}.{env}.{domain}
// This record is added to the domain's zone to delegate this subdomain's records
resource "aws_route53_record" "env-delegation" {
  provider = aws.domain

  name    = "${var.subdomain}.${var.env}"
  zone_id = data.terraform_remote_state.domain.outputs.zone_id
  type    = "NS"
  ttl     = 300
  records = aws_route53_zone.env.name_servers
}