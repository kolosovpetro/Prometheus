resource "cloudflare_dns_record" "prom_server_dns" {
  zone_id = local.zone_id
  name    = local.prometheus_server.subdomain
  content = module.prometheus_server_vm.public_ip_address
  comment = "Managed by terraform"
  type    = "A"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "linux_target_dns" {
  zone_id = local.zone_id
  name    = local.linux_target.subdomain
  content = module.linux_target_vm.public_ip_address
  comment = "Managed by terraform"
  type    = "A"
  proxied = false
  ttl     = 1
}

resource "cloudflare_dns_record" "windows_target_dns" {
  zone_id = local.zone_id
  name    = local.windows_target.subdomain
  content = module.windows_target_vm.public_ip_address
  comment = "Managed by terraform"
  type    = "A"
  proxied = false
  ttl     = 1
}