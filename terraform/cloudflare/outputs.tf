output "cloudflare_tunnel_secret" {
  value     = cloudflare_tunnel.auto_tunnel.secret
  sensitive = true
}

output "cloudflare_tunnel_id" {
  value = cloudflare_tunnel.auto_tunnel.id
  sensitive = true
}