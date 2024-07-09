output "tunnel_name" {
  value = module.cloudflare_tunnel.tunnel_name
}

output "secret" {
  value     = module.cloudflare_tunnel.cloudflare_tunnel_secret
  sensitive = true
}

output "tunnel_id" {
  value     = module.cloudflare_tunnel.cloudflare_tunnel_id
  sensitive = true
}