data "cloudflare_zone" "razumovsky_me_zone" {
  name = local.domain_name
}

resource "cloudflare_record" "prom_server_dns" {
  zone_id = data.cloudflare_zone.razumovsky_me_zone.id
  name    = local.prometheus_server.subdomain
  content = module.prometheus_server_vm.public_ip_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "linux_target_dns" {
  zone_id = data.cloudflare_zone.razumovsky_me_zone.id
  name    = local.linux_target.subdomain
  content = module.linux_target_vm.public_ip_address
  type    = "A"
  proxied = false
}

resource "cloudflare_record" "windows_target_dns" {
  zone_id = data.cloudflare_zone.razumovsky_me_zone.id
  name    = local.windows_target.subdomain
  content = module.windows_target_vm.public_ip_address
  type    = "A"
  proxied = false
}